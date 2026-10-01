import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  const PreviewVideo({
    super.key,
    required this.videoUrl,
    required this.placeholder,
  });

  final String videoUrl;
  final Widget placeholder;

  @override
  State<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  late final VideoPlayerController _controller;
  final _ready = ValueNotifier<bool>(false);
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _init();
  }

  Future<void> _init() async {
    if (widget.videoUrl.isEmpty) return;
    try {
      await _controller.initialize();
      if (_disposed) return;
      await _controller.setVolume(0);
      await _controller.setLooping(true);
      await _controller.play();
      if (!_disposed) _ready.value = true;
    } catch (_) {
      // fail hole thumbnail-ii thakbe
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ready.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.placeholder,
          ValueListenableBuilder<bool>(
            valueListenable: _ready,
            builder: (context, ready, child) => AnimatedOpacity(
              opacity: ready ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: ready
                  ? FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
