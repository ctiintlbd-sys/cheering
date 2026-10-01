import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatefulWidget {
  final ImageProvider imageProvider;
  final String heroTag;

  const ImagePreviewScreen({
    super.key,
    required this.imageProvider,
    required this.heroTag,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen>
    with SingleTickerProviderStateMixin {
  final PhotoViewController _controller = PhotoViewController();
  late final AnimationController _snapBackController;
  Animation<Offset>? _snapAnimation;

  final ValueNotifier<Offset> _dragNotifier = ValueNotifier(Offset.zero);
  bool _dragging = false;
  bool _zoomed = false;

  static const _threshold = 120.0;

  @override
  void initState() {
    super.initState();
    _snapBackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _snapBackController.addListener(() {
      if (_snapAnimation != null) {
        _dragNotifier.value = _snapAnimation!.value;
      }
    });

    _controller.outputStateStream.listen(_onScaleChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _snapBackController.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  void _onScaleChanged(PhotoViewControllerValue value) {
    _zoomed = (value.scale ?? 1.0) > 1.05;
  }

  // ── Swipe dismiss ──────────────────────────────────────────────────────────

  void _onDragStart(DragStartDetails _) {
    if (_zoomed) return;
    _snapBackController.stop();
    _dragging = true;
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    final newDy = (_dragNotifier.value.dy + d.delta.dy).clamp(0.0, double.infinity);
    _dragNotifier.value = Offset(0, newDy);
  }

  void _onDragEnd(DragEndDetails d) {
    if (!_dragging) return;
    if (_dragNotifier.value.dy >= _threshold || (d.primaryVelocity ?? 0) > 800) {
      Navigator.of(context).pop();
    } else {
      _doSnapBack();
    }
  }

  void _doSnapBack() {
    _snapAnimation = Tween<Offset>(
      begin: _dragNotifier.value,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _snapBackController, curve: Curves.easeOutCubic));

    _snapBackController
      ..reset()
      ..forward().then((_) {
        _dragging = false;
        _snapAnimation = null;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: ValueListenableBuilder<Offset>(
          valueListenable: _dragNotifier,
          builder: (context, dragOffset, child) {
            final bgOpacity = 1.0 - (dragOffset.dy / (_threshold * 2)).clamp(0.0, 1.0) * 0.7;
            return ColoredBox(
              color: Colors.black.withValues(alpha: bgOpacity),
              child: Transform.translate(
                offset: dragOffset,
                child: child,
              ),
            );
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: PhotoView(
                  controller: _controller,
                  imageProvider: widget.imageProvider,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 4,
                  initialScale: PhotoViewComputedScale.contained,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  loadingBuilder: (_, __) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white54,
                      strokeWidth: 2,
                    ),
                  ),
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white38,
                      size: 64,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
