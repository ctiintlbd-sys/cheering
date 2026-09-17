import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/usecases/address_params.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import 'widgets/add_address_location_card.dart';
import 'widgets/save_as_type_selector.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, required this.args});

  final AddressEntity args;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _houseController;
  late final TextEditingController _areaController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _phoneController;
  late AddressType _type;

  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final edit = widget.args;
    _houseController = TextEditingController(text: edit.streetAddress ?? '');
    _areaController = TextEditingController(text: edit.city ?? '');
    _landmarkController = TextEditingController(text: edit.landmark ?? '');
    _phoneController = TextEditingController(text: edit.contactPhone ?? '');
    if (_type == AddressType.unknown) _type = AddressType.home;
    _isDefault = edit.isDefault;
  }

  @override
  void dispose() {
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _changeLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      RoutePaths.manualAddressMap,
    );
    if (result == null || !mounted) return;

  }


  @override
  Widget build(BuildContext context) {
    final address = widget.args;
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (prev, curr) =>
          prev.mutationStatus != curr.mutationStatus,
      listener: (context, state) {
        switch (state.mutationStatus) {
          case AddressMutationStatus.success:
            context.read<AddressBloc>().add(const ResetAddressMutationStatus());
            context.pop(true);
          case AddressMutationStatus.failure:
            ToastMessageHelper.show(
              state.errorMessage ?? 'Failed to save address',
            );
            context.read<AddressBloc>().add(const ResetAddressMutationStatus());
          case AddressMutationStatus.initial:
          case AddressMutationStatus.loading:
            break;
        }
      },
      child: SliverScaffold(
        sideContentPadding: 16.w,
        appBar: CustomSliverAppBar(title:'Add Address'),
        bodyList: [
          SizedBox(height: 8.h),
          AddAddressLocationCard(
            fullAddress: address.label ?? '',
            city: address.city ?? '',
            onChangeTap: _changeLocation,
          ),
          SizedBox(height: 24.h),
          SaveAsTypeSelector(
            selected: _type,
            onChanged: (type) => setState(() => _type = type),
          ),
          SizedBox(height: 24.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  labelText: 'House / road / block',
                  hintText: 'House 12, Road 8',
                  controller: _houseController,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  labelText: 'Area / thana',
                  hintText: 'Banani',
                  controller: _areaController,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  labelText: 'Landmark (helps the rider find you)',
                  hintText: 'Near City Bank, Blue gate',
                  controller: _landmarkController,
                  validatorType: null,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  labelText: 'Phone Number',
                  hintText: '01************',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 8.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: '+880',
                          fontWeight: FontWeight.w500,
                        ),
                        Container(
                          width: 1,
                          height: 20.h,
                          margin: EdgeInsets.only(left: 8.w),
                          color: context.colors.borderTertiary,
                        ),
                      ],
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 88.w),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () => setState(() => _isDefault = !_isDefault),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: Checkbox(
                      value: _isDefault,
                      activeColor: context.colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      onChanged: (v) => setState(() => _isDefault = v ?? false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomText(
                      text: 'Set as default address',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
        bottomNavigationBar: BlocBuilder<AddressBloc, AddressState>(
          buildWhen: (prev, curr) => prev.isSaving != curr.isSaving,
          builder: (context, state) {
            return CustomButton(
              text: 'Save Address',
              isLoading: state.isSaving,
              onPressed: state.isSaving ? null : _save,
            );
          },
        ),
      ),
    );
  }


  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // final phone = _phoneController.text.trim();
    // final fullPhone = phone.isEmpty ? null : '+880$phone';
    //
    // context.read<AddressBloc>().add(
    //   SaveAddressRequested(
    //     addressId: ,
    //     params: AddressParams(
    //       type: _type,
    //       label: _type == AddressType.other ? 'Other' : null,
    //       streetAddress: _houseController.text.trim(),
    //       city: _areaController.text.trim(),
    //       landmark: _landmarkController.text.trim().isEmpty
    //           ? null
    //           : _landmarkController.text.trim(),
    //       contactPhone: fullPhone,
    //       latitude: _latitude,
    //       longitude: _longitude,
    //       isDefault: _isDefault,
    //     ),
    //   ),
    // );
  }

}
