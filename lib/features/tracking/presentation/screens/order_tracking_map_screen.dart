import 'dart:math';

import 'package:cheering/core/helpers/map_marker_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/order_tracking_entity.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  const OrderTrackingMapScreen({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  State<OrderTrackingMapScreen> createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  OrderTrackingEntity get _tracking => widget.tracking;

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _buildMarkers() async {
    final restaurant = await MapMarkerHelper.createLocationMarker();
    final delivery = await MapMarkerHelper.createCircularBadgeMarker(
      circleColor: const Color(0xFF2563EB),
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(
          _tracking.restaurantLatitude,
          _tracking.restaurantLongitude,
        ),
        icon: restaurant,
        infoWindow: InfoWindow(title: _tracking.restaurantName),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: LatLng(
          _tracking.deliveryLatitude,
          _tracking.deliveryLongitude,
        ),
        icon: delivery,
        infoWindow: InfoWindow(title: _tracking.deliveryAddressText),
      ),
    };

    final riderLocation = _tracking.riderLocation;
    if (_tracking.liveTrackingAvailable && riderLocation != null) {
      final rider = await MapMarkerHelper.createCircularBadgeMarker(
        circleColor: const Color(0xFFE2146E),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('rider'),
          position: LatLng(riderLocation.latitude, riderLocation.longitude),
          icon: rider,
          infoWindow: InfoWindow(
            title: _tracking.rider?.name.isNotEmpty == true
                ? _tracking.rider!.name
                : 'Rider',
          ),
        ),
      );
    }

    if (!mounted) return;
    setState(() => _markers = markers);
    _fitBounds();
  }

  void _fitBounds() {
    final controller = _controller;
    if (controller == null) return;

    final points = <LatLng>[
      LatLng(_tracking.restaurantLatitude, _tracking.restaurantLongitude),
      LatLng(_tracking.deliveryLatitude, _tracking.deliveryLongitude),
      if (_tracking.liveTrackingAvailable && _tracking.riderLocation != null)
        LatLng(
          _tracking.riderLocation!.latitude,
          _tracking.riderLocation!.longitude,
        ),
    ];

    var south = points.first.latitude;
    var west = points.first.longitude;
    var north = points.first.latitude;
    var east = points.first.longitude;

    for (final point in points.skip(1)) {
      south = min(south, point.latitude);
      west = min(west, point.longitude);
      north = max(north, point.latitude);
      east = max(east, point.longitude);
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(south, west),
          northeast: LatLng(north, east),
        ),
        72,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _tracking.restaurantLatitude,
                _tracking.restaurantLongitude,
              ),
              zoom: 13,
            ),
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onMapCreated: (controller) {
              _controller = controller;
              _fitBounds();
            },
          ),
        ],
      ),
    );
  }
}
