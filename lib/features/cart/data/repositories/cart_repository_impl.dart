import '../../domain/entities/add_cart_item_params.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/checkout_summary_entity.dart';
import '../../domain/entities/checkout_summary_params.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../datasources/cart_remote_source.dart';
import '../../../../core/cache/cache_service.dart';
import '../../../../core/config/chache_keys.dart';
import '../../../../core/network/api_result.dart';
import '../models/cart_model.dart';
import '../models/checkout_summary_model.dart';

class CartRepositoryImpl implements ICartRepository {
  final CartRemoteSource _remoteSource;
  final CacheService _cache;

  CartRepositoryImpl(this._remoteSource, this._cache);

  @override
  Stream<CartEntity> getCart() {
    return _cache.getOrFetch<CartModel>(
      CacheKeys.cart,
      fromJson: (json) => CartModel.fromJson(json),
      toJson: (data) => data.toJson(),
      fetch: () => _remoteSource.getCart(),
      ttl: const Duration(minutes: 5),
    );
  }

  @override
  Future<CartEntity> addOrUpdateCartItem(AddCartItemParams params) async {
    final response = await _remoteSource.addOrUpdateCartItem(params);
    return response.fold(
      onSuccess: (data) {
        _cache.set<CartModel>(CacheKeys.cart, data, toJson: (d) => d.toJson());
        return data;
      },
      onFailure: (exception) => throw exception,
    );
  }

  @override
  Stream<CheckoutSummaryEntity> getCheckoutSummary(
    CheckoutSummaryParams params,
  ) {
    return _cache.getOrFetch<CheckoutSummaryModel>(
      CacheKeys.checkoutSummary(params.toQueryParameters()),
      fromJson: (json) => CheckoutSummaryModel.fromJson(json),
      toJson: (data) => data.toJson(),
      fetch: () => _remoteSource.getCheckoutSummary(params),
      ttl: const Duration(minutes: 5),
    );
  }
}
