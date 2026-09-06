import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/features/community/domain/entities/community_post.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityPostCard extends StatefulWidget {
  final CommunityPost post;

  const CommunityPostCard({super.key, required this.post});

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Author Header ───────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              CustomNetworkImage(
                imageUrl: widget.post.authorAvatar,
                height: 40.r,
                width: 40.r,
                boxShape: BoxShape.circle,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.post.authorName,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                    CustomText(
                      text:
                          '${widget.post.timeAgo} • ${widget.post.authorLocation}',
                      fontSize: 12.sp,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: context.colors.iconSecondary,
                  size: 24.r,
                ),
              ),
            ],
          ),
        ),

        // ── Main Post Image ─────────────────────────────────────────
        AspectRatio(
          aspectRatio: 1.0,
          child: CustomNetworkImage(imageUrl: widget.post.postImageUrl),
        ),

        // ── Actions Row ─────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Like
              GestureDetector(
                onTap: () => setState(() => _isLiked = !_isLiked),
                child: Assets.icons.love.svg(
                  width: 24.r,
                  height: 24.r,
                  colorFilter: _isLiked
                      ? null
                      : ColorFilter.mode(
                          context.colors.textPrimary,
                          BlendMode.srcIn,
                        ),
                ),
              ),
              SizedBox(width: 16.w),

              // Comment
              Assets.icons.comment.svg(
                width: 22.r,
                height: 22.r,
                colorFilter: ColorFilter.mode(
                  context.colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 16.w),

              // Share / Reply
              Assets.icons.share.svg(
                width: 22.r,
                height: 22.r,
                colorFilter: ColorFilter.mode(
                  context.colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),

              const Spacer(),

              // Page Dots Indicator (Figma design: 3 dots)
              Row(
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2146E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              Spacer(flex: 2),

              // Bookmark / Save
              Assets.icons.bookmark.svg(
                width: 22.r,
                height: 22.r,
                colorFilter: ColorFilter.mode(
                  context.colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),

        // ── Loved by / Likes summary ─────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              CustomNetworkImage(
                height: 18.r,
                width: 18.r,
                imageUrl: '',
                boxShape: BoxShape.circle,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: context.colors.textPrimary,
                      fontFamily: FontFamily.sFPro,
                    ),
                    children: [
                      const TextSpan(text: 'Loved by '),
                      TextSpan(
                        text: widget.post.lovedByName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: widget.post.lovedByCountText,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 6.h),

        // ── Caption ─────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: widget.post.caption,
            color: context.colors.textSecondary,
            textAlign: TextAlign.start,
            maxLines: 3,
          ),
        ),

        SizedBox(height: 20.h),
      ],
    );
  }
}
