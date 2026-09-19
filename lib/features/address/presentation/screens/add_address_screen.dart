import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/entities/address_params.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_form_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    final edit = widget.args;

    _houseController = TextEditingController(text: edit.apartment);
    _areaController = TextEditingController(text: _areaTextOf(edit));
    _landmarkController = TextEditingController(text: edit.landmark ?? '');
    _phoneController = TextEditingController(text: edit.contactPhone ?? '');
  }

  @override
  void dispose() {
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  static String _areaTextOf(AddressEntity address) {
    return [
      address.streetAddress,
      address.city,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }

  Future<void> _changeLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      RoutePaths.manualAddressMap,
    );
    if (result == null || !mounted) return;

    final updatedLocation = AddressEntity.fromManualMap(result);
    context.read<AddressFormCubit>().setLocation(updatedLocation);

    final newAreaText = _areaTextOf(updatedLocation);
    if (newAreaText.isNotEmpty) {
      _areaController.text = newAreaText;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final form = context.read<AddressFormCubit>().state;
    final params = AddressParams(
      type: form.type,
      apartment: _houseController.text.trim(),
      streetAddress: _areaController.text.trim(),
      landmark: _landmarkController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      latitude: form.location.latitude,
      longitude: form.location.longitude,
    );

    context.read<AddressBloc>().add(
      SaveAddressRequested(
        params: params,
        addressId: widget.args.id.isNotEmpty ? widget.args.id : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (prev, curr) => prev.mutationStatus != curr.mutationStatus,
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
        appBar: const CustomSliverAppBar(title: 'Add Address'),
        bodyList: [
          SizedBox(height: 8.h),
          BlocSelector<AddressFormCubit, AddressFormState, AddressEntity>(
            selector: (state) => state.location,
            builder: (context, location) => AddAddressLocationCard(
              address: location,
              onChangeTap: _changeLocation,
            ),
          ),
          SizedBox(height: 24.h),
          BlocSelector<AddressFormCubit, AddressFormState, AddressType>(
            selector: (state) => state.type,
            builder: (context, type) => SaveAsTypeSelector(
              selected: type,
              onChanged: (value) =>
                  context.read<AddressFormCubit>().setType(value),
            ),
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
                  onTap: _changeLocation,
                  readOnly: true,
                  labelText: 'Area',
                  hintText: 'type you location',
                  controller: _areaController,
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
                  validatorType: null,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText(
                        text: '+880',
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        width: 1,
                        height: 20.h,
                        margin: EdgeInsets.only(left: 8.w),
                        color: context.colors.textPlaceholder,
                      ),
                    ],
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 60.w),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
        bottomNavigationBar: BlocSelector<AddressBloc, AddressState, bool>(
          selector: (state) => state.isSaving,
          builder: (context, isSaving) => CustomButton(
            text: 'Save Address',
            isLoading: isSaving,
            onPressed: isSaving ? null : _save,
          ),
        ),
      ),
    );
  }
}
