import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/about_as/html/our_story_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class OurStoryScreen extends StatelessWidget {
  const OurStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        backgroundColor: context.colors.background.withValues(alpha: 0.4),
      ),
      bodyList: [
        HtmlWidget(
          ourStoryHtml,
          textStyle: TextStyle(
            fontSize: 16.r,
            color: context.colors.textPrimary,
            height: 1.7,
          ),
        ),
        SizedBox(height: 84.w),
      ],
    );
  }
}
