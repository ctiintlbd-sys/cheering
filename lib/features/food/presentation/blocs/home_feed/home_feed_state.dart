import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/home_feed_entity.dart';
import '../../../../food/domain/entities/category_entity.dart';

enum HomeFeedStatus { initial, loading, success, failure }

class HomeFeedState extends Equatable {
  final HomeFeedStatus status;
  final HomeFeedEntity? feed;
  final List<CategoryEntity>? allCategories;
  final String? errorMessage;

  const HomeFeedState({
    this.status = HomeFeedStatus.initial,
    this.feed,
    this.allCategories,
    this.errorMessage,
  });

  HomeFeedState copyWith({
    HomeFeedStatus? status,
    HomeFeedEntity? feed,
    List<CategoryEntity>? allCategories,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeFeedState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      allCategories: allCategories ?? this.allCategories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, feed, allCategories, errorMessage];
}
