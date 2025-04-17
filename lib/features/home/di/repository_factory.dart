import 'package:eurovision_song_contest_clone/core/api/api_service.dart';
import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';

import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_local_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/data/repositories/contest_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';
import 'package:http/http.dart' as http;

/// Factory for creating repositories with different configurations
class RepositoryFactory {
  /// Create a repository that tries local cache first, then falls back to remote
  static ContestRepository createRepository({
    AppDataManager? appDataManager,
    http.Client? httpClient,
    ApiService? apiService,
  }) {
    final client = httpClient ?? http.Client();
    final dataManager = appDataManager ?? AppDataManager();

    return ContestRepositoryImpl(
      remoteDataSource: ContestRemoteDataSource(client: client),
      localDataSource: ContestLocalDataSource(appDataManager: dataManager),
      useCacheOnly: false,
    );
  }

  /// Create a repository that only uses cache and never makes network requests
  static ContestRepository createCacheOnlyRepository({
    AppDataManager? appDataManager,
  }) {
    final dataManager = appDataManager ?? AppDataManager();

    return ContestRepositoryImpl(
      // We still need to provide a remote data source for the implementation,
      // but it will never be used in cache-only mode
      remoteDataSource: ContestRemoteDataSource(client: http.Client()),
      localDataSource: ContestLocalDataSource(appDataManager: dataManager),
      useCacheOnly: true,
    );
  }
}
