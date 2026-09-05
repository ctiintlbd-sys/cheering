import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_network_image.dart';
import 'package:cheering/core/widgets/custom_sliver_app_bar.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:cheering/core/widgets/custom_text_field.dart';
import 'package:cheering/core/widgets/sliver_scaffold.dart';
import 'package:cheering/features/food/presentation/screens/widgets/delivery_title_widget.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_flexible_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        expandedHeight: 234.h,
        titleWidget: const DeliveryTitleWidget(address: 'House 25, Banani Rd 11...',),
        flexibleBackground: const FoodFlexibleBackground(),
      ),
      bodyList: [
        SizedBox(height: 44.h),
      ],
    );
  }
}
