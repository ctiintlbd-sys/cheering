import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/order_chat_thread_entity.dart';
import '../../domain/usecases/get_order_chat_thread_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetOrderChatThreadUseCase _getOrderChatThreadUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;

  ChatBloc(
    this._getOrderChatThreadUseCase,
    this._sendChatMessageUseCase,
  ) : super(const ChatState()) {
    on<LoadChatThread>(_onLoadChatThread);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadChatThread(
    LoadChatThread event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        orderId: event.orderId,
        tracking: event.tracking,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<OrderChatThreadEntity>(
        _getOrderChatThreadUseCase(event.orderId),
        onData: (thread) => state.copyWith(
          status: ChatStatus.success,
          thread: thread,
        ),
        onError: (error, _) => state.copyWith(
          status: ChatStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final body = event.body.trim();
    if (body.isEmpty) return;

    emit(state.copyWith(isSending: true, clearSendError: true));

    try {
      final result = await _sendChatMessageUseCase(
        orderId: event.orderId,
        body: body,
      );

      if (state.thread != null) {
        final currentMessages =
            List<ChatMessageEntity>.from(state.thread!.messages);
        final exists = currentMessages.any((m) => m.id == result.message.id);
        if (!exists) {
          currentMessages.add(result.message);
        }
        emit(
          state.copyWith(
            isSending: false,
            thread: state.thread!.copyWith(messages: currentMessages),
          ),
        );
      } else {
        emit(state.copyWith(isSending: false));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSending: false,
          sendErrorMessage: e.toString(),
        ),
      );
    }
  }
}
