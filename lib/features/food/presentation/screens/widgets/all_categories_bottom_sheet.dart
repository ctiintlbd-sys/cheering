import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/presentation/screens/widgets/food_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/home_feed/home_feed_bloc.dart';
import '../../blocs/home_feed/home_feed_state.dart';

class AllCategoriesBottomSheet extends StatelessWidget {
  const AllCategoriesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: MediaQuery.of(context).size.height * 0.64,
      color: context.colors.background,
      topLeftRadius: 24.r,
      topRightRadius: 24.r,
      child: Column(
        children: [
          SizedBox(height: 14.w),
          CustomContainer(
            width: 54.w,
            height: 4.w,
            color: context.colors.textSecondary.withValues(alpha: 0.2),
            radiusAll: 4.r,
          ),

          SizedBox(height: 12.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Category',
                  fontSize: 16.r,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  onTap: () => Navigator.pop(context),
                  text: 'Close',
                  fontWeight: FontWeight.w500,
                  color: context.colors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 14.w),

          // Grid with BlocBuilder
          Expanded(
            child: BlocBuilder<HomeFeedBloc, HomeFeedState>(
              buildWhen: (previous, current) =>
                  previous.allCategories != current.allCategories ||
                  previous.status != current.status ||
                  previous.errorMessage != current.errorMessage,
              builder: (context, state) {
                if (state.status == HomeFeedStatus.failure &&
                    (state.allCategories == null ||
                        state.allCategories!.isEmpty)) {
                  return Center(
                    child: CustomText(
                      text: state.errorMessage ?? 'Failed to load categories',
                    ),
                  );
                }
                final categories = state.allCategories ?? [];

                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 44.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 24.w,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 74 / 90,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CustomItemAnimator(
                      index: index,
                      animationType: CustomItemAnimationType.scale,
                      child: FoodCategoriesWidget(category: categories[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
