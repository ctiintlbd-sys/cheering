import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/reel_item_view.dart';
import 'package:cheering/features/food/presentation/helpers/reels_video_controller_manager.dart';

class ReelsViewerScreen extends StatefulWidget {
  final List<ReelEntity> reels;
  final int initialIndex;

  const ReelsViewerScreen({
    super.key,
    required this.reels,
    this.initialIndex = 0,
  });

  @override
  State<ReelsViewerScreen> createState() => _ReelsViewerScreenState();
}

class _ReelsViewerScreenState extends State<ReelsViewerScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);
    _pageController = PageController(initialPage: widget.initialIndex);

    // Silently pre-initialize the next reel in background
    _preloadNext(widget.initialIndex);
  }

  void _preloadNext(int index) {
    if (index + 1 < widget.reels.length) {
      ReelsVideoControllerManager.instance.preload(widget.reels[index + 1].videoUrl);
    }
  }

  @override
  void dispose() {
    // When leaving ReelsViewerScreen, mute the active reel so BitesCard doesn't blast audio
    if (widget.reels.isNotEmpty &&
        _currentIndexNotifier.value < widget.reels.length) {
      final activeUrl = widget.reels[_currentIndexNotifier.value].videoUrl;
      final c = ReelsVideoControllerManager.instance.getController(activeUrl);
      c?.setVolume(0.0);
    }
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.reels.length,
            allowImplicitScrolling: false,
            onPageChanged: (index) {
              _currentIndexNotifier.value = index;
              _preloadNext(index);
            },
            itemBuilder: (context, index) {
              return ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (context, currentIndex, _) {
                  return ReelItemView(
                    key: ValueKey(widget.reels[index].id),
                    reel: widget.reels[index],
                    isActive: index == currentIndex,
                  );
                },
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            child: CommonActionIcon(
              onTap: () => context.pop(),
              icon: Assets.icons.arrowBack.path,
            ),
          ),
        ],
      ),
    );
  }
}
