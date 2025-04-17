import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';

abstract class ContestRepository {
  Future<List<int>> getContestYears();
  Future<ContestModel> getContestByYear(int year);
  Future<List<dynamic>> getContestantsByYear(int year);
  Future<List<int>> getJuniorContestYears();
  Future<ContestModel> getJuniorContestByYear(int year);
  Future<String> convertCountryCodeToCountryName(String countryCode);

  /// Check if data for a specific year is available in cache
  bool isDataAvailableInCache(int year);
}
