import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:cheering/features/food/domain/usecases/get_restaurant_menu_usecase.dart';
import 'package:cheering/features/cart/domain/entities/cart_item_entity.dart';
import 'item_details_event.dart';
import 'item_details_state.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {
  final CartItemEntity? cartItem;

  ItemDetailsBloc(MenuItemEntity menuItem, {this.cartItem})
      : super(_createInitialState(
          menuItem,
          cartItem,
          isLoading: menuItem.variants == null && menuItem.restaurantId != null,
        )) {
    on<SelectVariantEvent>(_onSelectVariant);
    on<ToggleAddOnEvent>(_onToggleAddOn);
    on<LoadMenuItemDetailsEvent>(_onLoadDetails);

    if (state.isLoading) {
      add(const LoadMenuItemDetailsEvent());
    }
  }

  static ItemDetailsState _createInitialState(
    MenuItemEntity menuItem,
    CartItemEntity? cartItem, {
    bool isLoading = false,
  }) {
    final initialVariantId = cartItem?.variantId;
    final initialAddOnIds = cartItem?.addOnIds ?? const [];

    MenuVariantEntity? initialVariant;
    if (menuItem.variants != null && menuItem.variants!.isNotEmpty) {
      if (initialVariantId != null) {
        initialVariant = menuItem.variants!.where((v) => v.id == initialVariantId).firstOrNull;
      }
      initialVariant ??= menuItem.variants!.where((v) => v.isDefault).firstOrNull ?? menuItem.variants!.first;
    }

    final initialAddOns = menuItem.addOns
            ?.where((a) => initialAddOnIds.contains(a.id))
            .toList() ??
        const [];

    return ItemDetailsState(
      menuItem: menuItem,
      selectedVariant: initialVariant,
      selectedAddOns: initialAddOns,
      isLoading: isLoading,
    );
  }

  Future<void> _onLoadDetails(
    LoadMenuItemDetailsEvent event,
    Emitter<ItemDetailsState> emit,
  ) async {
    try {
      final categories = await getIt<GetRestaurantMenuUseCase>()(state.menuItem.restaurantId!);
      final item = categories.expand((c) => c.items).where((i) => i.id == state.menuItem.id).firstOrNull;
      if (item != null) {
        emit(_createInitialState(item, cartItem));
        return;
      }
    } catch (_) {}
    emit(state.copyWith(isLoading: false));
  }

  void _onSelectVariant(SelectVariantEvent event, Emitter<ItemDetailsState> emit) {
    emit(state.copyWith(selectedVariant: event.variant));
  }

  void _onToggleAddOn(ToggleAddOnEvent event, Emitter<ItemDetailsState> emit) {
    final currentAddOns = List.of(state.selectedAddOns);
    final isSelected = currentAddOns.any((a) => a.id == event.addOn.id);
    if (isSelected) {
      currentAddOns.removeWhere((a) => a.id == event.addOn.id);
    } else {
      currentAddOns.add(event.addOn);
    }
    emit(state.copyWith(selectedAddOns: currentAddOns));
  }
}
