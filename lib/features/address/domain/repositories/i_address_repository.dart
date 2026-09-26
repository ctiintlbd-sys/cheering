import '../entities/address_entity.dart';
import '../entities/address_params.dart';

abstract class IAddressRepository {
  Stream<List<AddressEntity>> getAddresses();
  Future<AddressEntity> createAddress(AddressParams params);
  Future<AddressEntity> updateAddress(String id, AddressParams params);
  Future<void> deleteAddress(String id);
  Future<AddressEntity> setDefaultAddress(String id);
  Future<void> clearLocalCache();
}
