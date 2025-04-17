import 'package:http/http.dart' as http;

import '../api/api_repository.dart';
import '../api/api_service.dart';
import '../api/connectivity_service.dart';
import '../api/mock_api_service.dart';
import '../api/remote_api_service.dart';

/// A simple dependency injection container
class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();

  factory ServiceProvider() => _instance;

  ServiceProvider._internal();

  // Lazy singletons
  ConnectivityService? _connectivityService;
  ApiService? _apiService;

  ConnectivityService get connectivityService {
    _connectivityService ??= ConnectivityService();
    return _connectivityService!;
  }

  ApiService get apiService {
    _apiService ??= ApiRepository(
      connectivityService: connectivityService,
      remoteApiService: RemoteApiService(client: http.Client()),
      mockApiService: MockApiService(),
    );
    return _apiService!;
  }

  // Clean up resources
  void dispose() {
    _connectivityService?.dispose();
  }
}
