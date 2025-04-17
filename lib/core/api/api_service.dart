import 'package:eurovision_song_contest_clone/core/api/api_client.dart';

import '../../features/home/data/models/contest_model.dart';
import '../../features/home/data/models/contestant_model.dart';
import '../../features/home/data/models/performance_model.dart';

abstract class ApiService {
  Future<List<int>> getContestYears();
  Future<ContestModel> getContestByYear(int year);
  Future<List<ContestantModel>> getContestantsByYear(int year);
  Future<List<PerformanceModel>> getVotingResultsByYear(int year);
  Future<List<Map<String, dynamic>>> getFeaturedContent();
  Future<List<ContestModel>> searchContests(String query);
}

class ApiServiceImpl implements ApiService {
  final ApiClient _apiClient;

  ApiServiceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get all contest years
  Future<List<int>> getContestYears() async {
    try {
      final response = await _apiClient.get('/contests/years');
      return List<int>.from(response);
    } catch (e) {
      throw Exception('Failed to load contest years: $e');
    }
  }

  /// Get details for a specific contest year
  Future<ContestModel> getContestByYear(int year) async {
    try {
      final response = await _apiClient.get('/contests/$year');
      return ContestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load contest for year $year: $e');
    }
  }

  /// Get contestants for a specific contest year
  Future<List<ContestantModel>> getContestantsByYear(int year) async {
    try {
      // The contest details already include contestant references
      // We need to get the full list from the contest endpoint
      final contestResponse = await _apiClient.get('/contests/$year');

      // Extract contestants from the contest response
      if (contestResponse.containsKey('contestants') &&
          contestResponse['contestants'] is List) {
        return List<ContestantModel>.from(contestResponse['contestants']
            .map((json) => ContestantModel.fromJson(json)));
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load contestants for year $year: $e');
    }
  }

  /// Get voting results for a specific contest year
  Future<List<PerformanceModel>> getVotingResultsByYear(int year) async {
    try {
      // The voting results are included in the rounds data within contest details
      final contestResponse = await _apiClient.get('/contests/$year');

      if (contestResponse.containsKey('rounds') &&
          contestResponse['rounds'] is List) {
        return List<PerformanceModel>.from(contestResponse['rounds']
            .map((json) => PerformanceModel.fromJson(json)));
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load voting results for year $year: $e');
    }
  }

  /// Get featured content for the app
  Future<List<Map<String, dynamic>>> getFeaturedContent() async {
    try {
      final response = await _apiClient.get('/featured');
      return response;
    } catch (e) {
      throw Exception('Failed to load featured content: $e');
    }
  }

  /// Search for contests
  Future<List<ContestModel>> searchContests(String query) async {
    try {
      final response = await _apiClient.get('/search/contests?query=$query');
      return (response as List)
          .map((json) => ContestModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search contests: $e');
    }
  }
}
