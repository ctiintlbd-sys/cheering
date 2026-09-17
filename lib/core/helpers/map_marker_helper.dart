import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';

abstract final class MapMarkerHelper {
  // ── Singleton cache — একবার render হলে memory তে থাকে ──────────────
  static BitmapDescriptor? _cachedLocationMarker;

  /// Main location pin marker:
  /// - Ground এ: 20×20 solid red circle + 48px border ring (10% red/500 — Figma exact)
  /// - উপরে: map_location.png asset icon
  static Future<BitmapDescriptor> createLocationMarker({
    double width = 96,   // ← বড় করা: 48px border ring + pin icon ধরতে
    double height = 96,
    Color circleColor = const Color(0xFFEF4444), // red/500 — Figma exact
    bool useCache = true,
  }) async {
    // ✅ Cache hit — re-render এড়ানো
    if (useCache && _cachedLocationMarker != null) {
      return _cachedLocationMarker!;
    }

    // ── 1. Asset image load ──────────────────────────────────────────
    final ByteData byteData =
    await rootBundle.load(Assets.images.mapLocation.path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // ── 2. Canvas setup ──────────────────────────────────────────────
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final double cx = width / 2;    // horizontal center
    final double cy = height - 14;  // ground dot vertical center (pin tip এর কাছে)

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
      Paint()..filterQuality = FilterQuality.medium, // ✅ high → medium: low-end GPU ভালো
    );

    // ── 6. PNG render ────────────────────────────────────────────────
    final picture = recorder.endRecording();
    final renderedImage =
    await picture.toImage(width.toInt(), height.toInt());
    final pngBytes =
    await renderedImage.toByteData(format: ui.ImageByteFormat.png);

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
      Paint()..filterQuality = FilterQuality.medium, // ✅ medium — low-end friendly
    );

    final picture = recorder.endRecording();
    final renderedImage = await picture.toImage(size.toInt(), size.toInt());
    final pngBytes =
    await renderedImage.toByteData(format: ui.ImageByteFormat.png);

    if (pngBytes == null) {
      throw StateError('Failed to render circular badge marker to PNG bytes');
    }

    final marker = BitmapDescriptor.bytes(pngBytes.buffer.asUint8List());

    // ✅ Memory cleanup
    image.dispose();
    renderedImage.dispose();

    return marker;
  }

  /// Cache manually clear করতে হলে (hot reload / theme change এ দরকার হলে)
  static void clearCache() {
    _cachedLocationMarker = null;
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