import 'package:dio/dio.dart';

class RequestManager {
  final _tokens = <String, CancelToken>{};

  CancelToken getToken(String key) {
    _tokens[key]?.cancel('Replaced by a newer request: $key');
    return _tokens[key] = CancelToken();
  }

  void cancel(String key, [String? reason]) {
    _tokens[key]?.cancel(reason ?? 'Cancelled: $key');
    _tokens.remove(key);
  }

  void cancelAll([String? reason]) {
    for (final entry in _tokens.entries) {
      entry.value.cancel(reason ?? 'Screen disposed — cancelling: ${entry.key}');
    }
    _tokens.clear();
  }

  bool isCancelled(String key) => _tokens[key]?.isCancelled ?? false;
}