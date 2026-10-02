import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/blocs/reels/reels_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/reels/reels_state.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/router/route_args.dart';
import 'bites_card.dart';

class BitesSection extends StatelessWidget {
  const BitesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsBloc, ReelsState>(
      builder: (context, state) {
        if (state.reels.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeaderWidget(
              title: 'Bites 🔥',
              tapLabel: 'Watch',
              subtitle: "Discover what everyone's eating",
              onTap: () {
                context.push(
                  RoutePaths.reelsViewer,
                  extra: ReelsViewerArgs(
                    reels: state.reels,
                  ),
                );
              },
            ).horizontal(16.w),
            SizedBox(height: 8.w),
            SizedBox(
              height: 184.w,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: state.reels.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final reel = state.reels[index];
                  return CustomItemAnimator(
                    index: index,
                    child: BitesCard(
                      reel: reel, 
                      onTap: () {
                        context.push(
                          RoutePaths.reelsViewer,
                          extra: ReelsViewerArgs(
                            reels: state.reels,
                            initialIndex: index,
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.w),
          ],
        );
      },
    );
  }
}
