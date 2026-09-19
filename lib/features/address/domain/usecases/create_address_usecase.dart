import '../entities/address_entity.dart';
import '../repositories/i_address_repository.dart';
import '../entities/address_params.dart';

class CreateAddressUseCase {
  final IAddressRepository repository;
  CreateAddressUseCase(this.repository);

  Future<AddressEntity> call(AddressParams params) {
    return repository.createAddress(params);
  }
}
