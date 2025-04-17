import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';

class ContestLocalDataSource {
  final AppDataManager _appDataManager;

  ContestLocalDataSource({AppDataManager? appDataManager})
      : _appDataManager = appDataManager ?? AppDataManager();

  Future<List<int>> getContestYears() async {
    final years = _appDataManager.contestYears;
    if (years != null && years.isNotEmpty) {
      return years;
    } else {
      throw Exception('Contest years not available in cache');
    }
  }

  Future<ContestModel> getContestByYear(int year) async {
    final contests = _appDataManager.contests;
    if (contests.containsKey(year)) {
      return contests[year]!;
    } else {
      throw Exception('Contest data for year $year not available in cache');
    }
  }

  Future<List<dynamic>> getContestantsByYear(int year) async {
    final contestants = _appDataManager.contestants;
    if (contestants.containsKey(year)) {
      return contestants[year]!;
    } else {
      throw Exception('Contestant data for year $year not available in cache');
    }
  }

  /// Check if data for a year is fully loaded in cache
  bool isYearDataLoaded(int year) {
    return _appDataManager.contests.containsKey(year) &&
        _appDataManager.contestants.containsKey(year);
  }

  /// Check if all years are available in cache
  bool get isAllYearsDataLoaded {
    final years = _appDataManager.contestYears;
    if (years == null || years.isEmpty) return false;

    // Check if all years have contest data
    for (final year in years) {
      if (!_appDataManager.contests.containsKey(year)) {
        return false;
      }
    }

    return true;
  }
}
