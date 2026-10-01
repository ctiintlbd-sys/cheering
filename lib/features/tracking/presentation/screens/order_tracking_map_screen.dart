import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/helpers/tracking_map_overlay.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_map_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  const OrderTrackingMapScreen({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  State<OrderTrackingMapScreen> createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen> {
  final _overlay = ValueNotifier(const TrackingMapOverlay());
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadOverlay();
  }

  @override
  void dispose() {
    _overlay.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadOverlay() async {
    try {
      final overlay = await TrackingMapOverlay.build(tracking: widget.tracking);
      if (!mounted) return;
      _overlay.value = overlay;
      _fitRoute();
    } catch (error, stackTrace) {
      debugPrint('Tracking overlay failed: $error\n$stackTrace');
    }
  }

  void _fitRoute() {
    final update = TrackingMapGeometry.cameraUpdateOf(widget.tracking);
    if (update == null) return;
    _mapController?.animateCamera(update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      bottomSheet: TrackingMapSheet(tracking: widget.tracking),
      body: ValueListenableBuilder<TrackingMapOverlay>(
        valueListenable: _overlay,
        builder: (context, overlay, _) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: TrackingMapGeometry.initialTargetOf(widget.tracking),
                  zoom: TrackingMapGeometry.initialZoom,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _fitRoute();
                },
                markers: overlay.markers,
               // polylines: overlay.polylines,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                padding: EdgeInsets.only(bottom: 360.h),
              ),

              Positioned(
                top: kToolbarHeight,
                left: 16.w,
                child: CommonActionIcon(
                  icon: Assets.icons.arrowBack.path,
                  onTap: () => context.pop(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
