import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String mediaUrl;
  final String mediaType;
  final String placement;
  final String actionType;
  final String? actionValue;
  final int sortOrder;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.mediaUrl,
    required this.mediaType,
    required this.placement,
    required this.actionType,
    this.actionValue,
    this.sortOrder = 0,
  });

  bool get isLottie => mediaType.toUpperCase() == 'LOTTIE';
  bool get isImage => mediaType.toUpperCase() == 'IMAGE';

  @override
  List<Object?> get props => [
    id,
    title,
    mediaUrl,
    mediaType,
    placement,
    actionType,
    actionValue,
    sortOrder,
  ];
}
