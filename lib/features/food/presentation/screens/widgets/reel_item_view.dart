import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';
import 'package:cheering/core/router/route_paths.dart';

class ReelItemView extends StatefulWidget {
  final ReelEntity reel;
  final bool isActive;

  const ReelItemView({super.key, required this.reel, this.isActive = false});

  @override
  State<ReelItemView> createState() => _ReelItemViewState();
}

class _ReelItemViewState extends State<ReelItemView> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _initialized = true;
              });
              _controller.setLooping(true);
              if (widget.isActive) {
                _controller.play();
              }
            }
          });
  }

  @override
  void didUpdateWidget(ReelItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      if (widget.isActive && !oldWidget.isActive) {
        _controller.play();
      } else if (!widget.isActive && oldWidget.isActive) {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.reel.thumbnailUrl?.isNotEmpty == true
        ? widget.reel.thumbnailUrl!
        : (widget.reel.restaurant.logoUrl ??
              widget.reel.restaurant.coverImageUrl ??
              '');

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_initialized)
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        else
          CustomNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 10.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: widget.reel.restaurant.name,
                      color: context.colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                    ),
                  ),
                  CustomContainer(
                    radiusAll: 10.r,
                    paddingVertical: 6.w,
                    paddingHorizontal: 10.w,
                    color: context.colors.white,
                    onTap: () {
                      context.push(
                        RoutePaths.storeDetails(widget.reel.restaurant.id),
                      );
                    },
                    child: CustomText(
                      text: 'View',
                      color: context.colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              if (_initialized)
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: context.colors.white,
                    bufferedColor: context.colors.white.withValues(alpha: 0.3),
                    backgroundColor: context.colors.white.withValues(alpha: 0.5),
                  ),
                ),
              SizedBox(height: 12.h),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.white,
                    fontFamily: FontFamily.sFPro
                  ),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star,
                        color: context.colors.ratingColor,
                        size: 12.r,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${widget.reel.restaurant.ratingAvg} (${widget.reel.restaurant.ratingCount})  •  ',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.access_time,
                        color: context.colors.white,
                        size: 12.r,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${widget.reel.restaurant.avgPrepTimeMins} mins  •  ',
                    ),
                    TextSpan(
                      text:
                          '${widget.reel.restaurant.distanceKm > 0 ? (widget.reel.restaurant.distanceKm % 1 == 0 ? widget.reel.restaurant.distanceKm.toInt() : widget.reel.restaurant.distanceKm.toStringAsFixed(1)) : widget.reel.restaurant.distanceKm}Km',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
