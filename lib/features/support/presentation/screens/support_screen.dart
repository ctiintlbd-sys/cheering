import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _expandedFaqIndex = 1; // 2nd FAQ expanded by default

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I update my menu?',
      'answer':
          'You can add or edit items directly in the Menu tab from the bottom navigation.',
    },
    {
      'question': 'How do refunds work?',
      'answer':
          'You can reach our support team via the “Contact Us” option available in the app.',
    },
    {
      'question': 'When do payouts arrive?',
      'answer':
          'Payouts are processed instantly to your mobile wallet or within 1–2 business days to your bank.',
    },
    {
      'question': 'How is my rating calculated?',
      'answer':
          'Your rating is an average of customer reviews submitted over the last 90 days.',
    },
    {
      'question': 'How do I pause my store?',
      'answer':
          'You can toggle store status from the top bar on the Home / Overview screen.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      backgroundColor: context.colors.background,
      appBar: CustomSliverAppBar(
        title: 'Support',
        centerTitle: true,
        showLeading: true,
        backAction: () => Navigator.pop(context),
      ),
      bodyList: [
        SizedBox(height: 16.h),

        // ── 1. Search Bar ────────────────────────────────────────
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20.sp,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: context.colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ).horizontal(16),

        SizedBox(height: 16.h),

        // ── 2. Quick Actions (Chat / Call) ───────────────────────
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chat with us',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Connecting to live chat support...'),
                      backgroundColor: context.colors.primary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildContactCard(
                icon: Icons.phone_outlined,
                title: 'Call support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Calling partner support helpline...'),
                      backgroundColor: context.colors.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ).horizontal(16),

        SizedBox(height: 24.h),

        // ── 3. Frequently Asked Section ──────────────────────────
        CustomText(
          text: 'Frequently asked',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: context.colors.textSecondary,
        ).horizontal(16),

        SizedBox(height: 12.h),

        ..._faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          final isExpanded = _expandedFaqIndex == index;

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedFaqIndex = isExpanded ? null : index;
                });
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: isExpanded ? 16.h : 14.h),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: faq['question']!,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.chevron_right_rounded,
                          size: 20.sp,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                    if (isExpanded) ...[
                      SizedBox(height: 10.h),
                      CustomText(
                        text: faq['answer']!,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: context.colors.textSecondary,
                        textHeight: 1.4,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ).horizontal(16);
        }),

        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
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
            Icon(
              icon,
              size: 24.sp,
              color: context.colors.textPrimary,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
