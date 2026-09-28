import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';

abstract final class MapMarkerHelper {
  // ── Singleton cache — একবার render হলে memory তে থাকে ──────────────
  static BitmapDescriptor? _cachedLocationMarker;
  static final Map<String, BitmapDescriptor> _cachedProfileMarkers = {};

  /// Main location pin marker:
  /// - Ground এ: 20×20 solid red circle + 48px border ring (10% red/500 — Figma exact)
  /// - উপরে: map_location.png asset icon
  static Future<BitmapDescriptor> createLocationMarker({
    double width = 96, // ← বড় করা: 48px border ring + pin icon ধরতে
    double height = 96,
    Color circleColor = const Color(0xFFEF4444), // red/500 — Figma exact
    bool useCache = true,
  }) async {
    // ✅ Cache hit — re-render এড়ানো
    if (useCache && _cachedLocationMarker != null) {
      return _cachedLocationMarker!;
    }

    // ── 1. Asset image load ──────────────────────────────────────────
    final ByteData byteData = await rootBundle.load(
      Assets.images.mapLocation.path,
    );
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // ── 2. Canvas setup ──────────────────────────────────────────────
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final double cx = width / 2; // horizontal center
    final double cy =
        height - 14; // ground dot vertical center (pin tip এর কাছে)

    // ── 3. Border ring — 48px, red/500 @ 10% opacity (Figma exact) ──
    canvas.drawCircle(
      Offset(cx, cy),
      24, // radius = 48 / 2
      Paint()
        ..color = circleColor.withValues(alpha: 0.10)
        ..style = PaintingStyle.fill,
    );

    // ── 4. Solid red dot — 20×20 perfect circle (Figma exact) ───────
    canvas.drawCircle(
      Offset(cx, cy),
      10, // radius = 20 / 2
      Paint()
        ..color = circleColor
        ..style = PaintingStyle.fill,
    );

    // ── 5. Pin icon — dot এর উপরে, canvas top থেকে ─────────────────
    //    pin bottom = cy (dot center), top থেকে সেই পর্যন্ত
    final double pinH = cy;
    final double pinW = pinH * (image.width / image.height);
    final double pinL = (width - pinW) / 2;

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(pinL, 0, pinW, pinH),
      Paint()
        ..filterQuality =
            FilterQuality.medium, // ✅ high → medium: low-end GPU ভালো
    );

    // ── 6. PNG render ────────────────────────────────────────────────
    final picture = recorder.endRecording();
    final renderedImage = await picture.toImage(width.toInt(), height.toInt());
    final pngBytes = await renderedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (pngBytes == null) {
      throw StateError('Failed to render map marker to PNG bytes');
    }

    final marker = BitmapDescriptor.bytes(pngBytes.buffer.asUint8List());

    if (useCache) _cachedLocationMarker = marker;

    // ✅ Memory cleanup — Flutter GC কে hint দেওয়া
    image.dispose();
    renderedImage.dispose();

    return marker;
  }

  /// Circular badge marker — background circle + icon inside
  static Future<BitmapDescriptor> createCircularBadgeMarker({
    double size = 64,
    Color circleColor = const Color(0xFFDC2626),
    String? assetPath,
  }) async {
    final path = assetPath ?? Assets.images.mapLocation.path;
    final ByteData byteData = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Background red circle
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      Paint()
        ..color = circleColor
        ..style = PaintingStyle.fill,
    );

    // White border ring
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      (size / 2) - 1.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Icon inside
    const double padding = 12.0;
    final double iconSize = size - (padding * 2);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(padding, padding, iconSize, iconSize),
      Paint()
        ..filterQuality = FilterQuality.medium, // ✅ medium — low-end friendly
    );

    final picture = recorder.endRecording();
    final renderedImage = await picture.toImage(size.toInt(), size.toInt());
    final pngBytes = await renderedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (pngBytes == null) {
      throw StateError('Failed to render circular badge marker to PNG bytes');
    }

    final marker = BitmapDescriptor.bytes(pngBytes.buffer.asUint8List());

    // ✅ Memory cleanup
    image.dispose();
    renderedImage.dispose();

    return marker;
  }

  /// Circular profile pin — photo (or fallback) with a white ring and pointer.
  static Future<BitmapDescriptor> createProfileMarker({
    String? photoUrl,
    String? fallbackAsset,
    double size = 88,
  }) async {
    final fallback = fallbackAsset ?? Assets.images.placeholder.path;
    final cacheKey = (photoUrl != null && photoUrl.isNotEmpty)
        ? photoUrl
        : fallback;
    final cached = _cachedProfileMarkers[cacheKey];
    if (cached != null) return cached;

    final image = await _loadProfileImage(photoUrl, fallback);
    final pointer = size * 0.16;
    final width = size;
    final height = size + pointer;
    final center = Offset(size / 2, size / 2);
    final radius = (size / 2) - 4;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final pinPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius + 3))
      ..moveTo(center.dx - 10, center.dy + radius - 4)
      ..lineTo(center.dx + 10, center.dy + radius - 4)
      ..lineTo(center.dx, height - 1)
      ..close();

    canvas.drawPath(
      pinPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(pinPath, Paint()..color = Colors.white);

    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
    paintImage(
      canvas: canvas,
      rect: Rect.fromCircle(center: center, radius: radius),
      image: image,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
    );
    canvas.restore();

    final picture = recorder.endRecording();
    final renderedImage = await picture.toImage(
      width.toInt(),
      height.toInt(),
    );
    final pngBytes = await renderedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    image.dispose();
    renderedImage.dispose();

    if (pngBytes == null) {
      throw StateError('Failed to render profile marker to PNG bytes');
    }

    final marker = BitmapDescriptor.bytes(pngBytes.buffer.asUint8List());
    _cachedProfileMarkers[cacheKey] = marker;
    return marker;
  }

  static Future<ui.Image> _loadProfileImage(
    String? photoUrl,
    String fallbackAsset,
  ) async {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      final networkImage = await _loadNetworkImage(photoUrl);
      if (networkImage != null) return networkImage;
    }

    final byteData = await rootBundle.load(fallbackAsset);
    return _decodeImage(byteData.buffer.asUint8List());
  }

  static Future<ui.Image?> _loadNetworkImage(String url) async {
    try {
      final provider = NetworkImage(url);
      final completer = Completer<ui.Image>();
      final stream = provider.resolve(const ImageConfiguration());
      late final ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          if (!completer.isCompleted) completer.complete(info.image.clone());
        },
        onError: (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        },
      );
      stream.addListener(listener);
      try {
        return await completer.future.timeout(const Duration(seconds: 6));
      } finally {
        stream.removeListener(listener);
      }
    } catch (_) {
      return null;
    }
  }

  static Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 192,
      targetHeight: 192,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Cache manually clear করতে হলে (hot reload / theme change এ দরকার হলে)
  static void clearCache() {
    _cachedLocationMarker = null;
    _cachedProfileMarkers.clear();
  }

  /// Same Figma pin as [createLocationMarker], for fixed center-pin map overlays.
  static Widget buildLocationPinOverlay({
    double width = 96,
    double height = 96,
    Color circleColor = const Color(0xFFEF4444),
  }) {
    final double cx = width / 2;
    final double cy = height - 14;
    final double scale = height / 96;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: cx - (24 * scale),
            top: cy - (24 * scale),
            width: 48 * scale,
            height: 48 * scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            left: cx - (10 * scale),
            top: cy - (10 * scale),
            width: 20 * scale,
            height: 20 * scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: cy,
            child: Image.asset(
              Assets.images.mapLocation.path,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
