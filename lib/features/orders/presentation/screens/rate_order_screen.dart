import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/orders/presentation/blocs/rate_order/rate_order_bloc.dart';
import 'package:cheering/features/orders/presentation/blocs/rate_order/rate_order_event.dart';
import 'package:cheering/features/orders/presentation/blocs/rate_order/rate_order_state.dart';
import 'package:cheering/features/orders/presentation/helpers/rate_order_helper.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/rate_restaurant_card.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/rate_rider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateOrderScreen extends StatelessWidget {
  const RateOrderScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final deliveryMinutes = RateOrderHelper.calculateDeliveryMinutes(
      order.placedAt,
      order.deliveredAt,
    );

    return BlocConsumer<RateOrderBloc, RateOrderState>(
      listener: (context, state) {
        if (state.status == RateOrderStatus.success) {
          ToastMessageHelper.show('Thank you! Your review has been submitted.');
          Navigator.maybePop(context, true);
        } else if (state.status == RateOrderStatus.failure &&
            state.errorMessage != null) {
          ToastMessageHelper.show(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == RateOrderStatus.loading;
        return SliverScaffold(
          backgroundColor: context.colors.bgSecondary,
          sideContentPadding: 16.w,
          appBar: CustomSliverAppBar(
            title: 'Rate Your Order',
            backgroundColor: context.colors.bgSecondary.withValues(alpha: 0.8),
          ),
          bottomNavigationBar: CustomButton(
            label: 'Submit Review',
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () => context.read<RateOrderBloc>().add(
                    SubmitRateOrder(
                      orderId: order.id,
                      hasRider: order.rider != null,
                    ),
                  ),
          ),
          bodyList: [
            SizedBox(height: 12.w),
            RateRestaurantCard(
              restaurantName: order.restaurantName,
              restaurantLogoUrl: order.restaurantLogoUrl,
              tags: RateOrderHelper.tags,
              selectedTags: state.selectedTags,
              onTagToggle: (tag) =>
                  context.read<RateOrderBloc>().add(ToggleTag(tag)),
              rating: state.restaurantRating,
              onRatingChanged: (rating) => context.read<RateOrderBloc>().add(
                UpdateRestaurantRating(rating),
              ),
              onCommentChanged: (comment) =>
                  context.read<RateOrderBloc>().add(UpdateComment(comment)),
            ),
            if (order.rider != null) ...[
              SizedBox(height: 16.w),
              RateRiderCard(
                rider: order.rider!,
                rating: state.riderRating,
                deliveryMinutes: deliveryMinutes,
                onChanged: (rating) => context.read<RateOrderBloc>().add(
                  UpdateRiderRating(rating),
                ),
              ),
            ],
            SizedBox(height: 144.w),
          ],
        );
      },
    );
  }
}
