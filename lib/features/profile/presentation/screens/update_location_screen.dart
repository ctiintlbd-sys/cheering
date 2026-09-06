/*
import 'package:cheering_partner/core/helpers/toast_message_helper.dart';
import 'package:cheering_partner/core/widgets/widgets.dart';
import 'package:cheering_partner/features/vendor_application/presentation/widget/location_map_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class UpdateLocationScreen extends StatefulWidget {
  const UpdateLocationScreen({super.key});

  @override
  State<UpdateLocationScreen> createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();
  final ValueNotifier<LatLng?> _locationNotifier = ValueNotifier<LatLng?>(null);

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        toolbarHeight: 70.h,
        title: 'Location',
      ),

      bodyList: [
        SizedBox(height: 16.h).asSliver,

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Update your business location',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 6.h),
            CustomText(
              text:
                  'Choose your exact store location on the map to help customers find you easily.',
              color: context.colors.textTertiary,
            ),
          ],
        ).asSliverWithPadding(horizontal: 24.w),

        SizedBox(height: 20.h).asSliver,

        LocationMapPickerWidget(
          height: 278.h,
          addressController: _addressController,
          onLocationSelected: (address, area, position) {
            _locationNotifier.value = position;
          },
        ).asSliverWithPadding(horizontal: 24.w),

        SizedBox(height: 24.h).asSliver,
        Form(
          key: _formKey,
          child: CustomTextField(
            controller: _addressController,
            labelText: 'Address *',
            hintText: 'Choose your address',
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: context.colors.textTertiary,
              size: 20.r,
            ),
          ),
        ).asSliverWithPadding(horizontal: 24.w),

        SizedBox(height: 80.h).asSliver,
      ],

      bottomNavigationBar: CustomButton(label: 'Next', onPressed: _onNext),
    );
  }

  void _onNext() {
    final pos = _locationNotifier.value;
    if (pos == null) {
      ToastMessageHelper.show('Please select your location on the map');
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _locationNotifier.dispose();
    super.dispose();
  }
}
*/
