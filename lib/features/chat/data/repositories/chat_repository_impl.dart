import '../../../../core/cache/cache_service.dart';
import '../../../../core/config/chache_keys.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/order_chat_thread_entity.dart';
import '../../domain/entities/send_message_result_entity.dart';
import '../../domain/repositories/i_chat_repository.dart';
import '../datasources/chat_remote_source.dart';
import '../models/order_chat_thread_model.dart';

class ChatRepositoryImpl implements IChatRepository {
  final ChatRemoteSource _remoteSource;
  final CacheService _cache;

  ChatRepositoryImpl(this._remoteSource, this._cache);

  @override
  Stream<OrderChatThreadEntity> getOrderChatThread(String orderId) {
    return _cache.getOrFetch<OrderChatThreadModel>(
      CacheKeys.orderMessages(orderId),
      fromJson: (json) => OrderChatThreadModel.fromJson(json),
      toJson: (data) => data.toJson(),
      fetch: () => _remoteSource.getOrderChatThread(orderId),
      ttl: const Duration(minutes: 5),
    );
  }

  @override
  Future<OrderChatThreadEntity> fetchOrderChatThread(String orderId) async {
    final result = await _remoteSource.getOrderChatThread(orderId);
    return result.fold(
      onSuccess: (data) {
        _cache.set<OrderChatThreadModel>(
          CacheKeys.orderMessages(orderId),
          data,
          toJson: (d) => d.toJson(),
          ttl: const Duration(minutes: 5),
        );
        return data;
      },
      onFailure: (error) => throw error,
    );
  }

  @override
  Future<SendMessageResultEntity> sendMessage({
    required String orderId,
    required String body,
  }) async {
    final result = await _remoteSource.sendMessage(
      orderId: orderId,
      body: body,
    );
    return result.fold(
      onSuccess: (data) {
        final cached = _cache.get<OrderChatThreadModel>(
          CacheKeys.orderMessages(orderId),
          fromJson: (json) => OrderChatThreadModel.fromJson(json),
        );
        if (cached != null) {
          final updated = OrderChatThreadModel(
            orderId: cached.orderId,
            isOpen: cached.isOpen,
            closedReason: cached.closedReason,
            counterpartyName: cached.counterpartyName,
            counterpartyRole: cached.counterpartyRole,
            counterpartyAvatarUrl: cached.counterpartyAvatarUrl,
            unreadCount: cached.unreadCount,
            messages: [...cached.messages, data.message],
          );
          _cache.set<OrderChatThreadModel>(
            CacheKeys.orderMessages(orderId),
            updated,
            toJson: (d) => d.toJson(),
            ttl: const Duration(minutes: 5),
          );
        }
        return data;
      },
      onFailure: (e) => throw e,
    );
  }
}
