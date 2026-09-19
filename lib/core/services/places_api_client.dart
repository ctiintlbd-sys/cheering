import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../features/address/domain/entities/map_location_entities.dart';
import '../config/app_config.dart';

/// Google Places Autocomplete + Details over HTTP.
class PlacesApiClient {
  PlacesApiClient({Dio? dio, this.countryFilter = _defaultCountryFilter})
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

  static const String _defaultCountryFilter = 'bd';
  static const String _autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String _detailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  static const int _maxResults = 5;
  static const int _maxCacheEntries = 30;

  /// Shared across instances for the app session, LRU-bounded so a long typing
  /// session can't grow it without limit.
  static final LinkedHashMap<String, List<MapSearchResult>> _cache =
      LinkedHashMap<String, List<MapSearchResult>>();

  final Dio _dio;
  final bool _ownsDio;

  /// Restricts predictions to one country, e.g. `bd`.
  final String countryFilter;

  /// Groups an autocomplete run with its follow-up details call so Google bills
  /// them as one session. Cleared once the details call consumes it.
  String? _sessionToken;

  Future<List<MapSearchResult>> autocomplete(String query) async {
    final key = query.toLowerCase().trim();

    final cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached;
      return cached;
    }

    try {
      _sessionToken ??= DateTime.now().millisecondsSinceEpoch.toString();

      final response = await _dio.get(
        _autocompleteUrl,
        queryParameters: {
          'input': query,
          'key': AppConfig.instance.googleMapsKey,
          'sessiontoken': _sessionToken,
          'components': 'country:$countryFilter',
        },
      );

      final data = response.data;
      if (data is! Map) return const [];

      final status = data['status'];
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        debugPrint('[PlacesApiClient] autocomplete status: $status');
        return const [];
      }

      final predictions = data['predictions'] as List? ?? const [];
      final results = <MapSearchResult>[];

      for (final prediction in predictions.take(_maxResults)) {
        final placeId = prediction['place_id'] as String?;
        if (placeId == null) continue;

        final formatting = prediction['structured_formatting'];
        results.add(
          MapSearchResult(
            formattedAddress: formatting?['main_text'] as String? ?? '',
            area: formatting?['secondary_text'] as String? ?? '',
            placeId: placeId,
          ),
        );
      }

      if (results.isNotEmpty) _cacheResults(key, results);
      return results;
    } catch (e) {
      debugPrint('[PlacesApiClient] autocomplete error: $e');
      return const [];
    }
  }

  Future<LatLng?> placeLocation(String placeId) async {
    try {
      final response = await _dio.get(
        _detailsUrl,
        queryParameters: {
          'place_id': placeId,
          'key': AppConfig.instance.googleMapsKey,
          'fields': 'geometry',
          'sessiontoken': _sessionToken,
        },
      );

      _sessionToken = null;

      final data = response.data;
      if (data is! Map || data['status'] != 'OK') return null;

      final location = data['result']?['geometry']?['location'];
      final lat = (location?['lat'] as num?)?.toDouble();
      final lng = (location?['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;

      return LatLng(lat, lng);
    } catch (e) {
      debugPrint('[PlacesApiClient] placeLocation error: $e');
      return null;
    }
  }

  void _cacheResults(String key, List<MapSearchResult> results) {
    if (_cache.length >= _maxCacheEntries) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = results;
  }

  void close() {
    if (_ownsDio) _dio.close(force: true);
  }
}
