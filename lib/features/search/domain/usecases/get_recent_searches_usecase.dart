import '../../../../core/storage/recent_search_storage.dart';

class GetRecentSearchesUseCase {
  List<String> call() => RecentSearchStorage.getRecent();
}
