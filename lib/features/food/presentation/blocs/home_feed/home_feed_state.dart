import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/home_feed_entity.dart';
import '../../../../food/domain/entities/category_entity.dart';

enum HomeFeedStatus { initial, loading, success, failure }

class HomeFeedState extends Equatable {
  final HomeFeedStatus status;
  final HomeFeedEntity? feed;
  final List<CategoryEntity>? allCategories;
  final bool isLoadingAllCategories;
  final String? errorMessage;
  final String? categoriesErrorMessage;

  const HomeFeedState({
    this.status = HomeFeedStatus.initial,
    this.feed,
    this.allCategories,
    this.isLoadingAllCategories = false,
    this.errorMessage,
    this.categoriesErrorMessage,
  });

  HomeFeedState copyWith({
    HomeFeedStatus? status,
    HomeFeedEntity? feed,
    List<CategoryEntity>? allCategories,
    bool? isLoadingAllCategories,
    String? errorMessage,
    String? categoriesErrorMessage,
    bool clearError = false,
  }) {
    return HomeFeedState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      allCategories: allCategories ?? this.allCategories,
      isLoadingAllCategories:
          isLoadingAllCategories ?? this.isLoadingAllCategories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      categoriesErrorMessage: clearError
          ? null
          : (categoriesErrorMessage ?? this.categoriesErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    feed,
    allCategories,
    isLoadingAllCategories,
    errorMessage,
    categoriesErrorMessage,
  ];
}
