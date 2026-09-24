import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/cart/domain/entities/cart_item_entity.dart';
import 'item_details_event.dart';
import 'item_details_state.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {
  ItemDetailsBloc(MenuItemEntity menuItem, {CartItemEntity? cartItem}) 
      : super(_createInitialState(menuItem, cartItem)) {
    on<SelectVariantEvent>(_onSelectVariant);
    on<IncrementAddOnEvent>(_onIncrementAddOn);
    on<DecrementAddOnEvent>(_onDecrementAddOn);
  }

  static ItemDetailsState _createInitialState(
    MenuItemEntity menuItem,
    CartItemEntity? cartItem,
  ) {
    final initialVariantId = cartItem?.variantId;
    final initialAddOnIds = cartItem?.addOnIds ?? const [];

    MenuVariantEntity? initialVariant;
    
    if (menuItem.variants != null && menuItem.variants!.isNotEmpty) {
      if (initialVariantId != null) {
        initialVariant = menuItem.variants!.where((v) => v.id == initialVariantId).firstOrNull;
      }
      
      if (initialVariant == null) {
        try {
          initialVariant = menuItem.variants!.firstWhere((v) => v.isDefault);
        } catch (_) {
          initialVariant = menuItem.variants!.first;
        }
      }
    }

    List<MenuAddOnEntity> initialAddOns = [];
    if (menuItem.addOns != null && initialAddOnIds.isNotEmpty) {
      for (var id in initialAddOnIds) {
        final addOn = menuItem.addOns!.where((a) => a.id == id).firstOrNull;
        if (addOn != null) {
          initialAddOns.add(addOn);
        }
      }
    }

    return ItemDetailsState(
      menuItem: menuItem,
      selectedVariant: initialVariant,
      selectedAddOns: initialAddOns,
    );
  }

  void _onSelectVariant(SelectVariantEvent event, Emitter<ItemDetailsState> emit) {
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: event.variant,
      selectedAddOns: state.selectedAddOns,
    ));
  }

  void _onIncrementAddOn(IncrementAddOnEvent event, Emitter<ItemDetailsState> emit) {
    final currentAddOns = List.of(state.selectedAddOns);
    currentAddOns.add(event.addOn);
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: state.selectedVariant,
      selectedAddOns: currentAddOns,
    ));
  }

  void _onDecrementAddOn(DecrementAddOnEvent event, Emitter<ItemDetailsState> emit) {
    final currentAddOns = List.of(state.selectedAddOns);
    currentAddOns.remove(event.addOn); // remove removes the first occurrence
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: state.selectedVariant,
      selectedAddOns: currentAddOns,
    ));
  }
}
