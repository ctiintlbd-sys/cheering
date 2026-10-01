import 'package:flutter_test/flutter_test.dart';
import 'package:cheering/features/chat/domain/entities/order_chat_thread_entity.dart';
import 'package:cheering/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cheering/features/chat/domain/entities/send_message_result_entity.dart';
import 'package:cheering/features/chat/domain/repositories/i_chat_repository.dart';
import 'package:cheering/features/chat/domain/usecases/get_order_chat_thread_usecase.dart';
import 'package:cheering/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:cheering/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:cheering/features/chat/presentation/bloc/chat_event.dart';
import 'package:cheering/features/chat/presentation/bloc/chat_state.dart';

class MockRepo implements IChatRepository {
  OrderChatThreadEntity? threadToEmit;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<OrderChatThreadEntity> getOrderChatThread(String orderId) async* {
    if (threadToEmit != null) {
      yield threadToEmit!;
    }
  }

  @override
  Future<SendMessageResultEntity> sendMessage({
    required String orderId,
    required String body,
  }) async {
    return SendMessageResultEntity(
      message: ChatMessageEntity(
        id: 'msg-new',
        orderId: orderId,
        senderRole: 'CUSTOMER',
        senderName: 'Tanvir',
        body: body,
        createdAt: DateTime.now(),
        isMine: true,
      ),
      deliveredOverWebsocket: true,
    );
  }
}

void main() {
  late MockRepo repo;
  late ChatBloc bloc;

  setUp(() {
    repo = MockRepo();
    bloc = ChatBloc(
      GetOrderChatThreadUseCase(repo),
      SendChatMessageUseCase(repo),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ChatBloc Deep Link & In-App Tests', () {
    test('LoadChatThread via Deep Link (only orderId, no tracking) loads successfully', () async {
      repo.threadToEmit = OrderChatThreadEntity(
        orderId: 'deep-link-order-123',
        isOpen: true,
        counterpartyName: 'Rider Hridoy',
        counterpartyRole: 'RIDER',
        unreadCount: 0,
        messages: [
          ChatMessageEntity(
            id: 'm1',
            orderId: 'deep-link-order-123',
            senderRole: 'RIDER',
            senderName: 'Rider Hridoy',
            body: 'Hello from deep link',
            createdAt: DateTime.now(),
            isMine: false,
          ),
        ],
      );

      bloc.add(const LoadChatThread(orderId: 'deep-link-order-123'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ChatState>()
              .having((s) => s.status, 'status', ChatStatus.loading)
              .having((s) => s.orderId, 'orderId', 'deep-link-order-123')
              .having((s) => s.tracking, 'tracking', isNull),
          isA<ChatState>()
              .having((s) => s.status, 'status', ChatStatus.success)
              .having((s) => s.thread?.counterpartyName, 'counterpartyName', 'Rider Hridoy')
              .having((s) => s.thread?.messages.length, 'messages length', 1),
        ]),
      );
    });

    test('SendMessageEvent sends message and appends to thread', () async {
      repo.threadToEmit = const OrderChatThreadEntity(
        orderId: 'order-123',
        isOpen: true,
        counterpartyName: 'Rider Hridoy',
        counterpartyRole: 'RIDER',
        unreadCount: 0,
        messages: [],
      );

      bloc.add(const LoadChatThread(orderId: 'order-123'));

      // Wait for thread to be loaded
      await bloc.stream.firstWhere((s) => s.status == ChatStatus.success);

      bloc.add(const SendMessageEvent(orderId: 'order-123', body: 'I am downstairs'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ChatState>().having((s) => s.isSending, 'isSending', true),
          isA<ChatState>()
              .having((s) => s.isSending, 'isSending', false)
              .having((s) => s.thread?.messages.length, 'messages count', 1)
              .having((s) => s.thread?.messages.first.body, 'message body', 'I am downstairs'),
        ]),
      );
    });
  });
}
