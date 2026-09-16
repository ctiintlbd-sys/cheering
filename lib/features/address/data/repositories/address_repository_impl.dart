import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/i_address_repository.dart';
import '../datasources/address_remote_source.dart';
import '../models/address_request_model.dart';

class AddressRepositoryImpl implements IAddressRepository {
  final IAddressRemoteSource remoteSource;

  AddressRepositoryImpl(this.remoteSource);

  @override
  Future<List<AddressEntity>> getAddresses() async {
    return await remoteSource.getAddresses();
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
    return await remoteSource.createAddress(request);
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
    return await remoteSource.updateAddress(id, request);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await remoteSource.deleteAddress(id);
  }

  @override
  Future<AddressEntity> setDefaultAddress(String id) async {
    return await remoteSource.setDefaultAddress(id);
  }
}
