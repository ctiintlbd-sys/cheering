import '../entities/address_entity.dart';
import '../repositories/i_address_repository.dart';

class GetAddressesUseCase {
  final IAddressRepository repository;
  GetAddressesUseCase(this.repository);
  Future<List<AddressEntity>> call() => repository.getAddresses();
}
