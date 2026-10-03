import 'package:flutter/material.dart';

class FlyToCartController {
  final GlobalKey cartKey = GlobalKey();
  final List<OverlayEntry> _entries = [];

  void fly({
    required BuildContext from,
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onEnd,
  }) {
    final srcBox = from.findRenderObject() as RenderBox?;
    final cartBox = cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (srcBox == null || !srcBox.attached || cartBox == null) {
      onEnd?.call();
      return;
    }

    final overlay = Overlay.of(from);
    final size = srcBox.size;
    final start = srcBox.localToGlobal(Offset.zero);
    final end =
        cartBox.localToGlobal(cartBox.size.center(Offset.zero)) -
        size.center(Offset.zero);

    final controller = AnimationController(vsync: overlay, duration: duration);
    final curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: curve,
        child: SizedBox(width: size.width, height: size.height, child: child),
        builder: (_, child) {
          final pos = Offset.lerp(start, end, curve.value)!;
          return Positioned(
            left: pos.dx,
            top: pos.dy,
            child: IgnorePointer(
              child: Transform.scale(
                scale: 1 - 0.8 * curve.value,
                child: child,
              ),
            ),
          );
        },
      ),
    );

    _entries.add(entry);
    overlay.insert(entry);
    controller.forward().whenComplete(() {
      entry.remove();
      _entries.remove(entry);
      controller.dispose();
      onEnd?.call();
    });
  }

  void dispose() {
    for (final e in _entries) {
      e.remove();
    }
    _entries.clear();
  }
}

class CartTarget extends StatelessWidget {
  const CartTarget({super.key, required this.controller, required this.child});

  final FlyToCartController controller;
  final Widget? child; // null = empty cart

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: controller.cartKey,
      child: child ?? const SizedBox(width: 1, height: 1),
    );
  }
}

class FlyToCartScope extends InheritedWidget {
  const FlyToCartScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final FlyToCartController controller;

  static FlyToCartController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FlyToCartScope>()?.controller;

  @override
  bool updateShouldNotify(FlyToCartScope old) => controller != old.controller;
}
