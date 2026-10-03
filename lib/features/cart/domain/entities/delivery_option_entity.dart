import 'package:equatable/equatable.dart';

class DeliveryOptionEntity extends Equatable {
  final String type;
  final String label;
  final double extraFee;
  final int etaMinMinutes;
  final int etaMaxMinutes;
  final bool isSelected;

  const DeliveryOptionEntity({
    required this.type,
    required this.label,
    required this.extraFee,
    required this.etaMinMinutes,
    required this.etaMaxMinutes,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [
        type,
        label,
        extraFee,
        etaMinMinutes,
        etaMaxMinutes,
        isSelected,
      ];
}
