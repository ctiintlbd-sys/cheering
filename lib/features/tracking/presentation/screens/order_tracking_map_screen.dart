import 'dart:math' as math;
import 'package:cheering/core/helpers/map_marker_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/domain/entities/map_location_entities.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_map_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  const OrderTrackingMapScreen({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  State<OrderTrackingMapScreen> createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  OrderTrackingEntity get _tracking => widget.tracking;

  @override
  void initState() {
    super.initState();
    _buildMapOverlay();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  LatLng? get _restaurantLatLng => _validLatLng(
    _tracking.restaurantLatitude,
    _tracking.restaurantLongitude,
  );

  LatLng? get _riderLatLng {
    final location = _tracking.riderLocation;
    if (location == null) return null;
    return _validLatLng(location.latitude, location.longitude);
  }

  LatLng? get _deliveryLatLng => _validLatLng(
    _tracking.deliveryLatitude,
    _tracking.deliveryLongitude,
  );

  LatLng? _validLatLng(double lat, double lng) {
    if (lat == 0 && lng == 0) return null;
    return LatLng(lat, lng);
  }

  List<LatLng> get _routePoints {
    if (_riderLatLng != null && _deliveryLatLng != null) {
      return [_riderLatLng!, _deliveryLatLng!];
    }
    return [
      ?_restaurantLatLng,
      ?_riderLatLng,
      ?_deliveryLatLng,
    ];
  }

  LatLng get _initialTarget =>
      _riderLatLng ??
      _deliveryLatLng ??
      _restaurantLatLng ??
      MapLocationDefaults.dhaka;

  Future<void> _buildMapOverlay() async {
    final customerIcon = await MapMarkerHelper.createLocationMarker();
    final restaurantIcon = _restaurantLatLng == null
        ? null
        : await MapMarkerHelper.createCircularBadgeMarker(
            size: 64,
            circleColor: const Color(0xFFEA580C),
            assetPath: Assets.images.store.path,
          );
    if (!mounted) return;
    _applyOverlay(customerIcon: customerIcon, restaurantIcon: restaurantIcon);

    if (_riderLatLng == null) return;

    final riderIcon = await MapMarkerHelper.createProfileMarker(
      photoUrl: _tracking.rider?.photoUrl,
    );
    if (!mounted) return;
    _applyOverlay(
      customerIcon: customerIcon,
      restaurantIcon: restaurantIcon,
      riderIcon: riderIcon,
    );
  }

  void _applyOverlay({
    required BitmapDescriptor customerIcon,
    BitmapDescriptor? restaurantIcon,
    BitmapDescriptor? riderIcon,
  }) {
    final points = _routePoints;
    setState(() {
      _markers = {
        if (_deliveryLatLng != null)
          Marker(
            markerId: const MarkerId('customer'),
            position: _deliveryLatLng!,
            icon: customerIcon,
            zIndexInt: 2,
            infoWindow: InfoWindow(title: _tracking.deliveryAddressText),
          ),
        if (_riderLatLng != null && riderIcon != null)
          Marker(
            markerId: const MarkerId('rider'),
            position: _riderLatLng!,
            icon: riderIcon,
            zIndexInt: 3,
            infoWindow: InfoWindow(title: _tracking.rider?.name ?? 'Rider'),
          ),
        if (_restaurantLatLng != null && restaurantIcon != null)
          Marker(
            markerId: const MarkerId('restaurant'),
            position: _restaurantLatLng!,
            icon: restaurantIcon,
            infoWindow: InfoWindow(title: _tracking.restaurantName),
          ),
      };
      _polylines = points.length < 2
          ? {}
          : {
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF2563EB),
                width: 4,
                points: points,
                patterns: [PatternItem.dash(18), PatternItem.gap(12)],
              ),
            };
    });
    _fitRoute();
  }

  void _fitRoute() {
    final points = _routePoints;
    if (points.isEmpty || _mapController == null) return;

    if (points.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(points.first, 15),
      );
      return;
    }

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points.skip(1)) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    if (minLat == maxLat) {
      minLat -= 0.01;
      maxLat += 0.01;
    }
    if (minLng == maxLng) {
      minLng -= 0.01;
      maxLng += 0.01;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        72,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      bottomSheet: TrackingMapSheet(tracking: _tracking),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialTarget,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _fitRoute();
              },
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              padding: EdgeInsets.only(bottom: 360.w),
            ),
          ),
        ],
      ),
    );
  }
}
