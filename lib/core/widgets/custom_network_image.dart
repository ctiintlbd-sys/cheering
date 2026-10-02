import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import 'image_preview_screen.dart';

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
            ImagePreviewScreen(imageProvider: provider, heroTag: _heroTag),
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
        memCacheWidth:
            (width != null && width!.isFinite) ? width!.toInt() : null,
        memCacheHeight:
            (height != null && height!.isFinite) ? height!.toInt() : null,
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
      child: ClipRRect(
        borderRadius: _radius,
        child:
            fallbackAsset ??
            Assets.images.placeholder.image(
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}
