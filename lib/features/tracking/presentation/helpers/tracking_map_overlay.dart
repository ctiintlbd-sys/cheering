import 'dart:math' as math;

import 'package:cheering/core/helpers/map_marker_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/features/address/domain/entities/map_location_entities.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingMapOverlay {
  const TrackingMapOverlay({
    this.markers = const {},
    this.polylines = const {},
  });

  final Set<Marker> markers;
  final Set<Polyline> polylines;

  static Future<TrackingMapOverlay> build({
    required OrderTrackingEntity tracking,
  }) async {
    final restaurant = TrackingMapGeometry.restaurantOf(tracking);
    final rider = TrackingMapGeometry.riderOf(tracking);
    final delivery = TrackingMapGeometry.deliveryOf(tracking);

    final icons = await Future.wait<BitmapDescriptor?>([
      MapMarkerHelper.createLocationMarker(),
      if (restaurant == null)
        Future<BitmapDescriptor?>.value(null)
      else
        MapMarkerHelper.createCircularBadgeMarker(
          size: 64,
          assetPath: Assets.images.store.path,
        ),
      if (rider == null)
        Future<BitmapDescriptor?>.value(null)
      else
        MapMarkerHelper.createProfileMarker(
          photoUrl: tracking.rider?.photoUrl,
        ),
    ]);

    final customerIcon = icons[0]!;
    final restaurantIcon = icons[1];
    final riderIcon = icons[2];
    final points = TrackingMapGeometry.routePointsOf(tracking);

    return TrackingMapOverlay(
      markers: {
        if (delivery != null)
          Marker(
            markerId: const MarkerId('customer'),
            position: delivery,
            icon: customerIcon,
            zIndexInt: 2,
            infoWindow: InfoWindow(title: tracking.deliveryAddressText),
          ),
        if (rider != null && riderIcon != null)
          Marker(
            markerId: const MarkerId('rider'),
            position: rider,
            icon: riderIcon,
            zIndexInt: 3,
            infoWindow: InfoWindow(title: tracking.rider?.name ?? 'Rider'),
          ),
        if (restaurant != null && restaurantIcon != null)
          Marker(
            markerId: const MarkerId('restaurant'),
            position: restaurant,
            icon: restaurantIcon,
            infoWindow: InfoWindow(title: tracking.restaurantName),
          ),
      },
      polylines: points.length < 2
          ? const {}
          : {
              Polyline(
                polylineId: const PolylineId('route'),
                width: 4,
                points: points,
                patterns: [PatternItem.dash(18), PatternItem.gap(12)],
              ),
            },
    );
  }
}

abstract final class TrackingMapGeometry {
  static const initialZoom = 14.0;
  static const singlePointZoom = 15.0;
  static const boundsPadding = 72.0;

  static LatLng? restaurantOf(OrderTrackingEntity tracking) =>
      _validLatLng(tracking.restaurantLatitude, tracking.restaurantLongitude);

  static LatLng? riderOf(OrderTrackingEntity tracking) {
    final location = tracking.riderLocation;
    if (location == null) return null;
    return _validLatLng(location.latitude, location.longitude);
  }

  static LatLng? deliveryOf(OrderTrackingEntity tracking) =>
      _validLatLng(tracking.deliveryLatitude, tracking.deliveryLongitude);

  static List<LatLng> routePointsOf(OrderTrackingEntity tracking) {
    final rider = riderOf(tracking);
    final delivery = deliveryOf(tracking);
    if (rider != null && delivery != null) return [rider, delivery];

    return [
      ?restaurantOf(tracking),
      ?rider,
      ?delivery,
    ];
  }

  static LatLng initialTargetOf(OrderTrackingEntity tracking) =>
      riderOf(tracking) ??
      deliveryOf(tracking) ??
      restaurantOf(tracking) ??
      MapLocationDefaults.dhaka;

  static CameraUpdate? cameraUpdateOf(OrderTrackingEntity tracking) {
    final points = routePointsOf(tracking);
    if (points.isEmpty) return null;
    if (points.length == 1) {
      return CameraUpdate.newLatLngZoom(points.first, singlePointZoom);
    }
    return CameraUpdate.newLatLngBounds(_boundsOf(points), boundsPadding);
  }

  static LatLng? _validLatLng(double lat, double lng) {
    if (lat == 0 && lng == 0) return null;
    return LatLng(lat, lng);
  }

  static LatLngBounds _boundsOf(List<LatLng> points) {
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

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
