import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_args.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/rating_stars_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateOrderScreen extends StatefulWidget {
  const RateOrderScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  late final TextEditingController _commentController;

  int _restaurantRating = 0;
  int _riderRating = 0;

  static const _tags = [
    'Great taste',
    'Fast delivery',
    'Good packaging',
    'Accurate order',
    'Friendly rider',
  ];

  final Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    ToastMessageHelper.show('Thank you! Your review has been submitted.');
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    int deliveryMinutes = 24;
    if (order.deliveredAt != null && order.placedAt != null) {
      final diff = order.deliveredAt!.difference(order.placedAt!);
      deliveryMinutes = diff.inMinutes > 0 ? diff.inMinutes : 24;
    }
    final riderRating = order.rider?.ratingAvg ?? 5.0;
    return SliverScaffold(
      backgroundColor: context.colors.bgSecondary,
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        title: 'Rate Your Order',
        backgroundColor: context.colors.bgSecondary.withValues(alpha: 0.8),
      ),
      bottomNavigationBar: CustomButton(
        label: 'Submit Review',
        onPressed: _handleSubmit,
      ),
      bodyList: [
        SizedBox(height: 12.w),
        CustomContainer(
          color: context.colors.background,
          radiusAll: 16.r,
          paddingAll: 12.w,
          child: Column(
            children: [
              CustomNetworkImage(
                imageUrl: order.restaurantLogoUrl,
                width: 48.r,
                height: 48.r,
                borderRadius: 8.r,
              ),
              SizedBox(height: 12.w),

              CustomText(
                text: 'How was ${order.restaurantName}?',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.w),

              CustomText(
                text:
                    'Your feedback helps other customers and the restaurant',
                color: context.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.w),
              CustomText(
                text: 'What went well?',
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.w),

              // Tags
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.w,
                runSpacing: 10.w,
                children: _tags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected
                            ? _selectedTags.remove(tag)
                            : _selectedTags.add(tag);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.colors.primaryLight
                            : context.colors.background,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: isSelected
                              ? context.colors.primaryLight
                              : context.colors.borderTertiary,
                        ),
                      ),
                      child: CustomText(
                        text: tag,
                        fontSize: 12.r,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 22.w),
              RatingStarsRow(
                title: 'Rate restaurant',
                rating: _restaurantRating,
                onChanged: (v) => setState(() => _restaurantRating = v),
              ),
              SizedBox(height: 20.w),
              CustomTextField(
                labelBottom: 8.w,
                borderRadius: 10.r,
                validator: (_) => null,
                fillColor: context.colors.background,
                minLines: 3,
                labelText: 'Leave a comment (optional)',
                hintText: 'Placeholder',
              ),
            ],
          ),
        ),
        if (order.rider != null) ...[
          SizedBox(height: 22.w),
          CustomContainer(
            color: context.colors.background,
            radiusAll: 16.r,
            paddingAll: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingStarsRow(
                  title: 'Rate your rider',
                  rating: _riderRating,
                  onChanged: (v) => setState(() => _riderRating = v),
                ),
                SizedBox(height: 12.w),
                CustomContainer(
                  radiusAll: 12.r,
                  color: context.colors.bgSecondary,
                  paddingAll: 8.w,
                  child: Row(
                    children: [
                      CustomNetworkImage(
                        width: 44.r,
                        height: 44.r,
                        boxShape: BoxShape.circle,
                        imageUrl: order.rider!.photoUrl,
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: order.rider!.name,
                              fontSize: 16.r,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                            ),
                            SizedBox(height: 4.w),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12.r,
                                  color: context.colors.textTertiary,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Assets.icons.star.svg(
                                      height: 12.r,
                                      width: 12.r,
                                      color: context.colors.ratingColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${riderRating.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                  const TextSpan(text: ' • '),
                                  TextSpan(
                                    text:
                                        'Delivered in $deliveryMinutes mins',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 144.w),
      ],
    );
  }
}
