import '../entities/address_entity.dart';
import '../repositories/i_address_repository.dart';

class UpdateAddressUseCase {
  final IAddressRepository repository;
  UpdateAddressUseCase(this.repository);

  Future<AddressEntity> call({
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
  }) {
    return repository.updateAddress(
      id: id,
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
  }
}
