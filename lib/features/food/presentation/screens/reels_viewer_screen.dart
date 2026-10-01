import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';

import 'package:cheering/features/food/presentation/screens/widgets/reel_item_view.dart';

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
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            cacheExtent: MediaQuery.of(context).size.height, // age-pore 1 ta page build hobe
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => ReelItemView(
              key: ValueKey(widget.reels[index].id),
              reel: widget.reels[index],
              isActive: index == _currentIndex,
            ),
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

