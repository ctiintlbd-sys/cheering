import 'dart:async';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/promotion_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedPromotionBadge extends StatefulWidget {
  const AnimatedPromotionBadge({
    super.key,
    required this.promotions,
    this.paddingHorizontal,
    this.paddingVertical,
    this.borderRadius,
    this.fontSize,
    this.iconSize,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.interval = const Duration(seconds: 3),
  });

  final List<PromotionEntity> promotions;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? borderRadius;
  final double? fontSize;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Duration interval;

  @override
  State<AnimatedPromotionBadge> createState() => _AnimatedPromotionBadgeState();
}

class _AnimatedPromotionBadgeState extends State<AnimatedPromotionBadge> {
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant AnimatedPromotionBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.promotions.length != oldWidget.promotions.length ||
        widget.interval != oldWidget.interval) {
      if (_currentIndex >= widget.promotions.length) {
        _currentIndex = 0;
      }
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.promotions.length > 1) {
      _timer = Timer.periodic(widget.interval, (_) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.promotions.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.promotions.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentPromo =
        widget.promotions[_currentIndex % widget.promotions.length];

    return CustomContainer(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      paddingHorizontal: widget.paddingHorizontal ?? 6.w,
      paddingVertical: widget.paddingVertical ?? 3.w,
      radiusAll: widget.borderRadius ?? 6.r,
      color: widget.backgroundColor ?? context.colors.primary,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.center,
        child: ClipRect(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (
              Widget? currentChild,
              List<Widget> previousChildren,
            ) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ...previousChildren,
                  ?currentChild,
                ],
              );
            },
            transitionBuilder: (Widget child, Animation<double> animation) {
              final isIncoming = child.key == ValueKey<int>(_currentIndex);
              return SlideTransition(
                position: Tween<Offset>(
                  begin:
                      isIncoming
                          ? const Offset(0.0, 1.2)
                          : const Offset(0.0, -1.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: child,
                ),
              );
            },
            child: Row(
              key: ValueKey<int>(_currentIndex),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon ?? Icons.local_offer,
                  color: widget.textColor ?? context.colors.white,
                  size: widget.iconSize ?? 9.r,
                ),
                SizedBox(width: 3.w),
                CustomText(
                  text: currentPromo.displayDiscount,
                  color: widget.textColor ?? context.colors.white,
                  fontSize: widget.fontSize ?? 9.r,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
