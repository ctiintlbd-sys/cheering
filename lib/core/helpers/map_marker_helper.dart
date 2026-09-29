import 'dart:async';
import 'dart:ui' as ui;

import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract final class MapMarkerHelper {
  /// Markers are drawn at this scale and displayed at 1/scale size,
  /// so they look sharp and the same size on every device.
  static const _pixelRatio = 3.0;

  static BitmapDescriptor? _locationMarker;
  static final Map<String, BitmapDescriptor> _profileMarkers = {};
  static final Map<String, BitmapDescriptor> _badgeMarkers = {};

  static void clearCache() {
    _locationMarker = null;
    _profileMarkers.clear();
    _badgeMarkers.clear();
  }

  /// Red pin with a ground dot and a soft ring.
  static Future<BitmapDescriptor> createLocationMarker({
    double size = 42,
  }) async {
    final cached = _locationMarker;
    if (cached != null) return cached;

    const design = 96.0;
    final scale = size / design;
    final cx = size / 2;
    final cy = size - 14 * scale;
    const color = Color(0xFFEF4444);

    final image = await _loadAsset(Assets.images.mapLocation.path);
    try {
      final pinH = cy;
      final pinW = pinH * image.width / image.height;

      return _locationMarker = await _render(size, size, (canvas) {
        canvas.drawCircle(
          Offset(cx, cy),
          24 * scale,
          Paint()..color = color.withValues(alpha: 0.10),
        );
        canvas.drawCircle(Offset(cx, cy), 10 * scale, Paint()..color = color);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH((size - pinW) / 2, 0, pinW, pinH),
          Paint()..filterQuality = FilterQuality.medium,
        );
      });
    } finally {
      image.dispose();
    }
  }

  /// Red circle with a white ring and an icon inside.
  static Future<BitmapDescriptor> createCircularBadgeMarker({
    double size = 42,
    Color circleColor = const Color(0xFFDC2626),
    String? assetPath,
  }) async {
    final image = await _loadAsset(assetPath ?? Assets.images.mapLocation.path);
    try {
      final padding = size * 12 / 64;
      final center = Offset(size / 2, size / 2);

      return await _render(size, size, (canvas) {
        canvas.drawCircle(center, size / 2, Paint()..color = circleColor);
        canvas.drawCircle(
          center,
          size / 2 - size * 1.5 / 64,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = size * 3 / 64,
        );
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(
            padding,
            padding,
            size - padding * 2,
            size - padding * 2,
          ),
          Paint()..filterQuality = FilterQuality.medium,
        );
      });
    } finally {
      image.dispose();
    }
  }

  /// Yellow rounded-square pin with a white icon and a downward tail.
  static Future<BitmapDescriptor> createSvgBadgeMarker({
    required String assetPath,
    double size = 42,
    Color color = const Color(0xFFF5B400),
    double padFactor = 0.14,
  }) async {
    final cacheKey = '$size|${color.toARGB32()}|$assetPath|$padFactor';
    final cached = _badgeMarkers[cacheKey];
    if (cached != null) return cached;

    final icon = await vg.loadPicture(SvgAssetLoader(assetPath), null);
    try {
      final tail = size * 0.2;
      final bodyHeight = size;
      final height = bodyHeight + tail;
      final pad = size * padFactor;
      final iconRect = Rect.fromLTWH(
        pad,
        pad,
        size - pad * 2,
        bodyHeight - pad * 2,
      );

      return _badgeMarkers[cacheKey] = await _render(size, height, (canvas) {
        final center = Offset(size / 2, bodyHeight / 2);
        final radius = size / 2;

        final circlePath = Path()
          ..addOval(Rect.fromCircle(center: center, radius: radius));
        final tailPath = Path()
          ..moveTo(size * 0.36, bodyHeight * 0.95)
          ..lineTo(size * 0.64, bodyHeight * 0.95)
          ..lineTo(size / 2, height - 1)
          ..close();

        canvas.drawShadow(circlePath, Colors.black, 2, false);
        canvas.drawCircle(center, radius, Paint()..color = color);
        canvas.drawPath(tailPath, Paint()..color = color);

        canvas.save();
        canvas.translate(iconRect.left, iconRect.top);
        canvas.scale(
          iconRect.width / icon.size.width,
          iconRect.height / icon.size.height,
        );
        canvas.drawPicture(icon.picture);
        canvas.restore();
      });
    } finally {
      icon.picture.dispose();
    }
  }

  static Future<BitmapDescriptor> createProfileMarker({
    String? photoUrl,
    bool showOnlineDot = false,
    double size = 42,
  }) async {
    final image =
    _isNetworkPhoto(photoUrl) ? await _loadNetworkImage(photoUrl!) : null;

    final cacheKey = '$size|$showOnlineDot|${image != null ? photoUrl : 'person'}';
    final cached = _profileMarkers[cacheKey];
    if (cached != null) {
      image?.dispose();
      return cached;
    }

    try {
      const ring = 5.0;
      final tail = size * 0.18;
      final width = size + ring * 2;
      final height = size + ring * 2 + tail;
      final center = Offset(width / 2, ring + size / 2);
      final photoRadius = size / 2 - 2;
      final photoRect = Rect.fromCircle(center: center, radius: photoRadius);

      return _profileMarkers[cacheKey] = await _render(width, height, (canvas) {
        canvas.drawCircle(
          center,
          size / 2 + ring,
          Paint()..color = const Color(0xFFE4D7FF),
        );
        final tailPath = Path()
          ..moveTo(center.dx - 6, center.dy + size / 2 - 1)
          ..lineTo(center.dx + 6, center.dy + size / 2 - 1)
          ..lineTo(center.dx, height - 1)
          ..close();
        canvas.drawPath(tailPath, Paint()..color = const Color(0xFFE4D7FF));
        canvas.drawCircle(center, size / 2, Paint()..color = Colors.white);

        canvas
          ..save()
          ..clipPath(Path()..addOval(photoRect));

        if (image != null) {
          paintImage(
            canvas: canvas,
            rect: photoRect,
            image: image,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          );
        } else {
          // image null hole Icons.person
          canvas.drawCircle(
            center,
            photoRadius,
            Paint()..color = const Color(0xFFF8FAFC),
          );
          final icon = Icons.person;
          final painter = TextPainter(
            text: TextSpan(
              text: String.fromCharCode(icon.codePoint),
              style: TextStyle(
                fontSize: photoRadius * 1.5,
                fontFamily: icon.fontFamily,
                package: icon.fontPackage,
                color: const Color(0xFF94A3B8),
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          painter.paint(
            canvas,
            center - Offset(painter.width / 2, painter.height / 2),
          );
        }
        canvas.restore();

        if (showOnlineDot) {
          final dot = Offset(
            center.dx + photoRadius * 0.72,
            center.dy + photoRadius * 0.72,
          );
          canvas.drawCircle(dot, 6.2, Paint()..color = Colors.white);
          canvas.drawCircle(dot, 4.6, Paint()..color = const Color(0xFF22C55E));
        }
      });
    } finally {
      image?.dispose();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────

  static Future<ui.Image> _loadAsset(String path) async {
    final data = await rootBundle.load(path);
    return _decode(data.buffer.asUint8List());
  }

  static Future<ui.Image> _decode(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: 192);
    try {
      return (await codec.getNextFrame()).image;
    } finally {
      codec.dispose();
    }
  }

  /// Draws in logical units, outputs a PNG at [_pixelRatio] density.
  static Future<BitmapDescriptor> _render(
    double width,
    double height,
    void Function(Canvas canvas) paint,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(_pixelRatio);
    paint(canvas);

    final picture = recorder.endRecording();
    try {
      final image = await picture.toImage(
        (width * _pixelRatio).round(),
        (height * _pixelRatio).round(),
      );
      try {
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        if (bytes == null) throw StateError('Marker PNG render failed');
        return BitmapDescriptor.bytes(
          bytes.buffer.asUint8List(),
          imagePixelRatio: _pixelRatio,
        );
      } finally {
        image.dispose();
      }
    } finally {
      picture.dispose();
    }
  }

  static bool _isNetworkPhoto(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static Future<ui.Image?> _loadNetworkImage(String url) async {
    try {
      final completer = Completer<ui.Image>();
      final stream = NetworkImage(url).resolve(const ImageConfiguration());
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

  // ── Widget version of the location pin (center-pin overlays) ───────
  // Move this to its own widget file if it is used outside markers.

  static Widget buildLocationPinOverlay({
    double width = 96,
    double height = 96,
    Color circleColor = const Color(0xFFEF4444),
  }) {
    final cx = width / 2;
    final cy = height - 14;
    final scale = height / 96;

    Widget circle(double diameter, Color color) => Positioned(
      left: cx - diameter * scale / 2,
      top: cy - diameter * scale / 2,
      width: diameter * scale,
      height: diameter * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          circle(48, circleColor.withValues(alpha: 0.10)),
          circle(20, circleColor),
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
