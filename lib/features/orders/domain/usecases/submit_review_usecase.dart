import '../entities/submit_review_params.dart';
import '../repositories/i_orders_repository.dart';

class SubmitReviewUseCase {
  final IOrdersRepository _repository;

  SubmitReviewUseCase(this._repository);

  Future<void> call(SubmitReviewParams params) {
    return _repository.submitReview(params);
  }
}
