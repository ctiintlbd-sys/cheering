import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/search_result_entity.dart';

enum SearchFoodStatus { initial, loading, success, failure }

class SearchFoodState extends Equatable {
  final SearchFoodStatus status;
  final SearchResultEntity? result;
  final String? errorMessage;

  const SearchFoodState({
    this.status = SearchFoodStatus.initial,
    this.result,
    this.errorMessage,
  });

  SearchFoodState copyWith({
    SearchFoodStatus? status,
    SearchResultEntity? result,
    String? errorMessage,
    bool clearError = false,
    bool clearResult =
        false, // Reserved: use when showing empty state between queries
  }) {
    return SearchFoodState(
      status: status ?? this.status,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
