import 'dart:io';

import '../../features/home/data/models/contest_model.dart';
import '../../features/home/data/models/contestant_model.dart';
import '../../features/home/data/models/performance_model.dart';
import 'api_service.dart';
import 'connectivity_service.dart';
import 'mock_api_service.dart';
import 'remote_api_service.dart';

class ApiRepository implements ApiService {
  final ConnectivityService _connectivityService;
  final RemoteApiService _remoteApiService;
  final MockApiService _mockApiService;

  ApiRepository({
    ConnectivityService? connectivityService,
    RemoteApiService? remoteApiService,
    MockApiService? mockApiService,
  })  : _connectivityService = connectivityService ?? ConnectivityService(),
        _remoteApiService = remoteApiService ?? RemoteApiService(),
        _mockApiService = mockApiService ?? MockApiService();

  /// Helper method to determine which API service to use
  Future<T> _safeApiCall<T>(
      Future<T> Function(ApiService service) apiCall) async {
    try {
      // Check if we have internet connection
      final bool isConnected = await _connectivityService.checkConnection();

      if (isConnected) {
        // Use remote API if connected
        return await apiCall(_remoteApiService);
      } else {
        // Use mock API if offline
        // Could log or notify user here about using offline mode
        return await apiCall(_mockApiService);
      }
    } on SocketException catch (_) {
      // Network error - fallback to mock data
      return await apiCall(_mockApiService);
    } catch (e) {
      // For any other errors, try to use mock data
      return await apiCall(_mockApiService);
    }
  }

  @override
  Future<List<int>> getContestYears() {
    return _safeApiCall((service) => service.getContestYears());
  }

  @override
  Future<ContestModel> getContestByYear(int year) {
    return _safeApiCall((service) => service.getContestByYear(year));
  }

  @override
  Future<List<ContestantModel>> getContestantsByYear(int year) {
    return _safeApiCall((service) => service.getContestantsByYear(year));
  }

  @override
  Future<List<PerformanceModel>> getVotingResultsByYear(int year) {
    return _safeApiCall((service) => service.getVotingResultsByYear(year));
  }

  @override
  Future<List<Map<String, dynamic>>> getFeaturedContent() {
    return _safeApiCall((service) => service.getFeaturedContent());
  }

  @override
  Future<List<ContestModel>> searchContests(String query) {
    return _safeApiCall((service) => service.searchContests(query));
  }
}
