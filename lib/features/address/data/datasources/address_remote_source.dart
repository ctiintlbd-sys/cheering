import 'package:dio/dio.dart';
import '../models/address_model.dart';
import '../models/address_request_model.dart';

abstract class IAddressRemoteSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress(AddressRequestModel request);
  Future<AddressModel> updateAddress(String id, AddressRequestModel request);
  Future<void> deleteAddress(String id);
  Future<AddressModel> setDefaultAddress(String id);
}

class AddressRemoteSourceImpl implements IAddressRemoteSource {
  final Dio dio;

  AddressRemoteSourceImpl(this.dio);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await dio.get('/api/v1/users/me/addresses');

    final data = response.data['data'] as List;
    return data.map((json) => AddressModel.fromJson(json)).toList();
  }

  @override
  Future<AddressModel> createAddress(AddressRequestModel request) async {
    final response = await dio.post(
      '/api/v1/users/me/addresses',
      data: request.toJson(),
    );
    return AddressModel.fromJson(response.data['data']);
  }

  @override
  Future<AddressModel> updateAddress(String id, AddressRequestModel request) async {
    final response = await dio.put(
      '/api/v1/users/me/addresses/$id',
      data: request.toJson(),
    );
    return AddressModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await dio.delete('/api/v1/users/me/addresses/$id');
  }

  @override
  Future<AddressModel> setDefaultAddress(String id) async {
    final response = await dio.patch('/api/v1/users/me/addresses/$id/default');
    return AddressModel.fromJson(response.data['data']);
  }
}
