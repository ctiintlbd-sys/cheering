import 'package:equatable/equatable.dart';

class ReelQueryParams extends Equatable {
  final double? lat;
  final double? lng;
  final String? restaurantId;
  final int limit;
  final int offset;
  final String? sort;

  const ReelQueryParams({
    this.lat,
    this.lng,
    this.restaurantId,
    this.limit = 20,
    this.offset = 0,
    this.sort,
  });

  ReelQueryParams copyWith({
    double? lat,
    double? lng,
    String? restaurantId,
    int? limit,
    int? offset,
    String? sort,
  }) {
    return ReelQueryParams(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      restaurantId: restaurantId ?? this.restaurantId,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (lat != null) map['lat'] = lat;
    if (lng != null) map['lng'] = lng;
    if (restaurantId != null) map['restaurant_id'] = restaurantId;
    if (sort != null) map['sort'] = sort;
    return map;
  }

  @override
  List<Object?> get props => [
    lat,
    lng,
    restaurantId,
    limit,
    offset,
    sort,
  ];
}
