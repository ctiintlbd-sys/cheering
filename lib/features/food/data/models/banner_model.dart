import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.title,
    required super.mediaUrl,
    required super.mediaType,
    required super.placement,
    required super.actionType,
    super.actionValue,
    super.sortOrder,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      mediaUrl: json['media_url'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? 'IMAGE',
      placement: json['placement'] as String? ?? 'HOME',
      actionType: json['action_type'] as String? ?? 'NONE',
      actionValue: json['action_value'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'placement': placement,
      'action_type': actionType,
      'action_value': actionValue,
      'sort_order': sortOrder,
    };
  }
}
