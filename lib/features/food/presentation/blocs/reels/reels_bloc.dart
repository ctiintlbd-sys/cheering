import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/reel_entity.dart';
import '../../../domain/usecases/get_reels_usecase.dart';
import 'reels_event.dart';
import 'reels_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetReelsUseCase _getReelsUseCase;

  ReelsBloc(this._getReelsUseCase) : super(const ReelsState()) {
    on<LoadReels>(_onLoadReels);
    on<RefreshReels>(_onRefreshReels);
    on<LoadMoreReels>(_onLoadMoreReels);
  }

  Future<void> _onLoadReels(
    LoadReels event,
    Emitter<ReelsState> emit,
  ) async {
    final params = event.params ?? state.currentParams;
    emit(
      state.copyWith(
        status: state.reels.isEmpty ? ReelsStatus.loading : ReelsStatus.success,
        currentParams: params,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<ReelsResponseEntity>(
        _getReelsUseCase(params),
        onData: (response) => state.copyWith(
          status: ReelsStatus.success,
          reels: response.reels,
          meta: response.meta,
          currentParams: params,
        ),
        onError: (error, _) => state.copyWith(
          status: state.reels.isEmpty ? ReelsStatus.failure : ReelsStatus.success,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: state.reels.isEmpty ? ReelsStatus.failure : ReelsStatus.success,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshReels(
    RefreshReels event,
    Emitter<ReelsState> emit,
  ) async {
    final params = event.params ?? state.currentParams.copyWith(offset: 0);
    try {
      await emit.forEach<ReelsResponseEntity>(
        _getReelsUseCase(params),
        onData: (response) => state.copyWith(
          status: ReelsStatus.success,
          reels: response.reels,
          meta: response.meta,
          currentParams: params,
        ),
        onError: (error, _) => state.copyWith(
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMoreReels(
    LoadMoreReels event,
    Emitter<ReelsState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;

    final nextParams = state.currentParams.copyWith(
      offset: state.reels.length,
    );

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await _getReelsUseCase(nextParams).first;
      final existingIds = state.reels.map((r) => r.id).toSet();
      final newReels =
          response.reels.where((r) => !existingIds.contains(r.id)).toList();

      emit(
        state.copyWith(
          reels: [...state.reels, ...newReels],
          meta: response.meta,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }
}
