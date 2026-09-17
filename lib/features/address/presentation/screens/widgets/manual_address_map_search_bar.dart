import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_text_field.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_theme_colors.dart';

class ManualAddressMapSearchBar extends StatelessWidget {
  const ManualAddressMapSearchBar({
    super.key,
    required this.controller,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + 16.h;

    return Positioned(
      top: top,
      left: 16.w,
      right: 16.w,
      child: Row(
        children: [
          CommonActionIcon(
            icon: Assets.icons.arrowBack.path,
            onTap: () => context.pop(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomTextField(
              maxLines: 1,
              validator: (_) => null,
              borderRadius: 99,
              controller: controller,
              prefixIcon: Assets.icons.search.svg(),
              fillColor: context.colors.background,
              suffixIcon: CustomText(
                onTap: onClear,
                text: 'Clear',
                color: context.colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
