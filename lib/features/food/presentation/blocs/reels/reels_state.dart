import 'package:equatable/equatable.dart';
import '../../../domain/entities/reel_entity.dart';
import '../../../domain/entities/reel_query_params.dart';

enum ReelsStatus { initial, loading, success, failure }

class ReelsState extends Equatable {
  final ReelsStatus status;
  final List<ReelEntity> reels;
  final ReelsPaginationMetaEntity? meta;
  final ReelQueryParams currentParams;
  final bool isLoadingMore;
  final String? errorMessage;

  const ReelsState({
    this.status = ReelsStatus.initial,
    this.reels = const [],
    this.meta,
    this.currentParams = const ReelQueryParams(limit: 20, offset: 0),
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore =>
      meta?.hasMore ?? (meta != null ? (reels.length < meta!.total) : false);

  ReelsState copyWith({
    ReelsStatus? status,
    List<ReelEntity>? reels,
    ReelsPaginationMetaEntity? meta,
    ReelQueryParams? currentParams,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReelsState(
      status: status ?? this.status,
      reels: reels ?? this.reels,
      meta: meta ?? this.meta,
      currentParams: currentParams ?? this.currentParams,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    reels,
    meta,
    currentParams,
    isLoadingMore,
    errorMessage,
  ];
}
