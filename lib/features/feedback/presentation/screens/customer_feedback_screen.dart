import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerFeedbackScreen extends StatefulWidget {
  const CustomerFeedbackScreen({super.key});

  @override
  State<CustomerFeedbackScreen> createState() => _CustomerFeedbackScreenState();
}

class _CustomerFeedbackScreenState extends State<CustomerFeedbackScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Good packaging',
    'Great taste',
    'Fast delivery',
  ];

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: 'Feedback',
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 16.h).asSliver,

        // ── 1. Rating Summary Header ─────────────────────────────
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Overall Rating Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: '4.3',
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 14.sp,
                          color: index < 4
                              ? const Color(0xFFF5A623)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: '(27)',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: '27 ratings',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
              SizedBox(width: 24.w),

              // Star Rating Breakdown Bars
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar('5', 0.72),
                    SizedBox(height: 4.h),
                    _buildRatingBar('4', 0.18),
                    SizedBox(height: 4.h),
                    _buildRatingBar('3', 0.06),
                    SizedBox(height: 4.h),
                    _buildRatingBar('2', 0.02),
                    SizedBox(height: 4.h),
                    _buildRatingBar('1', 0.02),
                  ],
                ),
              ),
            ],
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 16.h).asSliver,

        // ── 2. Filter Chips ──────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _filters.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.bgSecondary,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.outline,
                        width: 1,
                      ),
                    ),
                    child: CustomText(
                      text: filter,
                      fontSize: 13.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? context.colors.white
                          : context.colors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 16.h).asSliver,

        // ── 3. Customer Reviews ──────────────────────────────────
        _buildReviewCard(
          initials: 'SR',
          author: 'Sadia R.',
          timeAgo: '2 days ago',
          content:
              'Chicken bucket was super crispy and hot on arrival. Delivery was quicker than the estimate too.',
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 12.h).asSliver,

        _buildReviewCard(
          initials: 'MH',
          author: 'M. Haque',
          timeAgo: '1 week ago',
          content:
              'Good taste, portion could be a bit bigger for the combo price.',
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 24.h).asSliver,

        // ── 4. Hours Section ─────────────────────────────────────
        _buildSectionTitle('Hours').asSliverWithPadding(horizontal: 16.w),
        SizedBox(height: 8.h).asSliver,

        Container(
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildHourRow(
                day: 'Today',
                hours: 'Open · 11:00 AM - 11:00 PM',
                isHighlight: true,
              ),
              Divider(
                color: context.colors.outline.withValues(alpha: 0.5),
                height: 1,
              ),
              _buildHourRow(
                day: 'Sat - Thu',
                hours: '11:00 AM - 11:00 PM',
              ),
              Divider(
                color: context.colors.outline.withValues(alpha: 0.5),
                height: 1,
              ),
              _buildHourRow(
                day: 'Friday',
                hours: '2:00 PM - 11:00 PM',
              ),
            ],
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 20.h).asSliver,

        // ── 5. Location Section ──────────────────────────────────
        _buildSectionTitle('Location').asSliverWithPadding(horizontal: 16.w),
        SizedBox(height: 8.h).asSliver,

        Container(
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Row(
                  children: [
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 18.sp,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text: 'Road 4, Badda, Dhaka 1212',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: context.colors.outline.withValues(alpha: 0.5),
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Row(
                  children: [
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.phone_outlined,
                        size: 18.sp,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text: '+880 1XXX-XXXXXX',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 20.h).asSliver,

        // ── 6. About Section ─────────────────────────────────────
        _buildSectionTitle('About').asSliverWithPadding(horizontal: 16.w),
        SizedBox(height: 8.h).asSliver,

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: CustomText(
            text:
                'KFC serves fast food combos, fried chicken and burgers, cooked fresh to order. Halal certified.',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: context.colors.textPrimary,
            textHeight: 1.4,
          ),
        ).asSliverWithPadding(horizontal: 16.w),

        SizedBox(height: 40.h).asSliver,
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      text: title,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: context.colors.textSecondary,
    );
  }

  Widget _buildRatingBar(String star, double ratio) {
    return Row(
      children: [
        SizedBox(
          width: 12.w,
          child: CustomText(
            text: star,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5.h,
              backgroundColor: context.colors.outline.withValues(alpha: 0.6),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFF5A623),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String initials,
    required String author,
    required String timeAgo,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.colors.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: CustomText(
                  text: initials,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF16A34A),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: author,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                  CustomText(
                    text: timeAgo,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: content,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: context.colors.textPrimary,
            textHeight: 1.4,
          ),
        ],
      ),
    );
  }

  Widget _buildHourRow({
    required String day,
    required String hours,
    bool isHighlight = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: day,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.textPrimary,
          ),
          CustomText(
            text: hours,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isHighlight
                ? context.colors.success
                : context.colors.primary,
          ),
        ],
      ),
    );
  }
}
