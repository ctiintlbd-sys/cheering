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

class ToggleAddOnEvent extends ItemDetailsEvent {
  final MenuAddOnEntity addOn;

  const ToggleAddOnEvent(this.addOn);

  @override
  List<Object?> get props => [addOn];
}

class IncrementQuantityEvent extends ItemDetailsEvent {}

class DecrementQuantityEvent extends ItemDetailsEvent {}
