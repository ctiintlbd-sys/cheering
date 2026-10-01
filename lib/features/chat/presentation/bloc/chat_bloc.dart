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
    on<PollChatThread>(_onPollChatThread);
  }

  Future<void> _onLoadChatThread(
    LoadChatThread event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        status: state.thread == null ? ChatStatus.loading : state.status,
        orderId: event.orderId,
        tracking: event.tracking,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<OrderChatThreadEntity>(
        _getOrderChatThreadUseCase(event.orderId),
        onData: (thread) {
          final pending =
              state.thread?.messages.where((m) => m.isSending).toList() ?? [];
          final mergedMessages = [...thread.messages, ...pending];
          return state.copyWith(
            status: ChatStatus.success,
            thread: thread.copyWith(messages: mergedMessages),
          );
        },
        onError: (error, _) => state.copyWith(
          status: state.thread == null ? ChatStatus.failure : state.status,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: state.thread == null ? ChatStatus.failure : state.status,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPollChatThread(
    PollChatThread event,
    Emitter<ChatState> emit,
  ) async {
    final orderId = event.orderId.trim();
    if (orderId.isEmpty) return;
    if (state.thread != null && !state.thread!.isOpen) return;

    try {
      final freshThread = await _getOrderChatThreadUseCase.fetchFresh(orderId);
      final pending =
          state.thread?.messages.where((m) => m.isSending).toList() ?? [];
      final mergedMessages = [...freshThread.messages, ...pending];
      final updatedThread = freshThread.copyWith(messages: mergedMessages);

      if (updatedThread != state.thread) {
        emit(state.copyWith(thread: updatedThread));
      }
    } catch (_) {
      // Silent catch: network glitch during background polling should never disrupt user
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final body = event.body.trim();
    if (body.isEmpty) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = ChatMessageEntity(
      id: tempId,
      orderId: event.orderId,
      senderRole: 'CUSTOMER',
      senderName: 'You',
      body: body,
      createdAt: DateTime.now(),
      readAt: null,
      isMine: true,
      isSending: true,
    );

    // Optimistic UI: Immediately show user's message in chat thread
    if (state.thread != null) {
      final currentMessages =
          List<ChatMessageEntity>.from(state.thread!.messages)..add(tempMessage);
      emit(
        state.copyWith(
          isSending: true,
          clearSendError: true,
          thread: state.thread!.copyWith(messages: currentMessages),
        ),
      );
    } else {
      emit(state.copyWith(isSending: true, clearSendError: true));
    }

    try {
      final result = await _sendChatMessageUseCase(
        orderId: event.orderId,
        body: body,
      );

      if (state.thread != null) {
        final currentMessages =
            List<ChatMessageEntity>.from(state.thread!.messages);
        final index = currentMessages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          currentMessages[index] = result.message;
        } else if (!currentMessages.any((m) => m.id == result.message.id)) {
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
      if (state.thread != null) {
        final currentMessages =
            List<ChatMessageEntity>.from(state.thread!.messages);
        final index = currentMessages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          currentMessages[index] = currentMessages[index].copyWith(
            isSending: false,
            isFailed: true,
          );
        }
        emit(
          state.copyWith(
            isSending: false,
            sendErrorMessage: e.toString(),
            thread: state.thread!.copyWith(messages: currentMessages),
          ),
        );
      } else {
        emit(
          state.copyWith(
            isSending: false,
            sendErrorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
