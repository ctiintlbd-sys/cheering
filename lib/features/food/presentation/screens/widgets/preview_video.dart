import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A high-performance, reusable video player widget optimized for previews,
/// vertical reels, feeds, and cards.
///
/// Features:
/// - Smooth cross-fade from placeholder to video texture
/// - [isActive] visibility control for PageView / scroll lists (auto play/pause)
/// - [isMuted] volume control with audio session optimization ([mixWithOthers])
/// - [WidgetsBindingObserver] lifecycle management (auto pause in background)
/// - [RepaintBoundary] to isolate video texture repaints for 60fps performance
/// - Tap-to-play/pause with visual indicator
/// - [overlayBuilder] and [overlay] support (progress bars, badges, controls)
class PreviewVideo extends StatefulWidget {
  const PreviewVideo({
    super.key,
    required this.videoUrl,
    this.placeholder,
    this.isActive = true,
    this.isMuted = true,
    this.mixWithOthers,
    this.autoPlay = true,
    this.isLooping = true,
    this.fit = BoxFit.cover,
    this.enableTapToPlayPause = false,
    this.fadeDuration = const Duration(milliseconds: 250),
    this.overlay,
    this.overlayBuilder,
    this.onControllerInitialized,
  });

  /// URL of the video (network URL).
  final String videoUrl;

  /// Optional widget displayed while video initializes or on error.
  final Widget? placeholder;

  /// Controls play/pause based on screen/scroll visibility (e.g. PageView index).
  final bool isActive;

  /// Whether audio is muted (default: true).
  final bool isMuted;

  /// Whether audio session allows background music.
  /// If null, defaults to [isMuted].
  final bool? mixWithOthers;

  /// Whether to start playback automatically once initialized.
  final bool autoPlay;

  /// Whether to loop playback when finished.
  final bool isLooping;

  /// How the video should fit inside its container (default: [BoxFit.cover]).
  final BoxFit fit;

  /// Whether tapping on the video toggles play/pause with visual indicator.
  final bool enableTapToPlayPause;

  /// Cross-fade duration from placeholder to video texture.
  final Duration fadeDuration;

  /// Static overlay widget placed above video but beneath tap handlers.
  final Widget? overlay;

  /// Builder for dynamic overlays that need access to the [VideoPlayerController].
  final Widget Function(BuildContext context, VideoPlayerController? controller)?
      overlayBuilder;

  /// Callback when [VideoPlayerController] finishes initialization.
  final ValueChanged<VideoPlayerController>? onControllerInitialized;

  @override
  State<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  final ValueNotifier<bool> _ready = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  bool _disposed = false;
  bool _wasPlayingBeforeBackground = false;

  bool get _effectiveMixWithOthers => widget.mixWithOthers ?? widget.isMuted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !_ready.value) return;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        // Capture playing state only if actively playing.
        // Don't overwrite if subsequent states (e.g. inactive -> paused) arrive.
        if (controller.value.isPlaying) {
          _wasPlayingBeforeBackground = true;
          controller.pause();
          _isPlaying.value = false;
        }
        break;
      case AppLifecycleState.resumed:
        if (_wasPlayingBeforeBackground && widget.isActive && widget.autoPlay) {
          controller.play();
          _isPlaying.value = true;
        }
        _wasPlayingBeforeBackground = false;
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _initController() async {
    final url = widget.videoUrl.trim();
    if (url.isEmpty) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: _effectiveMixWithOthers,
      ),
    );
    _controller = controller;

    try {
      await controller.initialize();
      // If widget was disposed or URL changed while waiting for initialize:
      if (_disposed || _controller != controller) {
        // Old controller was already disposed or orphaned
        return;
      }

      controller.addListener(_onControllerUpdate);
      await controller.setLooping(widget.isLooping);
      await controller.setVolume(widget.isMuted ? 0.0 : 1.0);

      if (widget.isActive && widget.autoPlay) {
        await controller.play();
        _isPlaying.value = true;
      } else {
        _isPlaying.value = false;
      }

      if (!_disposed && _controller == controller) {
        _ready.value = true;
        widget.onControllerInitialized?.call(controller);
      }
    } catch (e) {
      debugPrint('PreviewVideo init error: $e');
    }
  }

  void _onControllerUpdate() {
    if (_disposed || _controller == null) return;
    final isPlaying = _controller!.value.isPlaying;
    if (_isPlaying.value != isPlaying) {
      _isPlaying.value = isPlaying;
    }
  }

  @override
  void didUpdateWidget(PreviewVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl != widget.videoUrl) {
      _ready.value = false;
      _isPlaying.value = false;
      _disposeController();
      _initController();
      return;
    }

    final controller = _controller;
    if (controller == null) return;

    final oldMix = oldWidget.mixWithOthers ?? oldWidget.isMuted;
    final newMix = widget.mixWithOthers ?? widget.isMuted;
    if (oldMix != newMix) {
      _ready.value = false;
      _isPlaying.value = false;
      _disposeController();
      _initController();
      return;
    }

    if (!_ready.value) return;

    if (oldWidget.isMuted != widget.isMuted) {
      controller.setVolume(widget.isMuted ? 0.0 : 1.0);
    }

    if (oldWidget.isLooping != widget.isLooping) {
      controller.setLooping(widget.isLooping);
    }

    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive && widget.autoPlay) {
        controller.play();
      } else {
        _wasPlayingBeforeBackground = false;
        controller.pause();
      }
    }
  }

  void _togglePlayPause() {
    final controller = _controller;
    if (controller == null || !_ready.value) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _disposeController() {
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      controller.removeListener(_onControllerUpdate);
      controller.pause();
      controller.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true;
    _ready.dispose();
    _isPlaying.dispose();
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.placeholder != null) widget.placeholder!,
          ValueListenableBuilder<bool>(
            valueListenable: _ready,
            builder: (context, ready, _) {
              final controller = _controller;
              final isReady =
                  ready && controller != null && controller.value.isInitialized;
              return AnimatedOpacity(
                opacity: isReady ? 1.0 : 0.0,
                duration: widget.fadeDuration,
                curve: Curves.easeInOut,
                child: isReady
                    ? FittedBox(
                        fit: widget.fit,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
          if (widget.enableTapToPlayPause)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _togglePlayPause,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _ready,
                  builder: (context, ready, _) {
                    if (!ready) return const SizedBox.shrink();
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isPlaying,
                      builder: (context, isPlaying, _) {
                        if (isPlaying) return const SizedBox.shrink();
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          if (widget.overlay != null) widget.overlay!,
          if (widget.overlayBuilder != null)
            ValueListenableBuilder<bool>(
              valueListenable: _ready,
              builder: (context, ready, _) {
                return widget.overlayBuilder!(context, _controller);
              },
            ),
        ],
      ),
    );
  }
}
