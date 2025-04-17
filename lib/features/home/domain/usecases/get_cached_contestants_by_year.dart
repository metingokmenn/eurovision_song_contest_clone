import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
import 'package:eurovision_song_contest_clone/features/home/di/repository_factory.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';

/// Use case to get contestants data from cache only
class GetCachedContestantsByYear {
  final AppDataManager _appDataManager;
  late final ContestRepository _cacheOnlyRepository;

  GetCachedContestantsByYear(this._appDataManager) {
    // Create a cache-only repository
    _cacheOnlyRepository = RepositoryFactory.createCacheOnlyRepository(
      appDataManager: _appDataManager,
    );
  }

  /// Get contestants by year - will only use cached data and never make network requests
  Future<List<dynamic>> call(int year) async {
    try {
      return await _cacheOnlyRepository.getContestantsByYear(year);
    } catch (e) {
      throw Exception(
          'Contestants data for year $year not available in cache: $e');
    }
  }
}
