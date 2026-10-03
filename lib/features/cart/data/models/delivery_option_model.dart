import '../../domain/entities/delivery_option_entity.dart';

class DeliveryOptionModel extends DeliveryOptionEntity {
  const DeliveryOptionModel({
    required super.type,
    required super.label,
    required super.extraFee,
    required super.etaMinMinutes,
    required super.etaMaxMinutes,
    required super.isSelected,
  });

  factory DeliveryOptionModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOptionModel(
      type: json['type'] as String? ?? 'STANDARD',
      label: json['label'] as String? ?? 'Standard',
      extraFee: (json['extra_fee'] as num?)?.toDouble() ?? 0.0,
      etaMinMinutes: json['eta_min_minutes'] as int? ?? 0,
      etaMaxMinutes: json['eta_max_minutes'] as int? ?? 0,
      isSelected: json['is_selected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'label': label,
      'extra_fee': extraFee,
      'eta_min_minutes': etaMinMinutes,
      'eta_max_minutes': etaMaxMinutes,
      'is_selected': isSelected,
    };
  }
}
