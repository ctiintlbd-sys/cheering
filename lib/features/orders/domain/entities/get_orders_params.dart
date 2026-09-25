import 'package:equatable/equatable.dart';

class GetOrdersParams extends Equatable {
  final String? statusFilter;
  final int limit;
  final int offset;
  final String? sort;

  const GetOrdersParams({
    this.statusFilter,
    this.limit = 20,
    this.offset = 0,
    this.sort,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (statusFilter != null && statusFilter!.isNotEmpty) {
      map['status_filter'] = statusFilter;
    }
    if (sort != null && sort!.isNotEmpty) {
      map['sort'] = sort;
    }
    return map;
  }

  @override
  List<Object?> get props => [statusFilter, limit, offset, sort];
}
