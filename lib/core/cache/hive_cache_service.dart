import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

import '../network/api_result.dart';
import 'cache_entry.dart';
import 'cache_service.dart';

class HiveCacheService implements CacheService {
  HiveCacheService._();

  static final HiveCacheService instance = HiveCacheService._();

  static const String _boxName = 'app_cache';
  static const int _typeId = 0;

  static Box<CacheEntry>? _cacheBox;

  static Future<void> init() async {
    if (_cacheBox?.isOpen ?? false) return;

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(_typeId)) {
      Hive.registerAdapter(CacheEntryAdapter());
    }

    _cacheBox = await Hive.openBox<CacheEntry>(_boxName);
  }

  Box<CacheEntry> get _box {
    final box = _cacheBox;

    if (box == null || !box.isOpen) {
      throw StateError(
        'HiveCacheService is not initialized. '
        'Call HiveCacheService.init() first.',
      );
    }

    return box;
  }

  Uint8List _encode<T>(T data, Map<String, dynamic> Function(T data) toJson) {
    final json = jsonEncode(toJson(data));

    return Uint8List.fromList(utf8.encode(json));
  }

  Map<String, dynamic>? _decode(Uint8List bytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bytes));

      if (decoded is! Map) {
        return null;
      }

      return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> set<T>(
    String key,
    T data, {
    required Map<String, dynamic> Function(T data) toJson,
    Duration ttl = const Duration(minutes: 30),
  }) async {
    if (ttl <= Duration.zero) {
      await remove(key);
      return;
    }

    final entry = CacheEntry(
      bytes: _encode(data, toJson),
      expiresAt: DateTime.now().add(ttl),
    );

    await _box.put(key, entry);
  }

  @override
  T? get<T>(
    String key, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    final entry = _box.get(key);

    if (entry == null) {
      return null;
    }

    if (entry.isExpired) {
      _remove(key);
      return null;
    }

    final json = _decode(entry.bytes);

    if (json == null) {
      _remove(key);
      return null;
    }

    try {
      return fromJson(json);
    } catch (_) {
      _remove(key);
      return null;
    }
  }

  @override
  Stream<T> getOrFetch<T>(
    String key, {
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T data) toJson,
    required Future<ApiResult<T>> Function() fetch,
    Duration ttl = const Duration(minutes: 30),
    bool skipFetchIfCached = false,
  }) async* {
    final cached = get<T>(key, fromJson: fromJson);

    // Emit cached data immediately.
    if (cached != null) {
      yield cached;
      if (skipFetchIfCached) return;
    }

    // Fetch fresh data.
    final result = await fetch();

    switch (result) {
      case Success<T>(data: final freshData):
        await set<T>(key, freshData, toJson: toJson, ttl: ttl);

        yield freshData;

      case Failure<T>():
        // If cache exists, keep using it.
        if (cached != null) {
          return;
        }

        // No cache available.
        throw result.exception;
    }
  }

  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  void _remove(String key) {
    Future.microtask(() => _box.delete(key));
  }
}
