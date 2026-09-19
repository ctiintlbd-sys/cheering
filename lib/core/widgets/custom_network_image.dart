import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Custom Network Image
// ─────────────────────────────────────────────────────────────────────────────

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final Widget? fallbackAsset;

  final double? height;
  final double? width;

  final Border? border;
  final double? borderRadius;
  final BoxShape boxShape;

  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;

  final List<BoxShadow>? boxShadow;
  final bool elevation;
  final BoxFit? fit;

  final bool _enablePreview;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    this.imageUrl,
    this.imageFile,
    this.fallbackAsset,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.boxShadow,
    this.elevation = false,
    this.fit,
  }) : _enablePreview = false;

  const CustomNetworkImage.view({
    super.key,
    this.child,
    this.colorFilter,
    this.imageUrl,
    this.imageFile,
    this.fallbackAsset,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.boxShadow,
    this.elevation = false,
    this.fit,
  }) : _enablePreview = true;

  // ── Helpers ────────────────────────────────────────────────────────────────

  BorderRadius get _radius {
    if (boxShape == BoxShape.circle) return BorderRadius.circular(9999);
    return borderRadius != null
        ? BorderRadius.circular(borderRadius!)
        : BorderRadius.zero;
  }

  String get _heroTag {
    final url = imageUrl?.trim() ?? '';
    return url.isNotEmpty ? 'cni_$url' : 'cni_file_${imageFile?.path ?? ''}';
  }

  // ── Preview ────────────────────────────────────────────────────────────────

  void _openPreview(BuildContext context, ImageProvider provider) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) =>
            _ImagePreviewScreen(imageProvider: provider, heroTag: _heroTag),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  Widget _withPreview(
    BuildContext ctx, {
    required Widget child,
    required ImageProvider provider,
  }) {
    if (!_enablePreview) return child;
    return GestureDetector(
      onTap: () => _openPreview(ctx, provider),
      child: Hero(tag: _heroTag, child: child),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return _withPreview(
        context,
        provider: FileImage(imageFile!),
        child: _container(
          null,
          fileChild: Image.file(imageFile!, fit: fit ?? BoxFit.cover),
        ),
      );
    }

    final url = imageUrl?.trim() ?? '';

    if (url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        memCacheWidth: width?.toInt(),
        memCacheHeight: height?.toInt(),
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,

        imageBuilder: (ctx, provider) =>
            _withPreview(ctx, provider: provider, child: _container(provider)),
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: _container(null, shimmer: true),
        ),
        errorWidget: (_, __, err) {
          debugPrint('❌ Image load error: $err');
          return _fallback();
        },
      );
    }

    return _fallback();
  }

  // ── Private builders ───────────────────────────────────────────────────────

  Widget _container(
    ImageProvider? provider, {
    bool shimmer = false,
    Widget? fileChild,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: _decoration(provider: provider, shimmer: shimmer),
      child: fileChild != null
          ? ClipRRect(borderRadius: _radius, child: fileChild)
          : child,
    );
  }

  BoxDecoration _decoration({ImageProvider? provider, bool shimmer = false}) {
    return BoxDecoration(
      color: shimmer ? Colors.grey.withValues(alpha: 0.4) : backgroundColor,
      boxShadow:
          boxShadow ??
          (elevation
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    spreadRadius: 6,
                  ),
                ]
              : null),
      border: border,
      borderRadius: boxShape == BoxShape.circle ? null : _radius,
      shape: boxShape,
      image: provider != null
          ? DecorationImage(
              image: provider,
              fit: fit ?? BoxFit.cover,
              colorFilter: colorFilter,
            )
          : null,
    );
  }

  Widget _fallback() {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: _decoration(),
      child:
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            child: fallbackAsset ??
                Assets.images.placeholder.image(
                    height: height,
                    width: width,
                    fit: BoxFit.cover
                ),
          )
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Full-Screen Image Preview
// ─────────────────────────────────────────────────────────────────────────────

class _ImagePreviewScreen extends StatefulWidget {
  final ImageProvider imageProvider;
  final String heroTag;

  const _ImagePreviewScreen({
    required this.imageProvider,
    required this.heroTag,
  });

  @override
  State<_ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<_ImagePreviewScreen>
    with SingleTickerProviderStateMixin {
  final PhotoViewController _controller = PhotoViewController();
  late final AnimationController _snapBack;

  Offset _drag = Offset.zero;
  bool _dragging = false;
  bool _zoomed = false;

  static const _threshold = 120.0;

  @override
  void initState() {
    super.initState();
    _snapBack = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _controller.outputStateStream.listen(_onScaleChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _snapBack.dispose();
    super.dispose();
  }

  void _onScaleChanged(PhotoViewControllerValue value) {
    final isZoomed = (value.scale ?? 1.0) > 1.05;
    if (isZoomed != _zoomed) setState(() => _zoomed = isZoomed);
  }

  // ── Swipe dismiss ──────────────────────────────────────────────────────────

  void _onDragStart(DragStartDetails _) {
    if (_zoomed) return;
    _snapBack.stop();
    setState(() => _dragging = true);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    setState(() {
      _drag = Offset(0, (_drag.dy + d.delta.dy).clamp(0, double.infinity));
    });
  }

  void _onDragEnd(DragEndDetails d) {
    if (!_dragging) return;
    if (_drag.dy >= _threshold || (d.primaryVelocity ?? 0) > 800) {
      Navigator.of(context).pop();
    } else {
      _doSnapBack();
    }
  }

  void _doSnapBack() {
    final start = _drag;
    final anim = Tween<Offset>(
      begin: start,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _snapBack, curve: Curves.easeOutCubic));

    anim.addListener(() {
      if (mounted) setState(() => _drag = anim.value);
    });

    _snapBack
      ..reset()
      ..forward().then((_) {
        if (mounted)
          setState(() {
            _drag = Offset.zero;
            _dragging = false;
          });
      });
  }

  double get _bgOpacity =>
      1.0 - (_drag.dy / (_threshold * 2)).clamp(0.0, 1.0) * 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: ColoredBox(
          color: Colors.black.withValues(alpha: _bgOpacity),
          child: Transform.translate(
            offset: _drag,
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
        ),
      ),
    );
  }
}
