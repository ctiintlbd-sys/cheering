import 'package:equatable/equatable.dart';
import '../../../domain/entities/reel_query_params.dart';

sealed class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object?> get props => [];
}

class LoadReels extends ReelsEvent {
  final ReelQueryParams? params;

  const LoadReels({this.params});

  @override
  List<Object?> get props => [params];
}

class RefreshReels extends ReelsEvent {
  final ReelQueryParams? params;

  const RefreshReels({this.params});

  @override
  List<Object?> get props => [params];
}

class LoadMoreReels extends ReelsEvent {
  const LoadMoreReels();
}
