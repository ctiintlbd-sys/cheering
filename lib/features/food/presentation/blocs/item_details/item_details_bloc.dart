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
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
  }

  static ItemDetailsState _createInitialState(
    MenuItemEntity menuItem,
    CartItemEntity? cartItem,
  ) {
    final initialQuantity = (cartItem != null && cartItem.quantity > 0) ? cartItem.quantity : 1;
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
      initialAddOns = menuItem.addOns!.where((a) => initialAddOnIds.contains(a.id)).toList();
    }

    return ItemDetailsState(
      menuItem: menuItem,
      selectedVariant: initialVariant,
      selectedAddOns: initialAddOns,
      quantity: initialQuantity,
    );
  }

  void _onSelectVariant(SelectVariantEvent event, Emitter<ItemDetailsState> emit) {
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: event.variant,
      selectedAddOns: state.selectedAddOns,
      quantity: state.quantity,
    ));
  }

  void _onToggleAddOn(ToggleAddOnEvent event, Emitter<ItemDetailsState> emit) {
    final currentAddOns = List.of(state.selectedAddOns);
    if (currentAddOns.contains(event.addOn)) {
      currentAddOns.remove(event.addOn);
    } else {
      currentAddOns.add(event.addOn);
    }
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: state.selectedVariant,
      selectedAddOns: currentAddOns,
      quantity: state.quantity,
    ));
  }

  void _onIncrementQuantity(IncrementQuantityEvent event, Emitter<ItemDetailsState> emit) {
    emit(ItemDetailsState(
      menuItem: state.menuItem,
      selectedVariant: state.selectedVariant,
      selectedAddOns: state.selectedAddOns,
      quantity: state.quantity + 1,
    ));
  }

  void _onDecrementQuantity(DecrementQuantityEvent event, Emitter<ItemDetailsState> emit) {
    if (state.quantity > 1) {
      emit(ItemDetailsState(
        menuItem: state.menuItem,
        selectedVariant: state.selectedVariant,
        selectedAddOns: state.selectedAddOns,
        quantity: state.quantity - 1,
      ));
    }
  }
}
