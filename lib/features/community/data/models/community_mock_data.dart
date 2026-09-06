import 'package:cheering/features/community/domain/entities/community_post.dart';

final mockStoryItems = [
  const StoryItem(
    id: 'story_user',
    name: 'Your Story',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop',
    isUserStory: true,
  ),
  const StoryItem(
    id: 'story_1',
    name: 'Bake Fiest...',
    avatarUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=256&auto=format&fit=crop',
    isOnline: true,
  ),
  const StoryItem(
    id: 'story_2',
    name: 'Rasel',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=256&auto=format&fit=crop',
    isOnline: true,
  ),
  const StoryItem(
    id: 'story_3',
    name: 'Mim',
    avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=256&auto=format&fit=crop',
    isOnline: false,
  ),
  const StoryItem(
    id: 'story_4',
    name: 'Ahmad',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=256&auto=format&fit=crop',
    isOnline: true,
  ),
];

final mockFigmaCommunityPosts = [
  const CommunityPost(
    id: 'figma_post_1',
    authorName: 'Bake Fiesta - Baridhara',
    authorLocation: 'Dhaka',
    authorAvatar: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=256&auto=format&fit=crop',
    timeAgo: '2h ago',
    postImageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=1000&auto=format&fit=crop',
    lovedByName: 'Bake House',
    lovedByCountText: '12,686 other',
    caption: 'Got 20% cashback on my grocery shopping today from Local Mart! 🛒💖',
    likesCount: 12686,
    commentsCount: 142,
    isLiked: true,
  ),
  const CommunityPost(
    id: 'figma_post_2',
    authorName: 'Local Mart Official',
    authorLocation: 'Gulshan, Dhaka',
    authorAvatar: 'https://images.unsplash.com/photo-1534723452862-4c874018d66d?q=80&w=256&auto=format&fit=crop',
    timeAgo: '4h ago',
    postImageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000&auto=format&fit=crop',
    lovedByName: 'Rasel',
    lovedByCountText: '8,420 other',
    caption: 'Fresh bakery items and organic fruits available now at discounted rates! 🥐🍇',
    likesCount: 8420,
    commentsCount: 89,
    isLiked: false,
  ),
];
