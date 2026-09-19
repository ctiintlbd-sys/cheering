import 'dart:async';

import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/services/current_location_service.dart';
import 'package:cheering/core/services/map_location_service.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../domain/entities/map_location_entities.dart';
import '../bloc/map_picker_cubit.dart';
import '../bloc/map_picker_state.dart';
import 'widgets/manual_address_location_sheet.dart';
import 'widgets/manual_address_map_pin.dart';
import 'widgets/manual_address_map_search_bar.dart';
import 'widgets/manual_address_map_search_results_sheet.dart';

class ManualAddressMapScreen extends StatefulWidget {
  const ManualAddressMapScreen({super.key, this.autoFocusSearch = false});

  final bool autoFocusSearch;

  @override
  State<ManualAddressMapScreen> createState() => _ManualAddressMapScreenState();
}

class _ManualAddressMapScreenState extends State<ManualAddressMapScreen> {
  final _mapService = getIt<MapLocationService>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  GoogleMapController? _mapController;
  LatLng _cameraPosition = MapLocationDefaults.dhaka;
  bool _suppressNextIdleGeocode = false;
  int _suppressSearchEvents = 0;

  MapPickerCubit get _picker => context.read<MapPickerCubit>();

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

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _searchController.dispose();
    _mapService.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Deliberately outside every builder: rebuilding the platform map
          // view on each pin move or keystroke is what made panning stutter.
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: MapLocationDefaults.dhaka,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            onTap: _onMapTap,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),
          BlocSelector<MapPickerCubit, MapPickerState, bool>(
            selector: (state) => state.isPinMoving,
            builder: (context, isPinMoving) =>
                ManualAddressMapPin(isMoving: isPinMoving),
          ),
          BlocBuilder<MapPickerCubit, MapPickerState>(
            buildWhen: (previous, current) =>
                previous.showSearchResults != current.showSearchResults ||
                previous.isSearchLoading != current.isSearchLoading ||
                previous.searchResults != current.searchResults,
            builder: (context, state) => ManualAddressMapSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onClear: _clearSearch,
              searchResults: _buildSearchResults(state),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.5,
        backgroundColor: context.colors.background,
        onPressed: _goToCurrentLocation,
        child: Assets.icons.currentLocation.svg(),
      ),
      bottomNavigationBar:
          BlocSelector<MapPickerCubit, MapPickerState, (String, String)>(
            selector: (state) => (state.address, state.area),
            builder: (context, resolved) => ManualAddressLocationSheet(
              address: resolved.$1,
              area: resolved.$2,
              onConfirm: _confirm,
            ),
          ),
    );
  }

  Widget? _buildSearchResults(MapPickerState state) {
    if (!state.showSearchResults) return null;
    if (_searchController.text.trim().length < 3) return null;

    return ManualAddressMapSearchResultsSheet(
      loading: state.isSearchLoading,
      results: state.searchResults,
      onResultTap: (result) => unawaited(_onSearchResultSelected(result)),
    );
  }

  // ─── Search ─────────────────────────────────────────────────

  void _clearSearch() {
    _mapService.cancelSearchDebounce();
    _searchController.clear();
    _picker.clearSearchResults();
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus &&
        _searchController.text.trim().length >= 3) {
      _picker.setSearchResultsVisible(true);
    }
  }

  void _dismissSearchResults() {
    _searchFocusNode.unfocus();
    _picker.setSearchResultsVisible(false);
  }

  void _onSearchChanged() {
    if (_suppressSearchEvents > 0) {
      _suppressSearchEvents--;
      return;
    }

    if (_searchController.text.trim().length < 3) {
      _mapService.cancelSearchDebounce();
      _picker.clearSearchResults();
      return;
    }

    _picker.showSearchLoading();
    _mapService.scheduleAddressSearch(
      query: _searchController.text,
      onResults: (results) {
        if (!mounted) return;
        _picker.setSearchResults(
          results,
          show: _searchController.text.trim().length >= 3,
        );
      },
    );
  }

  Future<void> _onSearchResultSelected(MapSearchResult result) async {
    _picker.clearSearchResults();
    _searchFocusNode.unfocus();

    _suppressNextIdleGeocode = true;
    final position = await _mapService.resolveSearchResultPosition(result);
    if (position == null || !mounted) return;

    _mapService.markPositionResolved(position);
    await _moveCamera(position);
    if (!mounted) return;

    _applySnapshot(
      MapAddressSnapshot(
        address: result.formattedAddress,
        area: result.area,
        position: position,
      ),
    );
  }

  // ─── Snapshot apply ─────────────────────────────────────────

  void _applySnapshot(MapAddressSnapshot snapshot) {
    _cameraPosition = snapshot.position;
    if (!_searchFocusNode.hasFocus &&
        _searchController.text != snapshot.address) {
      _suppressSearchEvents++;
      _searchController.text = snapshot.address;
    }
    _picker.setAddress(snapshot.address, snapshot.area);
  }

  // ─── GPS ────────────────────────────────────────────────────

  Future<void> _goToCurrentLocation() async {
    final result = await getIt<CurrentLocationService>().fetchCurrentLocation();
    if (!mounted) return;

    final target = result.latLng;
    if (target == null) {
      ToastMessageHelper.show(result.failure!.message);
      // Don't leave the sheet stuck on "Locating..." forever.
      if (_picker.state.address == MapLocationDefaults.locatingLabel) {
        _picker.setUnknownAddress();
      }
      return;
    }

    _cameraPosition = target;
    _suppressNextIdleGeocode = true;
    await _moveCamera(target);

    final outcome = await _mapService.reverseGeocode(
      target,
      ignoreDistanceCheck: true,
    );
    if (!mounted) return;

    switch (outcome) {
      case ReverseGeocodeResolved(:final snapshot):
        _applySnapshot(snapshot);
      case ReverseGeocodeFailed():
        _picker.setUnknownAddress();
      case ReverseGeocodeSkipped():
        break;
    }
  }

  // ─── Camera ─────────────────────────────────────────────────

  Future<void> _moveCamera(
    LatLng target, {
    double zoom = MapLocationDefaults.pickerZoom,
  }) {
    return _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(target, zoom),
        ) ??
        Future.value();
  }

  void _onCameraMove(CameraPosition camera) {
    _cameraPosition = camera.target;
    _picker.setPinMoving(true);
  }

  void _onCameraIdle() {
    _picker.setPinMoving(false);

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
        if (mounted) _picker.setUnknownAddress();
      },
    );
  }

  void _onMapTap(LatLng latLng) {
    _dismissSearchResults();
    _cameraPosition = latLng;
    _moveCamera(latLng);
  }

  // ─── Confirm ────────────────────────────────────────────────

  void _confirm() {
    final state = _picker.state;
    if (!state.isConfirmable) {
      ToastMessageHelper.show('Please select your location on the map');
      return;
    }
    context.pop(<String, dynamic>{
      'address': state.address.trim(),
      'area': state.area,
      'latitude': _cameraPosition.latitude,
      'longitude': _cameraPosition.longitude,
    });
  }
}
