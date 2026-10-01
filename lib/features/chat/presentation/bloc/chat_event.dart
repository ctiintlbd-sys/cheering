import 'package:equatable/equatable.dart';

import '../../../tracking/domain/entities/order_tracking_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatThread extends ChatEvent {
  final String orderId;
  final OrderTrackingEntity? tracking;

  const LoadChatThread({
    required this.orderId,
    this.tracking,
  });

  @override
  List<Object?> get props => [orderId, tracking];
}

class SendMessageEvent extends ChatEvent {
  final String orderId;
  final String body;

  const SendMessageEvent({
    required this.orderId,
    required this.body,
  });

  @override
  List<Object?> get props => [orderId, body];
}

class PollChatThread extends ChatEvent {
  final String orderId;

  const PollChatThread(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
