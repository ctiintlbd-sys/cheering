import 'package:cheering/core/common_widgets/striped_progress_painter.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/order_tracking_entity.dart';
import '../../helpers/tracking_status.dart';

class TrackingStatusHeader extends StatelessWidget {
  const TrackingStatusHeader({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.w),
        Center(
          child: tracking.rider != null
              ? Assets.icons.orderPlaced.svg(width: 280.w, height: 220.w)
              : Assets.images.preparing.image(width: 246.w, height: 182.w),
        ),
        SizedBox(height: 28.w),
        CustomText(
          text: TrackingStatus.title(tracking),
          fontSize: 24.r,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        if (tracking.rider == null) ...[
          SizedBox(height: 12.w),
          StripedProgressPainter(),
        ],
        SizedBox(height: 12.w),
        CustomText(
          text: TrackingStatus.subtitle(tracking),
          color: context.colors.textTertiary,
          textAlign: TextAlign.center,
        ),

        if (tracking.rider != null) ...[
          SizedBox(height: 28.w),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Track Rider',
                  fontSize: 14.r,
                  onPressed: () => context.push(
                    RoutePaths.orderTrackingMap,
                    extra: tracking,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  label: 'Back to home',
                  fontSize: 14.r,
                  backgroundColor: Colors.transparent,
                  textColor: context.colors.textPrimary,
                  bordersColor: context.colors.borderPrimary,
                  onPressed: () => context.go(RoutePaths.foodTab),
                ),
              ),
            ],
          ),
        ],

        SizedBox(height: 28.w),
      ],
    );
  }
}
