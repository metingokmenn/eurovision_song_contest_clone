import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/home/di/repository_factory.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';

/// Use case to get contest data from cache only
class GetCachedContestByYear {
  final AppDataManager _appDataManager;
  late final ContestRepository _cacheOnlyRepository;

  GetCachedContestByYear(this._appDataManager) {
    // Create a cache-only repository
    _cacheOnlyRepository = RepositoryFactory.createCacheOnlyRepository(
      appDataManager: _appDataManager,
    );
  }

  /// Get a contest by year - will only use cached data and never make network requests
  Future<ContestModel> call(int year) async {
    try {
      return await _cacheOnlyRepository.getContestByYear(year);
    } catch (e) {
      throw Exception('Contest data for year $year not available in cache: $e');
    }
  }

  /// Check if data for a year is available in cache
  bool isDataAvailable(int year) {
    return _cacheOnlyRepository.isDataAvailableInCache(year);
  }
}
