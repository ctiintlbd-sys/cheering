import '../../../../core/network/api_result.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/i_address_repository.dart';
import '../datasources/address_remote_source.dart';
import '../models/address_request_model.dart';

class AddressRepositoryImpl implements IAddressRepository {
  final AddressRemoteSource _source;

  AddressRepositoryImpl(this._source);

  @override
  Future<List<AddressEntity>> getAddresses() async {
    final result = await _source.getAddresses();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<AddressEntity> createAddress({
    required String type,
    String? label,
    String? streetAddress,
    String? apartment,
    String? landmark,
    String? city,
    String? postalCode,
    String? contactPhone,
    required double latitude,
    required double longitude,
    required bool isDefault,
  }) async {
    final request = AddressRequestModel(
      type: type,
      label: label,
      streetAddress: streetAddress,
      apartment: apartment,
      landmark: landmark,
      city: city,
      postalCode: postalCode,
      contactPhone: contactPhone,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );
    final result = await _source.createAddress(request);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<AddressEntity> updateAddress({
    required String id,
    required String type,
    String? label,
    String? streetAddress,
    String? apartment,
    String? landmark,
    String? city,
    String? postalCode,
    String? contactPhone,
    required double latitude,
    required double longitude,
    required bool isDefault,
  }) async {
    final request = AddressRequestModel(
      type: type,
      label: label,
      streetAddress: streetAddress,
      apartment: apartment,
      landmark: landmark,
      city: city,
      postalCode: postalCode,
      contactPhone: contactPhone,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );
    final result = await _source.updateAddress(id, request);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<void> deleteAddress(String id) async {
    final result = await _source.deleteAddress(id);
    return result.fold(
      onSuccess: (_) {},
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<AddressEntity> setDefaultAddress(String id) async {
    final result = await _source.setDefaultAddress(id);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (e) => throw e,
    );
  }
}
