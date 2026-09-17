import 'dart:async';

import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/services/current_location_service.dart';
import 'package:cheering/core/services/map_location_service.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_theme_colors.dart';
import 'widgets/manual_address_location_sheet.dart';
import 'widgets/manual_address_map_pin.dart';
import 'widgets/manual_address_map_search_bar.dart';
import 'widgets/manual_address_map_search_results_sheet.dart';

class ManualAddressMapScreen extends StatefulWidget {
  const ManualAddressMapScreen({super.key});

  @override
  State<ManualAddressMapScreen> createState() => _ManualAddressMapScreenState();
}

class _ManualAddressMapScreenState extends State<ManualAddressMapScreen> {
  // Owned by this screen — NOT from DI, so safe to dispose
  final _mapService = MapLocationService();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  GoogleMapController? _mapController;
  LatLng _cameraPosition = MapLocationDefaults.dhaka;

  bool _pinMoving = false;
  bool _loadingGps = false;

  // True after a programmatic camera move so onCameraIdle skips geocode
  bool _suppressNextIdleGeocode = false;

  // Suppresses search listener during programmatic text updates
  int _suppressSearchEvents = 0;

  String _address = MapLocationDefaults.locatingLabel;
  String _area = '';

  List<MapSearchResult> _searchResults = [];
  bool _searchLoading = false;
  bool _showSearchResults = false;

  // ─── Lifecycle ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToCurrentLocation());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _searchController.dispose();
    _mapService.cancelPendingWork(); // cancel timers/requests only, no DI teardown
    _mapController?.dispose();
    super.dispose();
  }

  // ─── Search ─────────────────────────────────────────────────

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus &&
        _searchController.text.trim().length >= 3) {
      setState(() => _showSearchResults = true);
    }
  }

  void _dismissSearchResults() {
    _searchFocusNode.unfocus();
    setState(() => _showSearchResults = false);
  }

  void _clearSearchResults() {
    setState(() {
      _searchResults = [];
      _searchLoading = false;
      _showSearchResults = false;
    });
  }

  void _onSearchChanged() {
    if (_suppressSearchEvents > 0) {
      _suppressSearchEvents--;
      return;
    }
    final query = _searchController.text.trim();
    if (query.length < 3) {
      _mapService.cancelSearchDebounce();
      _clearSearchResults();
      return;
    }

    setState(() {
      _searchLoading = true;
      _showSearchResults = true;
    });

    _mapService.scheduleAddressSearch(
      query: _searchController.text,
      onResults: (results) {
        if (!mounted) return;
        setState(() {
          _searchLoading = false;
          _searchResults = results;
          if (_searchController.text.trim().length >= 3) {
            _showSearchResults = true;
          }
        });
      },
    );
  }

  Future<void> _onSearchResultSelected(MapSearchResult result) async {
    _clearSearchResults();
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
    if (_searchController.text != snapshot.address) {
      _suppressSearchEvents++;
      _searchController.text = snapshot.address;
    }
    setState(() {
      _address = snapshot.address;
      _area = snapshot.area;
    });
  }

  void _setUnknownAddress() {
    setState(() {
      _address = MapLocationDefaults.unknownLabel;
      _area = '';
    });
  }

  // ─── GPS ────────────────────────────────────────────────────

  Future<void> _goToCurrentLocation() async {
    if (_loadingGps) return;
    setState(() => _loadingGps = true);

    try {
      final result =
      await getIt<CurrentLocationService>().fetchCurrentLocation();

      if (!mounted) return;

      if (!result.isSuccess) {
        ToastMessageHelper.show(result.failure!.message);
        // If we never got a real address, clear the locating label
        if (_address == MapLocationDefaults.locatingLabel) {
          _setUnknownAddress();
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
        _setUnknownAddress();
      }
    } finally {
      if (mounted) setState(() => _loadingGps = false);
    }
  }

  // ─── Camera callbacks ────────────────────────────────────────

  void _onCameraMove(CameraPosition camera) {
    _cameraPosition = camera.target;
    if (!_pinMoving) setState(() => _pinMoving = true);
  }

  void _onCameraIdle() {
    setState(() => _pinMoving = false);

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
        if (mounted) _setUnknownAddress();
      },
    );
  }

  void _onMapTap(LatLng latLng) {
    _dismissSearchResults();
    _cameraPosition = latLng;
    _mapService.moveCamera(controller: _mapController, target: latLng);
  }

  // ─── Confirm ────────────────────────────────────────────────

  void _confirm() {
    if (!MapLocationDefaults.isConfirmableAddress(_address)) {
      ToastMessageHelper.show('Please select your location on the map');
      return;
    }
    context.pop(<String, dynamic>{
      'address': _address.trim(),
      'area': _area,
      'latitude': _cameraPosition.latitude,
      'longitude': _cameraPosition.longitude,
    });
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
            ManualAddressMapPin(isMoving: _pinMoving),
            ManualAddressMapSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onClear: () {
                _mapService.cancelSearchDebounce();
                _searchController.clear();
                _clearSearchResults();
              },
              searchResults: _showSearchResults &&
                      _searchController.text.trim().length >= 3
                  ? ManualAddressMapSearchResultsSheet(
                      loading: _searchLoading,
                      results: _searchResults,
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
          onPressed: _loadingGps ? null : _goToCurrentLocation,
          child: _loadingGps
              ? SizedBox(
            width: 22.r,
            height: 22.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation(context.colors.primary),
            ),
          )
              : Assets.icons.currentLocation.svg(),
        ),
        bottomNavigationBar: ManualAddressLocationSheet(
          address: _address,
          area: _area,
          onConfirm: _confirm,
        ),
    );
  }
}