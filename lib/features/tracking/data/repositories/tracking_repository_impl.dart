import 'package:cheering/core/network/api_result.dart';

import '../../domain/entities/order_tracking_entity.dart';
import '../../domain/repositories/i_tracking_repository.dart';
import '../datasources/tracking_remote_source.dart';

class TrackingRepositoryImpl implements ITrackingRepository {
  final TrackingRemoteSource _remoteSource;

  TrackingRepositoryImpl(this._remoteSource);

  @override
  Future<OrderTrackingEntity> getOrderTracking(String orderId) async {
    final result = await _remoteSource.getOrderTracking(orderId);
    return result.fold(onSuccess: (data) => data, onFailure: (e) => throw e);
  }
}
