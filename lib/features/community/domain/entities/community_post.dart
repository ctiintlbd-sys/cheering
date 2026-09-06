class StoryItem {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isUserStory;
  final bool isOnline;

  const StoryItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isUserStory = false,
    this.isOnline = false,
  });
}

class CommunityPost {
  final String id;
  final String authorName;
  final String authorLocation;
  final String authorAvatar;
  final String timeAgo;
  final String postImageUrl;
  final String lovedByName;
  final String lovedByCountText;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.authorAvatar,
    required this.timeAgo,
    required this.postImageUrl,
    required this.lovedByName,
    required this.lovedByCountText,
    required this.caption,
    this.likesCount = 12686,
    this.commentsCount = 142,
    this.isLiked = true,
  });
}
