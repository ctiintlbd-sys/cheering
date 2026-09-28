import '../../../../core/storage/recent_search_storage.dart';

class SaveRecentSearchUseCase {
  Future<void> call(String query) => RecentSearchStorage.save(query);
}
