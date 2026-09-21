import os

base_path = "lib/features/cart/presentation/blocs"
cart_path = os.path.join(base_path, "cart")
checkout_path = os.path.join(base_path, "checkout_summary")

os.makedirs(cart_path, exist_ok=True)
os.makedirs(checkout_path, exist_ok=True)

def write_file(path, content):
    with open(path, 'w') as f:
        f.write(content)

# ----------------- CART BLOC -----------------

# cart_state.dart
write_file(os.path.join(cart_path, "cart_state.dart"), """import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;
  
  // Track if we are currently updating the cart (e.g., adding/removing an item)
  final bool isUpdating;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.isUpdating = false,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    bool? isUpdating,
    bool clearError = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage, isUpdating];
}
""")

# cart_event.dart
write_file(os.path.join(cart_path, "cart_event.dart"), """import 'package:equatable/equatable.dart';
import '../../../domain/entities/add_cart_item_params.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddOrUpdateCartItemEvent extends CartEvent {
  final AddCartItemParams params;

  const AddOrUpdateCartItemEvent(this.params);

  @override
  List<Object?> get props => [params];
}
""")

# cart_bloc.dart
write_file(os.path.join(cart_path, "cart_bloc.dart"), """import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/usecases/get_cart_usecase.dart';
import '../../../domain/usecases/add_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;

  CartBloc(this._getCartUseCase, this._addCartItemUseCase)
      : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddOrUpdateCartItemEvent>(_onAddOrUpdateCartItem);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading, clearError: true));

    try {
      await emit.forEach<CartEntity>(
        _getCartUseCase(),
        onData: (cart) => state.copyWith(
          status: CartStatus.success,
          cart: cart,
          clearError: true,
        ),
        onError: (error, _) => state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddOrUpdateCartItem(
    AddOrUpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    // We only show isUpdating so we don't clear the whole cart UI while syncing
    emit(state.copyWith(isUpdating: true, clearError: true));

    try {
      // Calling this updates the cache in the repository,
      // which automatically triggers the stream in _onLoadCart to emit the new cart.
      await _addCartItemUseCase(event.params);
      emit(state.copyWith(isUpdating: false));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
""")

# ----------------- CHECKOUT SUMMARY BLOC -----------------

# checkout_summary_state.dart
write_file(os.path.join(checkout_path, "checkout_summary_state.dart"), """import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';

enum CheckoutSummaryStatus { initial, loading, success, failure }

class CheckoutSummaryState extends Equatable {
  final CheckoutSummaryStatus status;
  final CheckoutSummaryEntity? summary;
  final String? errorMessage;
  
  // Keep track of current params to easily modify them (like adding a tip later)
  final CheckoutSummaryParams? currentParams;

  const CheckoutSummaryState({
    this.status = CheckoutSummaryStatus.initial,
    this.summary,
    this.errorMessage,
    this.currentParams,
  });

  CheckoutSummaryState copyWith({
    CheckoutSummaryStatus? status,
    CheckoutSummaryEntity? summary,
    String? errorMessage,
    CheckoutSummaryParams? currentParams,
    bool clearError = false,
  }) {
    return CheckoutSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentParams: currentParams ?? this.currentParams,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage, currentParams];
}
""")

# checkout_summary_event.dart
write_file(os.path.join(checkout_path, "checkout_summary_event.dart"), """import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkout_summary_params.dart';

sealed class CheckoutSummaryEvent extends Equatable {
  const CheckoutSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckoutSummary extends CheckoutSummaryEvent {
  final CheckoutSummaryParams params;

  const LoadCheckoutSummary(this.params);

  @override
  List<Object?> get props => [params];
}

class ApplyPromoCodeEvent extends CheckoutSummaryEvent {
  final String promoCode;

  const ApplyPromoCodeEvent(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

class UpdateTipEvent extends CheckoutSummaryEvent {
  final double tip;

  const UpdateTipEvent(this.tip);

  @override
  List<Object?> get props => [tip];
}
""")

# checkout_summary_bloc.dart
write_file(os.path.join(checkout_path, "checkout_summary_bloc.dart"), """import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';
import '../../../domain/usecases/get_checkout_summary_usecase.dart';
import 'checkout_summary_event.dart';
import 'checkout_summary_state.dart';

class CheckoutSummaryBloc
    extends Bloc<CheckoutSummaryEvent, CheckoutSummaryState> {
  final GetCheckoutSummaryUseCase _getCheckoutSummaryUseCase;

  CheckoutSummaryBloc(this._getCheckoutSummaryUseCase)
      : super(const CheckoutSummaryState()) {
    on<LoadCheckoutSummary>(_onLoadCheckoutSummary);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<UpdateTipEvent>(_onUpdateTip);
  }

  Future<void> _onLoadCheckoutSummary(
    LoadCheckoutSummary event,
    Emitter<CheckoutSummaryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CheckoutSummaryStatus.loading,
        currentParams: event.params,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<CheckoutSummaryEntity>(
        _getCheckoutSummaryUseCase(event.params),
        onData: (summary) => state.copyWith(
          status: CheckoutSummaryStatus.success,
          summary: summary,
          clearError: true,
        ),
        onError: (error, _) => state.copyWith(
          status: CheckoutSummaryStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutSummaryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onApplyPromoCode(
    ApplyPromoCodeEvent event,
    Emitter<CheckoutSummaryState> emit,
  ) {
    if (state.currentParams == null) return;

    final newParams = CheckoutSummaryParams(
      addressId: state.currentParams!.addressId,
      promoCode: event.promoCode,
      tip: state.currentParams!.tip,
    );

    add(LoadCheckoutSummary(newParams));
  }

  void _onUpdateTip(
    UpdateTipEvent event,
    Emitter<CheckoutSummaryState> emit,
  ) {
    if (state.currentParams == null) return;

    final newParams = CheckoutSummaryParams(
      addressId: state.currentParams!.addressId,
      promoCode: state.currentParams!.promoCode,
      tip: event.tip,
    );

    add(LoadCheckoutSummary(newParams));
  }
}
""")

print("Cart and Checkout blocs generated successfully.")
