import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    final edit = widget.args;
    
    // Initialize form state in AddressBloc
    context.read<AddressBloc>().add(InitFormEvent(edit));

    _houseController = TextEditingController();
    
    // Formatting the area gracefully
    final areaText = [edit.streetAddress, edit.city]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
        
    _areaController = TextEditingController(text: areaText);
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

  Future<void> _changeLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      RoutePaths.manualAddressMap,
    );
    if (result == null || !mounted) return;

    final updatedLocation = AddressEntity.fromManualMap(result);
    context.read<AddressBloc>().add(UpdateFormLocationEvent(updatedLocation));
    
    // Update the area controller when map location changes
    final newAreaText = [updatedLocation.streetAddress, updatedLocation.city]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
    if (newAreaText.isNotEmpty) {
      _areaController.text = newAreaText;
    }
  }

  void _save(AddressState formState) {
    if (!_formKey.currentState!.validate()) return;
    
    if (formState.formLocation == null) {
       ToastMessageHelper.show('Location is missing');
       return;
    }

    final params = AddressParams(
      type: formState.formType,
      label: formState.formLocation!.label,
      streetAddress: _houseController.text.trim(),
      city: _areaController.text.trim(),
      landmark: _landmarkController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      latitude: formState.formLocation!.latitude,
      longitude: formState.formLocation!.longitude,
      isDefault: formState.formIsDefault,
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
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return SliverScaffold(
            sideContentPadding: 16.w,
            appBar: const CustomSliverAppBar(title: 'Add Address'),
            bodyList: [
              SizedBox(height: 8.h),
              if (state.formLocation != null)
                AddAddressLocationCard(
                  address: state.formLocation!,
                  onChangeTap: _changeLocation,
                ),
              SizedBox(height: 24.h),
              SaveAsTypeSelector(
                selected: state.formType,
                onChanged: (type) => context.read<AddressBloc>().add(UpdateFormTypeEvent(type)),
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
              SizedBox(height: 16.h),
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () => context.read<AddressBloc>().add(ToggleFormDefaultEvent(!state.formIsDefault)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: Checkbox(
                          value: state.formIsDefault,
                          activeColor: context.colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          onChanged: (v) => context.read<AddressBloc>().add(ToggleFormDefaultEvent(v ?? false)),
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
            bottomNavigationBar: CustomButton(
              text: 'Save Address',
              isLoading: state.isSaving,
              onPressed: state.isSaving ? null : () => _save(state),
            ),
          );
        },
      ),
    );
  }
}
