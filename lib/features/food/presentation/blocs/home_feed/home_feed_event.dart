import 'package:equatable/equatable.dart';

sealed class HomeFeedEvent extends Equatable {
  const HomeFeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeFeed extends HomeFeedEvent {
  final double? lat;
  final double? lng;

  const LoadHomeFeed({this.lat, this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

class LoadAllCategories extends HomeFeedEvent {
  const LoadAllCategories();
}
