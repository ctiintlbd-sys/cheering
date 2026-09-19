import 'package:flutter/material.dart';

enum CustomItemAnimationType { scale, slide, fade }

class CustomItemAnimator extends StatefulWidget {
  final Widget child;
  final int? index;
  final CustomItemAnimationType animationType;
  final Duration delayBase;
  final Duration animationDuration;
  final int maxStaggerIndex;

  const CustomItemAnimator({
    super.key,
    required this.child,
    this.index,
    this.animationType = CustomItemAnimationType.scale,
    this.delayBase = const Duration(milliseconds: 16),
    this.animationDuration = const Duration(milliseconds: 350),
    this.maxStaggerIndex = 10,
  });

  @override
  State<CustomItemAnimator> createState() => _CustomItemAnimatorState();
}

class _CustomItemAnimatorState extends State<CustomItemAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _opacity = curved;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(curved);

    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(curved);

    _startAnimation();
  }

  void _startAnimation() {
    final cappedIndex = (widget.index ?? 0).clamp(0, widget.maxStaggerIndex);
    final delayMs = widget.delayBase.inMilliseconds * cappedIndex;

    if (delayMs == 0) {
      _controller.forward();
    } else {
      Future<void>.delayed(Duration(milliseconds: delayMs), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrapping in RepaintBoundary fixes Impeller opacity crashes during scroll
    // and improves performance during the scale/fade/slide animations.
    final Widget repaintedChild = RepaintBoundary(child: widget.child);
    
    return switch (widget.animationType) {
      CustomItemAnimationType.slide => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: repaintedChild),
      ),
      CustomItemAnimationType.scale => FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(scale: _scale, child: repaintedChild),
      ),
      CustomItemAnimationType.fade => FadeTransition(
        opacity: _opacity,
        child: repaintedChild,
      ),
    };
  }
}
