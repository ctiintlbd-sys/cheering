import '../entities/add_cart_item_params.dart';
import '../entities/cart_entity.dart';
import '../entities/checkout_summary_entity.dart';
import '../entities/checkout_summary_params.dart';

abstract class ICartRepository {
  Stream<CartEntity> getCart();
  Future<CartEntity> addOrUpdateCartItem(AddCartItemParams params);
  Stream<CheckoutSummaryEntity> getCheckoutSummary(CheckoutSummaryParams params);
}
