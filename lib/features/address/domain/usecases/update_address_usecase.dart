import '../entities/address_entity.dart';
import '../repositories/i_address_repository.dart';
import 'address_params.dart';

class UpdateAddressUseCase {
  final IAddressRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<AddressEntity> call(String id, AddressParams params) {
    return repository.updateAddress(id, params);
  }
}
