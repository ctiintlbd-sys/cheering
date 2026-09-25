import 'package:cheering/core/cache/cache_service.dart';
import 'package:cheering/core/config/chache_keys.dart';
import 'package:cheering/core/network/api_result.dart';

import '../../domain/entities/create_order_params.dart';
import '../../domain/entities/get_orders_params.dart';
import '../../domain/entities/order_detail_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/i_orders_repository.dart';
import '../datasources/orders_remote_source.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements IOrdersRepository {
  final OrdersRemoteSource _remoteSource;
  final CacheService _cache;

  OrdersRepositoryImpl(this._remoteSource, this._cache);

  @override
  Future<OrderDetailEntity> createOrder(CreateOrderParams params) async {
    final result = await _remoteSource.createOrder(params);
    return result.fold(onSuccess: (data) => data, onFailure: (e) => throw e);
  }

  @override
  Stream<List<OrderEntity>> getOrders(GetOrdersParams params) {
    return _cache.getOrFetch<List<OrderModel>>(
      CacheKeys.orders(params.toMap()),
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (list) => {'data': list.map((e) => e.toJson()).toList()},
      fetch: () => _remoteSource.getOrders(params),
      ttl: const Duration(minutes: 5),
    );
  }

  @override
  Future<OrderDetailEntity> getOrderDetails(String orderId) async {
    final result = await _remoteSource.getOrderDetails(orderId);
    return result.fold(onSuccess: (data) => data, onFailure: (e) => throw e);
  }

  @override
  Future<void> cancelOrder(String orderId, String reason) async {
    final result = await _remoteSource.cancelOrder(orderId, reason);
    return result.fold(onSuccess: (_) {}, onFailure: (e) => throw e);
  }
}
