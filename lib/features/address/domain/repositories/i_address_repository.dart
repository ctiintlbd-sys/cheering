import '../entities/address_entity.dart';

abstract class IAddressRepository {
  Future<List<AddressEntity>> getAddresses();

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
  });

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
  });

  Future<void> deleteAddress(String id);

  Future<AddressEntity> setDefaultAddress(String id);
}
