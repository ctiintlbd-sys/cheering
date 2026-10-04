import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

/// Centralized manager & pool for [VideoPlayerController] instances used in Reels and Bites.
///
/// Features:
/// - Reuses already initialized controllers between BitesCard and ReelsViewerScreen (0ms loading).
/// - Deduplicates simultaneous initialization requests.
/// - Bounded LRU cache (default max 4) to prevent memory bloating.
/// - Background preloading for adjacent reels.
class ReelsVideoControllerManager {
  static final ReelsVideoControllerManager _instance =
      ReelsVideoControllerManager._internal();
  static ReelsVideoControllerManager get instance => _instance;
  ReelsVideoControllerManager._internal();

  static const int _maxCachedControllers = 4;

  final Map<String, VideoPlayerController> _controllers = {};
  final Map<String, Future<VideoPlayerController>> _inFlight = {};
  final List<String> _lruKeys = [];

  /// Returns an existing controller if present in the pool.
  VideoPlayerController? getController(String url) {
    final trimmed = url.trim();
    if (_controllers.containsKey(trimmed)) {
      _touch(trimmed);
      return _controllers[trimmed];
    }
    return null;
  }

  /// Checks if a controller exists and is already initialized.
  bool isInitialized(String url) {
    final c = _controllers[url.trim()];
    return c != null && c.value.isInitialized;
  }

  /// Gets an existing controller or initializes a new one.
  Future<VideoPlayerController> getOrCreateController(
    String url, {
    bool isMuted = true,
    bool isLooping = true,
    bool autoPlay = true,
    bool? mixWithOthers,
  }) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Video URL cannot be empty');
    }

    if (_controllers.containsKey(trimmed)) {
      _touch(trimmed);
      final c = _controllers[trimmed]!;
      if (c.value.isInitialized) {
        if (c.value.isLooping != isLooping) {
          await c.setLooping(isLooping);
        }
        await c.setVolume(isMuted ? 0.0 : 1.0);
        if (autoPlay && !c.value.isPlaying) {
          await c.play();
        }
        return c;
      }
    }

    // Return in-flight future if initialization is already underway
    if (_inFlight.containsKey(trimmed)) {
      return _inFlight[trimmed]!;
    }

    final future = _initializeController(
      trimmed,
      isMuted: isMuted,
      isLooping: isLooping,
      autoPlay: autoPlay,
      mixWithOthers: mixWithOthers ?? isMuted,
    );
    _inFlight[trimmed] = future;

    try {
      final controller = await future;
      return controller;
    } finally {
      _inFlight.remove(trimmed);
    }
  }

  Future<VideoPlayerController> _initializeController(
    String url, {
    required bool isMuted,
    required bool isLooping,
    required bool autoPlay,
    required bool mixWithOthers,
  }) async {
    _evictOldIfNeeded();

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: mixWithOthers,
      ),
    );

    try {
      await controller.initialize();
      await controller.setLooping(isLooping);
      await controller.setVolume(isMuted ? 0.0 : 1.0);

      if (autoPlay) {
        await controller.play();
      }

      _controllers[url] = controller;
      _touch(url);
      return controller;
    } catch (e) {
      debugPrint('ReelsVideoControllerManager: Error initializing $url - $e');
      try {
        await controller.dispose();
      } catch (_) {}
      rethrow;
    }
  }

  void _touch(String key) {
    _lruKeys.remove(key);
    _lruKeys.add(key);
  }

  void _evictOldIfNeeded() {
    while (_controllers.length >= _maxCachedControllers && _lruKeys.isNotEmpty) {
      final oldestUrl = _lruKeys.removeAt(0);
      final controller = _controllers.remove(oldestUrl);
      try {
        controller?.pause();
        controller?.dispose();
      } catch (_) {}
    }
  }

  /// Preloads a video silently in the background (muted, not playing).
  Future<void> preload(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty ||
        _controllers.containsKey(trimmed) ||
        _inFlight.containsKey(trimmed)) {
      return;
    }
    try {
      await getOrCreateController(
        trimmed,
        isMuted: true,
        isLooping: true,
        autoPlay: false,
      );
    } catch (_) {}
  }

  /// Pauses all currently playing controllers in the pool.
  void pauseAll() {
    for (final c in _controllers.values) {
      try {
        if (c.value.isInitialized && c.value.isPlaying) {
          c.pause();
        }
      } catch (_) {}
    }
  }

  /// Mutes all controllers in the pool.
  void muteAll() {
    for (final c in _controllers.values) {
      try {
        if (c.value.isInitialized) {
          c.setVolume(0.0);
        }
      } catch (_) {}
    }
  }

  /// Disposes a specific controller by URL.
  void disposeUrl(String url) {
    final trimmed = url.trim();
    _lruKeys.remove(trimmed);
    final c = _controllers.remove(trimmed);
    try {
      c?.pause();
      c?.dispose();
    } catch (_) {}
  }

  /// Disposes all managed controllers and clears cache.
  void disposeAll() {
    for (final c in _controllers.values) {
      try {
        c.pause();
        c.dispose();
      } catch (_) {}
    }
    _controllers.clear();
    _lruKeys.clear();
    _inFlight.clear();
  }
}
