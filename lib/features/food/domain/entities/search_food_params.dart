class SearchFoodParams {
  final String q;
  final double? lat;
  final double? lng;
  final int limit;
  final int offset;
  final String? sort;

  const SearchFoodParams({
    required this.q,
    this.lat,
    this.lng,
    this.limit = 20,
    this.offset = 0,
    this.sort,
  });

  SearchFoodParams copyWith({
    String? q,
    double? lat,
    double? lng,
    int? limit,
    int? offset,
    String? sort,
  }) {
    return SearchFoodParams(
      q: q ?? this.q,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'q': q, 'limit': limit, 'offset': offset};
    if (lat != null) map['lat'] = lat;
    if (lng != null) map['lng'] = lng;
    if (sort != null) map['sort'] = sort;
    return map;
  }
}
