import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/address_model.dart';
import '../models/address_request_model.dart';

class AddressRemoteSource {
  final IApiClient _client;

  AddressRemoteSource(this._client);

  Future<ApiResult<List<AddressModel>>> getAddresses() {
    return _client.get(
      ApiEndpoints.addresses,
      fromJson: (json) {
        final data = json['data'] as List;
        return data
            .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<ApiResult<AddressModel>> createAddress(AddressRequestModel request) {
    return _client.post(
      ApiEndpoints.addresses,
      body: request.toJson(),
      fromJson: (json) =>
          AddressModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResult<AddressModel>> updateAddress(
    String id,
    AddressRequestModel request,
  ) {
    return _client.put(
      '${ApiEndpoints.addresses}/$id',
      body: request.toJson(),
      fromJson: (json) =>
          AddressModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResult<void>> deleteAddress(String id) {
    return _client.delete('${ApiEndpoints.addresses}/$id', fromJson: (_) {});
  }

  Future<ApiResult<AddressModel>> setDefaultAddress(String id) {
    return _client.patch(
      '${ApiEndpoints.addresses}/$id/default',
      fromJson: (json) =>
          AddressModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
