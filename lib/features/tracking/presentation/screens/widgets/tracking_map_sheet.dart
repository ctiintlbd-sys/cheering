import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/helpers/tracking_status.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_rider_card.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class TrackingMapSheet extends StatefulWidget {
  const TrackingMapSheet({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  State<TrackingMapSheet> createState() => _TrackingMapSheetState();
}

class _TrackingMapSheetState extends State<TrackingMapSheet> {
  final _sheetKey = GlobalKey();
  final _peekKey = GlobalKey();
  final _snap = ValueNotifier<_Snap?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void dispose() {
    _snap.dispose();
    super.dispose();
  }

  void _measure() {
    final sheet = _sheetKey.currentContext?.size?.height;
    final peek = _peekKey.currentContext?.size?.height;
    if (!mounted || sheet == null || peek == null) return;

    final screen = MediaQuery.sizeOf(context).height;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    if (screen <= 0) return;

    final max = (sheet / screen).clamp(0.2, 0.95);
    final min = ((peek + safeBottom) / screen).clamp(0.12, max);
    if (max - min < 0.04) return;

    final next = _Snap(min, max);
    if (_snap.value?.min == next.min && _snap.value?.max == next.max) return;
    _snap.value = next;
  }

  @override
  Widget build(BuildContext context) {
    final tracking = widget.tracking;
    final rider = tracking.rider;

    final sheet = CustomContainer(
      key: _sheetKey,
      color: context.colors.background,
      topLeftRadius: 24.r,
      topRightRadius: 24.r,
      paddingHorizontal: 20.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            key: _peekKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 14.w),
              CustomContainer(
                width: 36.w,
                height: 4.w,
                radiusAll: 99.r,
                color: context.colors.borderSecondary,
              ),
              SizedBox(height: 20.w),
              CustomText(
                text: TrackingStatus.title(tracking),
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              CustomText(
                top: 6.w,
                text: TrackingStatus.subtitle(tracking),
                color: context.colors.textTertiary,
                textAlign: TextAlign.center,
              ),
              if (rider != null) ...[
                SizedBox(height: 20.w),
                TrackingRiderCard(tracking: tracking),
              ],
              SizedBox(height: 12.w),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'My Order',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: 'Details',
                fontSize: 12.w,
                fontWeight: FontWeight.w500,
                color: context.colors.textTertiary,
              ),
            ],
          ),
          SizedBox(height: 16.w),
          TrackingTimeline(tracking: tracking),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 8.w),
        ],
      ),
    );

    return ValueListenableBuilder<_Snap?>(
      valueListenable: _snap,
      builder: (context, snap, child) {
        if (snap == null) return child!;
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          shouldCloseOnMinExtent: false,
          initialChildSize: snap.max,
          minChildSize: snap.min,
          maxChildSize: snap.max,
          builder: (context, controller) {
            return SingleChildScrollView(
              controller: controller,
              physics: const ClampingScrollPhysics(),
              child: child,
            );
          },
        );
      },
      child: sheet,
    );
  }
}

class _Snap {
  const _Snap(this.min, this.max);

  final double min;
  final double max;
}
