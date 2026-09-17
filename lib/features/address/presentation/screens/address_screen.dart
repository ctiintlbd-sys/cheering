import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/services/current_location_service.dart';
import 'package:cheering/core/services/map_location_service.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/address_entity.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import '../models/add_address_route_args.dart';
import '../utils/address_display.dart';
import 'widgets/address_action_buttons.dart';
import 'widgets/address_options_menu.dart';
import 'widgets/empty_address_widget.dart';
import 'widgets/saved_address_card.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickLocationOnMap() async {
    final mapResult = await context.push<Map<String, dynamic>>(
      RoutePaths.manualAddressMap,
    );
    if (mapResult == null || !mounted) return;
    await _openAddAddress(
      AddAddressRouteArgs.fromMapResult(mapResult),
    );
  }

  Future<void> _useCurrentLocation() async {
    final result = await getIt<CurrentLocationService>().fetchCurrentLocation();
    if (!mounted) return;
    if (!result.isSuccess) {
      ToastMessageHelper.show(result.failure!.message);
      return;
    }
    final latLng = result.latLng!;
    final mapService = MapLocationService();
    final snapshot = await mapService.reverseGeocode(
      latLng,
      ignoreDistanceCheck: true,
    );
    if (!mounted) return;

    await _openAddAddress(
      AddAddressRouteArgs(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        primaryLine: snapshot?.address ?? 'Current location',
        secondaryLine: snapshot?.area ?? '',
      ),
    );
  }

  Future<void> _openAddAddress(AddAddressRouteArgs args) async {
    final saved = await context.push<bool>(
      RoutePaths.addAddress,
      extra: args,
    );
    if (saved == true && mounted) {
      context.read<AddressBloc>().add(const RefreshAddressesRequested());
    }
  }

  Future<void> _onAddressMenu(
    BuildContext context,
    AddressEntity address,
    Offset position,
  ) async {
    final action = await showAddressOptionsMenu(
      context: context,
      position: position,
      isDefault: address.isDefault,
    );
    if (action == null || !context.mounted) return;

    final bloc = context.read<AddressBloc>();
    switch (action) {
      case AddressMenuAction.edit:
        await _openAddAddress(
          AddAddressRouteArgs(
            latitude: address.latitude,
            longitude: address.longitude,
            primaryLine: address.subtitleLine1.isNotEmpty
                ? address.subtitleLine1
                : address.titleLabel,
            secondaryLine: address.subtitleLine2,
            editAddress: address,
          ),
        );
      case AddressMenuAction.setDefault:
        bloc.add(SetDefaultAddressRequested(address.id));
      case AddressMenuAction.delete:
        bloc.add(DeleteAddressRequested(address.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (prev, curr) =>
          prev.mutationStatus != curr.mutationStatus &&
          curr.mutationStatus == AddressMutationStatus.failure,
      listener: (context, state) {
        ToastMessageHelper.show(state.errorMessage ?? 'Something went wrong');
        context.read<AddressBloc>().add(const ResetAddressMutationStatus());
      },
      child: SliverScaffold(
        sideContentPadding: 16.w,
        appBar: CustomSliverAppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(66.h),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: CustomTextField(
                controller: _searchController,
                validatorType: null,
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
          AddressActionButtons(
            onTapCurrentLocation: _useCurrentLocation,
            onTapEnterManually: _pickLocationOnMap,
          ),
          SizedBox(height: 28.h),
          BlocBuilder<AddressBloc, AddressState>(
            buildWhen: (prev, curr) =>
                prev.status != curr.status ||
                prev.addresses != curr.addresses,
            builder: (context, state) {
              if (state.isLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (state.status == AddressStatus.failure &&
                  state.addresses.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: state.errorMessage ?? 'Failed to load addresses',
                    color: context.colors.textSecondary,
                  ),
                );
              }

              final filtered = state.addresses
                  .where((a) => a.matchesSearch(_searchQuery))
                  .toList();

              if (state.addresses.isEmpty) {
                return const EmptyAddressWidget();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Saved Address',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 16.h),
                  if (filtered.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: CustomText(
                        text: 'No address matches your search',
                        color: context.colors.textSecondary,
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final address = filtered[index];
                        return SavedAddressCard(
                          address: address,
                          onMenuTap: (position) => _onAddressMenu(
                            context,
                            address,
                            position,
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 104.h),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
