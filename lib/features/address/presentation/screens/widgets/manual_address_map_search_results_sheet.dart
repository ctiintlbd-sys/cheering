import '../../../domain/entities/map_location_entities.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme_colors.dart';

class ManualAddressMapSearchResultsSheet extends StatelessWidget {
  const ManualAddressMapSearchResultsSheet({
    super.key,
    required this.loading,
    required this.results,
    required this.onResultTap,
  });

  final bool loading;
  final List<MapSearchResult> results;
  final ValueChanged<MapSearchResult> onResultTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      radiusAll: 16.r,
      paddingVertical: 8.w,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      child: loading && results.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20.w),
              child: Center(
                child: SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(context.colors.primary),
                  ),
                ),
              ),
            )
          : results.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: CustomText(
                text:
                    'No places found. Try adding area and city, e.g. Dhanmondi, Dhaka',
                fontSize: 14.r,
                color: context.colors.textSecondary,
                maxLines: 3,
              ),
            )
          : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 240.w),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: results.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: context.colors.bgSecondary),
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onResultTap(result),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20.r,
                              color: context.colors.textSecondary,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: result.formattedAddress,
                                    fontSize: 15.r,
                                    fontWeight: FontWeight.w500,
                                    maxLines: 2,
                                  ),
                                  if (result.area.isNotEmpty) ...[
                                    SizedBox(height: 2.w),
                                    CustomText(
                                      text: result.area,
                                      fontSize: 13.r,
                                      color: context.colors.textSecondary,
                                      maxLines: 1,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
