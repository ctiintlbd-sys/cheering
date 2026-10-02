import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/support/data/models/faq_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({super.key});

  final ValueNotifier<int?> _expandedFaqIndex = ValueNotifier<int?>(-1);

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        title: 'Help Center',
        backgroundColor: context.colors.background.withValues(alpha: 0.4),
      ),
      bodyList: [
        SizedBox(height: 16.w),
        CustomTextField(
          prefixIcon: Assets.icons.search.svg(),
          fillColor: context.colors.bgSecondary,
          borderRadius: 99.r,
          borderColor: context.colors.bgSecondary,
          hintText: 'Search for help',
          validatorType: null,
        ),
        SizedBox(height: 24.w),
        ...faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          return ValueListenableBuilder<int?>(
            valueListenable: _expandedFaqIndex,
            builder: (context, expandedIndex, _) {
              final isExpanded = expandedIndex == index;
              return CustomContainer(
                radiusAll: 12.w,
                paddingVertical: 16.w,
                paddingHorizontal: 12.w,
                bordersColor: context.colors.borderTertiary,
                onTap: () {
                  _expandedFaqIndex.value = isExpanded ? null : index;
                },
                marginBottom: 8.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: faq.question,
                            fontSize: 16.r,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.chevron_right_rounded,
                          size: 20.r,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                    if (isExpanded)
                      CustomText(
                        top: 12.w,
                        text: faq.answer,
                        color: context.colors.textTertiary,
                      ),
                  ],
                ),
              );
            },
          );
        }),
        SizedBox(height: 40.w),
      ],

      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80.w, right: 6.w),
        child: SizedBox(
          height: 48.w,
          width: 48.w,
          child: CommonActionIcon(
            color: context.colors.primary,
            iconColor: context.colors.white,
            icon: Assets.icons.call.path,
            onTap: () => _open(Uri.parse('tel:+8801878740266')),
          ),
        ),
      ),
    );
  }

  Future<void> _open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
