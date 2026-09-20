import 'package:cheering/features/food/domain/entities/restaurant_query_params.dart';

class FilterData {
  final String label;
  final RestaurantQueryParams params;

  const FilterData({required this.label, required this.params});


  static const filters = [

    FilterData(
      label: 'Under ৳300',
      params: RestaurantQueryParams(maxDeliveryFee: 300),
    ),
    FilterData(
      label: 'Rating 4+',
      params: RestaurantQueryParams(minRating: 4.0),
    ),
    FilterData(
      label: 'Fastest',
      params: RestaurantQueryParams(sort: 'delivery_time'),
    ),
  ];
}
