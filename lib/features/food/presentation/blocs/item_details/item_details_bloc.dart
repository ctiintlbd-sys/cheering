import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/cart/domain/entities/cart_item_entity.dart';
import 'item_details_event.dart';
import 'item_details_state.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {
  ItemDetailsBloc(MenuItemEntity menuItem, {CartItemEntity? cartItem}) 
      : super(_createInitialState(menuItem, cartItem)) {
    on<SelectVariantEvent>(_onSelectVariant);
    on<ToggleAddOnEvent>(_onToggleAddOn);
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

  void _onToggleAddOn(ToggleAddOnEvent event, Emitter<ItemDetailsState> emit) {
    final currentAddOns = List.of(state.selectedAddOns);
    
    // Check if addOn is already selected
    final isSelected = currentAddOns.any((a) => a.id == event.addOn.id);
    
    if (isSelected) {
      currentAddOns.removeWhere((a) => a.id == event.addOn.id);
    } else {
      currentAddOns.add(event.addOn);
    }
    
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: state.selectedVariant,
      selectedAddOns: currentAddOns,
    ));
  }
}
