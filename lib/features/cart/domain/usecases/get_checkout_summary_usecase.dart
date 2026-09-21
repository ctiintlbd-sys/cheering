import '../entities/checkout_summary_entity.dart';
import '../entities/checkout_summary_params.dart';
import '../repositories/i_cart_repository.dart';

class GetCheckoutSummaryUseCase {
  final ICartRepository _repository;

  GetCheckoutSummaryUseCase(this._repository);

  Stream<CheckoutSummaryEntity> call(CheckoutSummaryParams params) {
    return _repository.getCheckoutSummary(params);
  }
}
