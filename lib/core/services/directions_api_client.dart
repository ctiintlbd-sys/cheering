import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/app_config.dart';

/// Google Directions API client over HTTP to fetch road routes.
class DirectionsApiClient {
  DirectionsApiClient({Dio? dio})
    : _ownsDio = dio == null,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ),
          );

  static const String _directionsUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  static const int _maxCacheEntries = 20;

  /// Shared LRU cache for fetched routes to avoid repeated API calls.
  /// Key: "originLat,originLng->destLat,destLng"
  static final LinkedHashMap<String, List<LatLng>> _cache =
      LinkedHashMap<String, List<LatLng>>();

  final Dio _dio;
  final bool _ownsDio;

  /// Fetches road route points between origin and destination.
  /// Returns empty list if route cannot be found or on network/API failure.
  Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) async {
    final originKey =
        '${origin.latitude.toStringAsFixed(5)},${origin.longitude.toStringAsFixed(5)}';
    final destKey =
        '${destination.latitude.toStringAsFixed(5)},${destination.longitude.toStringAsFixed(5)}';
    final waypointsKey = waypoints == null || waypoints.isEmpty
        ? ''
        : '|${waypoints.map((w) => '${w.latitude.toStringAsFixed(5)},${w.longitude.toStringAsFixed(5)}').join('|')}';
    final key = '$originKey->$destKey$waypointsKey';

    final cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached;
      return cached;
    }

    try {
      final queryParams = <String, dynamic>{
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'driving',
        'key': AppConfig.instance.googleMapsKey,
      };

      if (waypoints != null && waypoints.isNotEmpty) {
        queryParams['waypoints'] = waypoints
            .map((p) => '${p.latitude},${p.longitude}')
            .join('|');
      }

      final response = await _dio.get(
        _directionsUrl,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is! Map) return const [];

      final status = data['status'];
      if (status != 'OK') {
        debugPrint('[DirectionsApiClient] directions status: $status');
        return const [];
      }

      final routes = data['routes'] as List? ?? const [];
      if (routes.isEmpty) return const [];

      final overviewPolyline =
          routes[0]['overview_polyline']?['points'] as String?;
      if (overviewPolyline == null || overviewPolyline.isEmpty) return const [];

      final points = decodePolyline(overviewPolyline);
      if (points.isNotEmpty) {
        _cacheResults(key, points);
      }
      return points;
    } catch (e) {
      debugPrint('[DirectionsApiClient] directions error: $e');
      return const [];
    }
  }

  /// Decode Google encoded polyline string into `List<LatLng>` using pure Dart bitwise operations.
  static List<LatLng> decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    final len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _cacheResults(String key, List<LatLng> results) {
    if (_cache.length >= _maxCacheEntries) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = results;
  }

  void close() {
    if (_ownsDio) _dio.close(force: true);
  }
}
