import 'package:eurovision_song_contest_clone/core/api/api_service.dart';
import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/data/repositories/contest_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';
import 'package:http/http.dart' as http;

/// Factory for creating repositories
class RepositoryFactory {
  /// Create a repository that uses remote data source
  static ContestRepository createRepository({
    http.Client? httpClient,
    ApiService? apiService,
  }) {
    final client = httpClient ?? http.Client();

    return ContestRepositoryImpl(
      remoteDataSource: ContestRemoteDataSource(client: client),
    );
  }
}
