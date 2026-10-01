import 'package:flutter_test/flutter_test.dart';
import 'package:cheering/core/cache/cache_service.dart';
import 'package:cheering/core/network/api_result.dart';
import 'package:cheering/core/errors/app_exception.dart';
import 'package:cheering/features/chat/data/datasources/chat_remote_source.dart';
import 'package:cheering/features/chat/data/models/chat_message_model.dart';
import 'package:cheering/features/chat/data/models/order_chat_thread_model.dart';
import 'package:cheering/features/chat/data/models/send_message_result_model.dart';
import 'package:cheering/features/chat/data/repositories/chat_repository_impl.dart';

class FakeCacheService implements CacheService {
  final Map<String, dynamic> _storage = {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  T? get<T>(String key, {required T Function(Map<String, dynamic> json) fromJson}) {
    final data = _storage[key];
    if (data == null) return null;
    return fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> set<T>(
    String key,
    T data, {
    required Map<String, dynamic> Function(T data) toJson,
    Duration ttl = const Duration(minutes: 30),
  }) async {
    _storage[key] = toJson(data);
  }

  @override
  Stream<T> getOrFetch<T>(
    String key, {
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T data) toJson,
    required Future<ApiResult<T>> Function() fetch,
    Duration ttl = const Duration(minutes: 30),
    bool skipFetchIfCached = false,
  }) async* {
    final cached = get<T>(key, fromJson: fromJson);
    if (cached != null) yield cached;
    final result = await fetch();
    if (result is Success<T>) {
      await set<T>(key, result.data, toJson: toJson, ttl: ttl);
      yield result.data;
    } else if (result is Failure<T>) {
      if (cached == null) {
        throw result.exception;
      }
    }
  }
}

class FakeChatRemoteSource implements ChatRemoteSource {
  ApiResult<OrderChatThreadModel>? getThreadResult;
  ApiResult<SendMessageResultModel>? sendMessageResult;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ApiResult<OrderChatThreadModel>> getOrderChatThread(String orderId) async {
    return getThreadResult!;
  }

  @override
  Future<ApiResult<SendMessageResultModel>> sendMessage({
    required String orderId,
    required String body,
  }) async {
    return sendMessageResult!;
  }
}

void main() {
  late FakeChatRemoteSource fakeRemoteSource;
  late FakeCacheService fakeCache;
  late ChatRepositoryImpl repository;

  setUp(() {
    fakeRemoteSource = FakeChatRemoteSource();
    fakeCache = FakeCacheService();
    repository = ChatRepositoryImpl(fakeRemoteSource, fakeCache);
  });

  group('ChatRepositoryImpl', () {
    test('getOrderChatThread streams OrderChatThreadEntity via cache and remote', () async {
      final threadModel = OrderChatThreadModel(
        orderId: 'order-123',
        isOpen: true,
        counterpartyName: 'Rider John',
        counterpartyRole: 'RIDER',
        unreadCount: 0,
        messages: [
          ChatMessageModel(
            id: 'm1',
            orderId: 'order-123',
            senderRole: 'RIDER',
            senderName: 'Rider John',
            body: 'On my way',
            createdAt: DateTime.now(),
            isMine: false,
          ),
        ],
      );

      fakeRemoteSource.getThreadResult = Success(threadModel, statusCode: 200);

      final emissions = await repository.getOrderChatThread('order-123').toList();

      expect(emissions.length, 1);
      expect(emissions.first.orderId, 'order-123');
      expect(emissions.first.messages.first.body, 'On my way');
    });

    test('getOrderChatThread throws AppException on failure when no cache exists', () async {
      fakeRemoteSource.getThreadResult = const Failure(
        ServerException('Order thread not found', 404),
      );

      expect(
        () => repository.getOrderChatThread('order-123').first,
        throwsA(isA<ServerException>()),
      );
    });

    test('sendMessage returns SendMessageResultEntity on success', () async {
      final sendResultModel = SendMessageResultModel(
        message: ChatMessageModel(
          id: 'm2',
          orderId: 'order-123',
          senderRole: 'CUSTOMER',
          senderName: 'Tanvir',
          body: 'Hello',
          createdAt: DateTime.now(),
          isMine: true,
        ),
        deliveredOverWebsocket: true,
      );

      fakeRemoteSource.sendMessageResult = Success(sendResultModel, statusCode: 201);

      final result = await repository.sendMessage(
        orderId: 'order-123',
        body: 'Hello',
      );

      expect(result.message.id, 'm2');
      expect(result.deliveredOverWebsocket, true);
    });

    test('sendMessage throws AppException on failure', () async {
      fakeRemoteSource.sendMessageResult = const Failure(
        BadRequestException('Thread is closed'),
      );

      expect(
        () => repository.sendMessage(orderId: 'order-123', body: 'Hello'),
        throwsA(isA<BadRequestException>()),
      );
    });
  });
}
