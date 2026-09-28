import 'dart:math' as math;
import 'package:cheering/core/common_widgets/common_widgets.dart';
import 'package:cheering/core/helpers/map_marker_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/address/domain/entities/map_location_entities.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_map_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

  List<LatLng> get _routePoints => [
    ?_restaurantLatLng,
    ?_riderLatLng,
    ?_deliveryLatLng,
  ];

  LatLng get _initialTarget =>
      _riderLatLng ??
      _deliveryLatLng ??
      _restaurantLatLng ??
      MapLocationDefaults.dhaka;

  Future<void> _buildMapOverlay() async {
    final destinationIcon = await MapMarkerHelper.createLocationMarker();
    if (!mounted) return;

    final markers = <Marker>{
      if (_restaurantLatLng != null)
        Marker(
          markerId: const MarkerId('restaurant'),
          position: _restaurantLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(title: _tracking.restaurantName),
        ),
      if (_riderLatLng != null)
        Marker(
          markerId: const MarkerId('rider'),
          position: _riderLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(title: _tracking.rider?.name ?? 'Rider'),
        ),
      if (_deliveryLatLng != null)
        Marker(
          markerId: const MarkerId('delivery'),
          position: _deliveryLatLng!,
          icon: destinationIcon,
          infoWindow: InfoWindow(title: _tracking.deliveryAddressText),
        ),
    };

    final points = _routePoints;
    setState(() {
      _markers = markers;
      _polylines = points.length < 2
          ? {}
          : {
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF2563EB),
                width: 4,
                points: points,
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

          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.58,
              ),
              child: SingleChildScrollView(
                child: TrackingMapSheet(tracking: _tracking),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
