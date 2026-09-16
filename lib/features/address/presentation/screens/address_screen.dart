import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/empty_address_widget.dart';
import 'widgets/address_action_buttons.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(66.h),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: CustomTextField(
              borderRadius: 99,
              fillColor: context.colors.bgSecondary,
              hintText: 'Search your area ...',
              prefixIcon: Assets.icons.search.svg(),
            ),
          ),
        ),
        title: 'My Address',
      ),
      bodyList: [
        SizedBox(height: 20.h),
        // Action Buttons Row
        AddressActionButtons(
          onTapCurrentLocation: () {},
          onTapEnterManually: () {},
        ),
        SizedBox(height: 32.h),
        // Empty State
        const EmptyAddressWidget(),
        SizedBox(height: 104.h),
      ],
    );
  }
}
