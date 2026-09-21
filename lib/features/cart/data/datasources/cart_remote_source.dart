import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../domain/entities/add_cart_item_params.dart';
import '../../domain/entities/checkout_summary_params.dart';
import '../models/cart_model.dart';
import '../models/checkout_summary_model.dart';

class CartRemoteSource {
  final IApiClient _apiClient;

  CartRemoteSource(this._apiClient);

  Future<ApiResult<CartModel>> getCart() async {
    return _apiClient.get<CartModel>(
      ApiEndpoints.cart,
      fromJson: (json) => CartModel.fromJson(json['data'] ?? {}),
    );
  }

  Future<ApiResult<CartModel>> addOrUpdateCartItem(AddCartItemParams params) async {
    return _apiClient.post<CartModel>(
      ApiEndpoints.cartItems,
      body: params.toJson(),
      fromJson: (json) => CartModel.fromJson(json['data'] ?? {}),
    );
  }

  Future<ApiResult<CheckoutSummaryModel>> getCheckoutSummary(CheckoutSummaryParams params) async {
    return _apiClient.get<CheckoutSummaryModel>(
      ApiEndpoints.checkoutSummary,
      queryParameters: params.toQueryParameters(),
      fromJson: (json) => CheckoutSummaryModel.fromJson(json['data'] ?? {}),
    );
  }
}

