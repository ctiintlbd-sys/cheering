import 'package:equatable/equatable.dart';

class SearchParams extends Equatable {
  final String q;
  final double? lat;
  final double? lng;
  final int limit;
  final int offset;
  final String? sort;
  final double? minRating;
  final double? minPrice;
  final double? maxPrice;
  final String? dietary;

  const SearchParams({
    required this.q,
    this.lat,
    this.lng,
    this.limit = 20,
    this.offset = 0,
    this.sort,
    this.minRating,
    this.minPrice,
    this.maxPrice,
    this.dietary,
  });

  SearchParams copyWith({
    String? q,
    double? lat,
    double? lng,
    int? limit,
    int? offset,
    String? sort,
    double? minRating,
    double? minPrice,
    double? maxPrice,
    String? dietary,
  }) {
    return SearchParams(
      q: q ?? this.q,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      sort: sort ?? this.sort,
      minRating: minRating ?? this.minRating,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      dietary: dietary ?? this.dietary,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'q': q, 'limit': limit, 'offset': offset};
    if (lat != null) map['lat'] = lat;
    if (lng != null) map['lng'] = lng;
    if (sort != null) map['sort'] = sort;
    if (minRating != null) map['min_rating'] = minRating;
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (dietary != null) map['dietary'] = dietary;
    return map;
  }

  @override
  List<Object?> get props => [
    q,
    lat,
    lng,
    limit,
    offset,
    sort,
    minRating,
    minPrice,
    maxPrice,
    dietary,
  ];
}
