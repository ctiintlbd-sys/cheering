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
          SizedBox(height: 14.h),
          CustomContainer(
            width: 54.w,
            height: 4.h,
            color: context.colors.textSecondary.withValues(alpha: 0.2),
            radiusAll: 4.r,
          ),

          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Category',
                  fontSize: 16.sp,
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
          SizedBox(height: 14.h),

          // Grid with BlocBuilder
          Expanded(
            child: BlocBuilder<HomeFeedBloc, HomeFeedState>(
              builder: (context, state) {
                if (state.isLoadingAllCategories) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.categoriesErrorMessage != null &&
                    (state.allCategories == null ||
                        state.allCategories!.isEmpty)) {
                  return Center(
                    child: Text(
                      state.categoriesErrorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  );
                }

                final categories = state.allCategories ?? [];

                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 44.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 24.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 74 / 90,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    
                    return CustomItemAnimator(
                      index: index,
                      animationType: CustomItemAnimationType.scale,
                      child:
                          const FoodCategoriesWidget(), // Pass category here later
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
