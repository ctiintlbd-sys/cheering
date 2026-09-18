import 'dart:async';
import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/services/current_location_service.dart';
import 'package:cheering/core/services/map_location_service.dart';
import '../../domain/entities/map_location_entities.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import 'widgets/manual_address_location_sheet.dart';
import 'widgets/manual_address_map_pin.dart';
import 'widgets/manual_address_map_search_bar.dart';
import 'widgets/manual_address_map_search_results_sheet.dart';

class ManualAddressMapScreen extends StatefulWidget {
  final bool autoFocusSearch;
  const ManualAddressMapScreen({super.key, this.autoFocusSearch = false});

  @override
  State<ManualAddressMapScreen> createState() => _ManualAddressMapScreenState();
}

class _ManualAddressMapScreenState extends State<ManualAddressMapScreen> {
  final _mapService = MapLocationService();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  GoogleMapController? _mapController;
  LatLng _cameraPosition = MapLocationDefaults.dhaka;
  bool _suppressNextIdleGeocode = false;
  int _suppressSearchEvents = 0;

  // ─── Lifecycle ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToCurrentLocation();
      if (widget.autoFocusSearch) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: MapLocationDefaults.dhaka,
                  zoom: 15,
                ),
                onMapCreated: (c) => _mapController = c,
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                onTap: _onMapTap,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
              ),
              ManualAddressMapPin(isMoving: state.isPinMoving),
              ManualAddressMapSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onClear: () {
                  _mapService.cancelSearchDebounce();
                  _searchController.clear();
                  context.read<AddressBloc>().add(const ClearMapSearchResultsEvent());
                },
                searchResults: state.showMapSearchResults &&
                        _searchController.text.trim().length >= 3
                    ? ManualAddressMapSearchResultsSheet(
                        loading: state.isMapSearchLoading,
                        results: state.mapSearchResults,
                        onResultTap: (result) {
                          unawaited(_onSearchResultSelected(result));
                        },
                      )
                    : null,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0.5,
            backgroundColor: context.colors.background,
            onPressed: _goToCurrentLocation,
            child: Assets.icons.currentLocation.svg(),
          ),
          bottomNavigationBar: ManualAddressLocationSheet(
            address: state.mapAddress,
            area: state.mapArea,
            onConfirm: () => _confirm(state),
          ),
        );
      },
    );
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus &&
        _searchController.text.trim().length >= 3) {
      context.read<AddressBloc>().add(const ShowMapSearchResultsEvent(true));
    }
  }

  void _dismissSearchResults() {
    _searchFocusNode.unfocus();
    context.read<AddressBloc>().add(const ShowMapSearchResultsEvent(false));
  }

  void _onSearchChanged() {
    if (_suppressSearchEvents > 0) {
      _suppressSearchEvents--;
      return;
    }
    final query = _searchController.text.trim();
    if (query.length < 3) {
      _mapService.cancelSearchDebounce();
      context.read<AddressBloc>().add(const ClearMapSearchResultsEvent());
      return;
    }

    context.read<AddressBloc>().add(const ShowMapSearchLoadingEvent());

    _mapService.scheduleAddressSearch(
      query: _searchController.text,
      onResults: (results) {
        if (!mounted) return;
        final queryStillValid = _searchController.text.trim().length >= 3;
        context.read<AddressBloc>().add(UpdateMapSearchResultsEvent(results, queryStillValid));
      },
    );
  }

  Future<void> _onSearchResultSelected(MapSearchResult result) async {
    context.read<AddressBloc>().add(const ClearMapSearchResultsEvent());
    _searchFocusNode.unfocus();
    await _applySearchResult(result);
  }

  Future<void> _applySearchResult(MapSearchResult result) async {
    _suppressNextIdleGeocode = true;
    await _mapService.applySearchResult(
      result: result,
      mapController: _mapController,
      onApplied: _applySnapshot,
    );
  }

  // ─── Snapshot apply ─────────────────────────────────────────

  void _applySnapshot(MapAddressSnapshot snapshot) {
    _cameraPosition = snapshot.position;
    if (!_searchFocusNode.hasFocus && _searchController.text != snapshot.address) {
      _suppressSearchEvents++;
      _searchController.text = snapshot.address;
    }
    context.read<AddressBloc>().add(UpdateMapAddressEvent(snapshot.address, snapshot.area));
  }

  // ─── GPS ────────────────────────────────────────────────────

  Future<void> _goToCurrentLocation() async {
    try {
      final result =
          await getIt<CurrentLocationService>().fetchCurrentLocation();

      if (!mounted) return;

      if (!result.isSuccess) {
        ToastMessageHelper.show(result.failure!.message);
        // If we never got a real address, clear the locating label
        if (context.read<AddressBloc>().state.mapAddress == MapLocationDefaults.locatingLabel) {
          context.read<AddressBloc>().add(const SetMapUnknownAddressEvent());
        }
        return;
      }

      final target = result.latLng!;
      _cameraPosition = target;
      _suppressNextIdleGeocode = true;

      await _mapService.moveCamera(controller: _mapController, target: target);

      final snapshot = await _mapService.reverseGeocode(
        target,
        ignoreDistanceCheck: true,
      );

      if (!mounted) return;
      if (snapshot != null) {
        _applySnapshot(snapshot);
      } else {
        context.read<AddressBloc>().add(const SetMapUnknownAddressEvent());
      }
    } finally {}
  }

  // ─── Camera callbacks ────────────────────────────────────────

  void _onCameraMove(CameraPosition camera) {
    _cameraPosition = camera.target;
    context.read<AddressBloc>().add(const UpdateMapPinEvent(true));
  }

  void _onCameraIdle() {
    context.read<AddressBloc>().add(const UpdateMapPinEvent(false));

    if (_suppressNextIdleGeocode) {
      _suppressNextIdleGeocode = false;
      return;
    }

    _mapService.scheduleReverseGeocode(
      position: _cameraPosition,
      onResolved: (snapshot) {
        if (mounted) _applySnapshot(snapshot);
      },
      onUnknown: () {
        if (mounted) context.read<AddressBloc>().add(const SetMapUnknownAddressEvent());
      },
    );
  }

  void _onMapTap(LatLng latLng) {
    _dismissSearchResults();
    _cameraPosition = latLng;
    _mapService.moveCamera(controller: _mapController, target: latLng);
  }

  // ─── Confirm ────────────────────────────────────────────────

  void _confirm(AddressState state) {
    if (!MapLocationDefaults.isConfirmableAddress(state.mapAddress)) {
      ToastMessageHelper.show('Please select your location on the map');
      return;
    }
    context.pop(<String, dynamic>{
      'address': state.mapAddress.trim(),
      'area': state.mapArea,
      'latitude': _cameraPosition.latitude,
      'longitude': _cameraPosition.longitude,
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _searchController.dispose();
    _mapService.cancelPendingWork();
    _mapController?.dispose();
    super.dispose();
  }
}
