import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class RecentSearchStorage {
  RecentSearchStorage._();

  static const String _boxName = 'recent_searches';
  static const String _key = 'queries';
  static const int maxRecent = 8;

  static Box<String>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  static List<String> getRecent() {
    final raw = _box?.get(_key);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<String>().toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<void> save(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final current = List<String>.from(getRecent());
    current.removeWhere(
      (item) => item.toLowerCase() == normalized.toLowerCase(),
    );
    current.insert(0, normalized);
    if (current.length > maxRecent) {
      current.removeRange(maxRecent, current.length);
    }

    await _box?.put(_key, jsonEncode(current));
  }
}
