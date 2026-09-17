import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/app_router_notifier.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/services/current_location_service.dart';
import 'package:cheering/core/services/map_location_service.dart';
import 'package:cheering/core/services/active_location_service.dart';
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
import 'widgets/address_action_buttons.dart';
import 'widgets/empty_address_widget.dart';
import 'widgets/saved_address_card.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _searchController = TextEditingController();
  AddressEntity? _currentLocationAddress;
  bool _isFetchingLocation = true;
  late String _activeDefaultId;

  @override
  void initState() {
    super.initState();
    _activeDefaultId = getIt<ActiveLocationService>().activeAddress?.id ?? 'current_location';
    _fetchInitialLocation();
  }

  Future<void> _fetchInitialLocation() async {
    try {
      final result =
          await getIt<CurrentLocationService>().fetchCurrentLocation();
      if (result.isSuccess && result.latLng != null) {
        final snapshot =
            await MapLocationService().reverseGeocode(result.latLng!);
        if (snapshot != null) {
          if (mounted) {
            setState(() {
              _currentLocationAddress = AddressEntity(
                id: 'current_location',
                type: AddressType.other,
                label: snapshot.area,
                streetAddress: snapshot.address,
                latitude: snapshot.position.latitude,
                longitude: snapshot.position.longitude,
                isDefault: _activeDefaultId == 'current_location',
              );
              _isFetchingLocation = false;
            });
          }
          return;
        }
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _currentLocationAddress = AddressEntity(
          id: 'current_location',
          type: AddressType.other,
          label: 'Current Location',
          streetAddress: 'Tap to pick location',
          latitude: 0.0,
          longitude: 0.0,
          isDefault: _activeDefaultId == 'current_location',
        );
        _isFetchingLocation = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isLoggedIn => getIt<AppRouterNotifier>().isAuthenticated;

  Future<void> _onTapCurrentLocation() async {
    final mapResult = await context.push<Map<String, dynamic>>(
      RoutePaths.manualAddressMap,
    );
    if (mapResult == null || !mounted) return;

    setState(() {
      _activeDefaultId = 'current_location';
      _currentLocationAddress = AddressEntity(
        id: 'current_location',
        type: AddressType.other,
        label: mapResult['area'] as String? ?? 'Current Location',
        streetAddress: mapResult['address'] as String?,
        latitude: mapResult['latitude'] as double,
        longitude: mapResult['longitude'] as double,
        isDefault: true,
      );
    });
  }

  Future<void> _onTapEnterManually() async {
    final mapResult = await context.push<Map<String, dynamic>>(
      RoutePaths.manualAddressMap,
    );
    if (mapResult == null || !mounted) return;

    if (_isLoggedIn) {
      final addressToPass = AddressEntity(
        id: '',
        type: AddressType.home,
        label: mapResult['area'] as String?,
        streetAddress: mapResult['address'] as String?,
        city: mapResult['area'] as String?,
        latitude: mapResult['latitude'] as double,
        longitude: mapResult['longitude'] as double,
        isDefault: false,
      );
      final saved = await context.push<bool>(RoutePaths.addAddress, extra: addressToPass);
      if (saved == true && mounted) {
        context.read<AddressBloc>().add(const RefreshAddressesRequested());
      }
    } else {
      setState(() {
        _activeDefaultId = 'current_location';
        _currentLocationAddress = AddressEntity(
          id: 'current_location',
          type: AddressType.other,
          label: mapResult['area'] as String? ?? 'Current Location',
          streetAddress: mapResult['address'] as String?,
          latitude: mapResult['latitude'] as double,
          longitude: mapResult['longitude'] as double,
          isDefault: true,
        );
      });
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
            onTapCurrentLocation: _onTapCurrentLocation,
            onTapEnterManually: _onTapEnterManually,
          ),
          SizedBox(height: 28.h),
          BlocBuilder<AddressBloc, AddressState>(
            buildWhen: (prev, curr) =>
                prev.status != curr.status || prev.addresses != curr.addresses,
            builder: (context, state) {
              if (state.isLoading || _isFetchingLocation) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final addresses = state.addresses;
              final List<AddressEntity> displayAddresses = [];
              if (_currentLocationAddress != null) {
                displayAddresses.add(_currentLocationAddress!.copyWith(
                  isDefault: _activeDefaultId == 'current_location',
                ));
              }
              for (final addr in addresses) {
                displayAddresses.add(addr.copyWith(
                  isDefault: _activeDefaultId == addr.id,
                ));
              }

              if (displayAddresses.isEmpty) {
                return const EmptyAddressWidget();
              }

              // Update the global active address so other parts of the app can use it
              WidgetsBinding.instance.addPostFrameCallback((_) {
                try {
                  final active = displayAddresses.firstWhere((a) => a.isDefault);
                  getIt<ActiveLocationService>().setActiveAddress(active);
                } catch (_) {}
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Saved Address',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 16.h),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayAddresses.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final address = displayAddresses[index];
                      return SavedAddressCard(
                        address: address,
                        title: address.id == 'current_location'
                            ? 'Current Location'
                            : null,
                        onSetDefault: () {
                          setState(() {
                            _activeDefaultId = address.id;
                          });
                        },
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
