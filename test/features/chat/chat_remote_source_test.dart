import 'package:flutter_test/flutter_test.dart';
import 'package:cheering/core/config/api_endpoints.dart';
import 'package:cheering/core/network/api_result.dart';
import 'package:cheering/core/network/i_api_client.dart';
import 'package:cheering/features/chat/data/datasources/chat_remote_source.dart';

class FakeApiClient implements IApiClient {
  dynamic responseJsonToReturn;
  String? lastGetPath;
  String? lastPostPath;
  dynamic lastPostBody;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    dynamic cancelToken,
  }) async {
    lastGetPath = path;
    final parsed = fromJson(responseJsonToReturn);
    return Success(parsed, statusCode: 200);
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    dynamic cancelToken,
  }) async {
    lastPostPath = path;
    lastPostBody = body;
    final parsed = fromJson(responseJsonToReturn);
    return Success(parsed, statusCode: 201);
  }
}

void main() {
  late FakeApiClient fakeApiClient;
  late ChatRemoteSource remoteSource;

  setUp(() {
    fakeApiClient = FakeApiClient();
    remoteSource = ChatRemoteSource(fakeApiClient);
  });

  group('ChatRemoteSource GET tests', () {
    const orderId = 'cf78f7b8-a88a-4d7a-8201-f0b484eeea50';

    final getRawResponse = {
      "success": true,
      "data": {
        "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
        "is_open": true,
        "closed_reason": null,
        "counterparty_name": "Rider Hridoy",
        "counterparty_role": "RIDER",
        "counterparty_avatar_url": null,
        "unread_count": 0,
        "messages": [
          {
            "id": "f4ae0cc8-729b-4968-819d-b10a6b4cc330",
            "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
            "sender_role": "CUSTOMER",
            "sender_name": "Tanvir",
            "body": "hy tanvir",
            "created_at": "2026-09-30T05:36:07.945609+00:00",
            "read_at": null,
            "is_mine": true
          },
          {
            "id": "5810a840-8c12-4124-afea-6fba75003bac",
            "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
            "sender_role": "CUSTOMER",
            "sender_name": "Tanvir",
            "body": "hy tanvir",
            "created_at": "2026-09-30T05:36:39.777998+00:00",
            "read_at": null,
            "is_mine": true
          },
          {
            "id": "b6fa24ca-e1dd-4cab-be71-1a1a781358f3",
            "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
            "sender_role": "CUSTOMER",
            "sender_name": "Tanvir",
            "body": "hy nani kmn ase",
            "created_at": "2026-09-30T05:37:05.851135+00:00",
            "read_at": null,
            "is_mine": true
          }
        ]
      }
    };

    test('getOrderChatThread calls GET /orders/{order_id}/messages and parses response', () async {
      fakeApiClient.responseJsonToReturn = getRawResponse;

      final result = await remoteSource.getOrderChatThread(orderId);

      expect(result.isSuccess, true);
      expect(fakeApiClient.lastGetPath, ApiEndpoints.orderMessages(orderId));
      expect(fakeApiClient.lastGetPath, '/orders/$orderId/messages');

      final thread = result.dataOrNull!;
      expect(thread.orderId, orderId);
      expect(thread.isOpen, true);
      expect(thread.closedReason, isNull);
      expect(thread.counterpartyName, 'Rider Hridoy');
      expect(thread.counterpartyRole, 'RIDER');
      expect(thread.counterpartyAvatarUrl, isNull);
      expect(thread.unreadCount, 0);
      expect(thread.messages.length, 3);
      expect(thread.messages[0].id, 'f4ae0cc8-729b-4968-819d-b10a6b4cc330');
      expect(thread.messages[0].body, 'hy tanvir');
      expect(thread.messages[0].isMine, true);
      expect(thread.messages[2].body, 'hy nani kmn ase');
    });

    test('sendMessage calls POST /orders/{order_id}/messages and parses response', () async {
      final postRawResponse = {
        "success": true,
        "data": {
          "message": {
            "id": "df79eb22-88dd-4861-81ed-0a67f410a204",
            "order_id": orderId,
            "sender_role": "CUSTOMER",
            "sender_name": "Tanvir",
            "body": "hy there",
            "created_at": "2026-10-01T04:33:59.649856+00:00",
            "read_at": null,
            "is_mine": true
          },
          "delivered_over_websocket": true
        }
      };

      fakeApiClient.responseJsonToReturn = postRawResponse;

      final result = await remoteSource.sendMessage(
        orderId: orderId,
        body: 'hy there',
      );

      expect(result.isSuccess, true);
      expect(fakeApiClient.lastPostPath, '/orders/$orderId/messages');
      expect(fakeApiClient.lastPostBody, {'body': 'hy there'});

      final data = result.dataOrNull!;
      expect(data.deliveredOverWebsocket, true);
      expect(data.message.body, 'hy there');
      expect(data.message.senderName, 'Tanvir');
    });
  });
}
