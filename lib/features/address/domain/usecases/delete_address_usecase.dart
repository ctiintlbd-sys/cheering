import '../repositories/i_address_repository.dart';

class DeleteAddressUseCase {
  final IAddressRepository repository;
  DeleteAddressUseCase(this.repository);
  Future<void> call(String id) => repository.deleteAddress(id);
}
