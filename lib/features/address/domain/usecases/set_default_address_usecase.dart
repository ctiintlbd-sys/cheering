import '../entities/address_entity.dart';
import '../repositories/i_address_repository.dart';

class SetDefaultAddressUseCase {
  final IAddressRepository repository;
  SetDefaultAddressUseCase(this.repository);
  Future<AddressEntity> call(String id) => repository.setDefaultAddress(id);
}
