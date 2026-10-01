import 'package:equatable/equatable.dart';

class RestaurantQueryParams extends Equatable {
  final double? lat;
  final double? lng;
  final int? radius;
  final String? cuisine;
  final String? category;
  final bool? isOpen;
  final String? sort;
  final int? maxDeliveryFee;
  final double? minRating;
  final String? q;
  final int limit;
  final int offset;

  const RestaurantQueryParams({
    this.lat,
    this.lng,
    this.radius,
    this.cuisine,
    this.category,
    this.isOpen,
    this.sort,
    this.maxDeliveryFee,
    this.minRating,
    this.q,
    this.limit = 20,
    this.offset = 0,
  });

  RestaurantQueryParams copyWith({
    double? lat,
    double? lng,
    int? radius,
    String? cuisine,
    String? category,
    bool? isOpen,
    String? sort,
    int? maxDeliveryFee,
    double? minRating,
    String? q,
    int? limit,
    int? offset,
  }) {
    return RestaurantQueryParams(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      radius: radius ?? this.radius,
      cuisine: cuisine ?? this.cuisine,
      category: category ?? this.category,
      isOpen: isOpen ?? this.isOpen,
      sort: sort ?? this.sort,
      maxDeliveryFee: maxDeliveryFee ?? this.maxDeliveryFee,
      minRating: minRating ?? this.minRating,
      q: q ?? this.q,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'limit': limit, 'offset': offset};
    if (lat != null && lat != 0) map['lat'] = lat;
    if (lng != null && lng != 0) map['lng'] = lng;
    if (radius != null) map['radius'] = radius;
    if (cuisine != null) map['cuisine'] = cuisine;
    if (category != null) map['category'] = category;
    if (isOpen != null) map['is_open'] = isOpen;
    if (sort != null) map['sort'] = sort;
    if (maxDeliveryFee != null) map['max_delivery_fee'] = maxDeliveryFee;
    if (minRating != null) map['min_rating'] = minRating;
    if (q != null) map['q'] = q;
    return map;
  }

  @override
  List<Object?> get props => [
    lat,
    lng,
    radius,
    cuisine,
    category,
    isOpen,
    sort,
    maxDeliveryFee,
    minRating,
    q,
    limit,
    offset,
  ];
}
