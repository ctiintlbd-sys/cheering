import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/search_food_params.dart';

sealed class SearchFoodEvent extends Equatable {
  const SearchFoodEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearch extends SearchFoodEvent {
  final SearchFoodParams params;

  const PerformSearch({required this.params});

  @override
  List<Object?> get props => [params];
}

class ClearSearch extends SearchFoodEvent {
  const ClearSearch();
}
