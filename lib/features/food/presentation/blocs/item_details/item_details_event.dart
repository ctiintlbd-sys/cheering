import 'package:equatable/equatable.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';

abstract class ItemDetailsEvent extends Equatable {
  const ItemDetailsEvent();

  @override
  List<Object?> get props => [];
}

class SelectVariantEvent extends ItemDetailsEvent {
  final MenuVariantEntity variant;

  const SelectVariantEvent(this.variant);

  @override
  List<Object?> get props => [variant];
}

class IncrementAddOnEvent extends ItemDetailsEvent {
  final MenuAddOnEntity addOn;
  const IncrementAddOnEvent(this.addOn);
  @override
  List<Object?> get props => [addOn];
}

class DecrementAddOnEvent extends ItemDetailsEvent {
  final MenuAddOnEntity addOn;
  const DecrementAddOnEvent(this.addOn);
  @override
  List<Object?> get props => [addOn];
}


