import '../../../../core/cache/cache_service.dart';
import '../../../../core/config/chache_keys.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/i_address_repository.dart';
import '../../domain/entities/address_params.dart';
import '../datasources/address_remote_source.dart';
import '../models/address_model.dart';
import '../models/address_request_model.dart';

class AddressRepositoryImpl implements IAddressRepository {
  final AddressRemoteSource _source;
  final CacheService _cache;

  AddressRepositoryImpl(this._source, this._cache);

  @override
  Stream<List<AddressEntity>> getAddresses() {
    return _cache.getOrFetch<List<AddressModel>>(
      CacheKeys.addresses,
      fromJson: AddressModel.listFromJson,
      toJson: (list) => {'data': list.map((e) => e.toJson()).toList()},
      fetch: () => _source.getAddresses(),
      ttl: const Duration(hours: 24),
    );
  }

  @override
  Future<AddressEntity> createAddress(AddressParams params) async {
    final request = AddressRequestModel(
      type: params.type.name.toUpperCase(),
      label: params.label,
      streetAddress: params.streetAddress,
      apartment: params.apartment,
      landmark: params.landmark,
      city: params.city,
      postalCode: params.postalCode,
      contactPhone: params.contactPhone,
      latitude: params.latitude,
      longitude: params.longitude,
      isDefault: false,
    );
    final result = await _source.createAddress(request);
    return result.fold(
      onSuccess: (data) async {
        await _cache.remove(CacheKeys.addresses);
        return data;
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<AddressEntity> updateAddress(String id, AddressParams params) async {
    final request = AddressRequestModel(
      type: params.type.name.toUpperCase(),
      label: params.label,
      streetAddress: params.streetAddress,
      apartment: params.apartment,
      landmark: params.landmark,
      city: params.city,
      postalCode: params.postalCode,
      contactPhone: params.contactPhone,
      latitude: params.latitude,
      longitude: params.longitude,
      isDefault: false,
    );
    final result = await _source.updateAddress(id, request);
    return result.fold(
      onSuccess: (data) async {
        await _cache.remove(CacheKeys.addresses);
        return data;
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<void> deleteAddress(String id) async {
    final result = await _source.deleteAddress(id);
    return result.fold(
      onSuccess: (_) async {
        await _cache.remove(CacheKeys.addresses);
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<AddressEntity> setDefaultAddress(String id) async {
    final result = await _source.setDefaultAddress(id);
    return result.fold(
      onSuccess: (data) async {
        await _cache.remove(CacheKeys.addresses);
        return data;
      },
      onFailure: (e) => throw e,
    );
  }

  @override
  Future<void> clearLocalCache() {
    return _cache.remove(CacheKeys.addresses);
  }
}
