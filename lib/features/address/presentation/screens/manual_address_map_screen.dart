import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/utils/assets/assets.gen.dart';

class ManualAddressMapScreen extends StatefulWidget {
  const ManualAddressMapScreen({super.key});

  @override
  State<ManualAddressMapScreen> createState() => _ManualAddressMapScreenState();
}

class _ManualAddressMapScreenState extends State<ManualAddressMapScreen> {
  static const LatLng _defaultPosition = LatLng(23.7937, 90.4066);

  GoogleMapController? _mapController;
  LatLng _currentPosition = _defaultPosition;
  bool _isMoving = false;
  
  String _currentAddress = "Locating...";
  String _currentArea = "";
  
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    _currentPosition = position.target;
    if (!_isMoving) {
      setState(() {
        _isMoving = true;
      });
    }
  }

  void _onCameraIdle() {
    if (mounted) {
      setState(() {
        _isMoving = false;
      });
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _reverseGeocode(_currentPosition);
    });
  }

  Future<void> _reverseGeocode(LatLng position) async {
    try {
      final geocodingInstance = geo.Geocoding();
      final placemarks = await geocodingInstance.placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;
        setState(() {
          _currentAddress = [place.street, place.subLocality, place.locality]
              .whereType<String>()
              .where((e) => e.trim().isNotEmpty)
              .join(', ');
              
          if (_currentAddress.isEmpty) _currentAddress = place.name ?? "Unknown Location";
          
          _currentArea = [place.administrativeArea, place.postalCode]
              .whereType<String>()
              .where((e) => e.trim().isNotEmpty)
              .join(', ');
          
          _searchController.text = _currentAddress;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentAddress = "Unknown Location";
          _currentArea = "";
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    final latLng = LatLng(position.latitude, position.longitude);
    
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _defaultPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.h),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(0, _isMoving ? -15 : 0, 0),
                child: Assets.images.mapLocation.image(height: 50.h),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: CustomContainer(
                    width: 44.r,
                    height: 44.r,
                    color: Colors.white,
                    radiusAll: 22.r,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                    child: Icon(Icons.arrow_back, color: context.colors.textPrimary),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomContainer(
                    height: 44.h,
                    color: Colors.white,
                    radiusAll: 22.r,
                    paddingHorizontal: 16.w,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                    child: Row(
                      children: [
                        Icon(Icons.search, color: context.colors.textSecondary, size: 20.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search location...',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: context.colors.textTertiary,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _searchController,
                          builder: (context, value, _) {
                            if (value.text.isEmpty) return const SizedBox.shrink();
                            return GestureDetector(
                              onTap: () => _searchController.clear(),
                              child: CustomText(
                                text: 'Clear',
                                color: context.colors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 210.h,
            right: 16.w,
            child: GestureDetector(
              onTap: _getCurrentLocation,
              child: CustomContainer(
                width: 44.r,
                height: 44.r,
                color: Colors.white,
                radiusAll: 12.r,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                  ),
                ],
                child: Icon(Icons.my_location, color: context.colors.primary),
              ),
            ),
          ),
          Positioned(
            bottom: 24.h,
            left: 16.w,
            right: 16.w,
            child: CustomContainer(
              color: Colors.white,
              radiusAll: 24.r,
              paddingAll: 20.r,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomContainer(
                        width: 40.r,
                        height: 40.r,
                        color: context.colors.bgTertiary,
                        radiusAll: 10.r,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: _currentAddress.isEmpty ? 'Loading...' : _currentAddress,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                              maxLines: 1,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: _currentArea,
                              fontSize: 14.sp,
                              color: context.colors.textSecondary,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    onPressed: () {
                      // Confirm Location logic
                    },
                    text: 'Confirm Location',
                    width: double.infinity,
                    height: 50.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
