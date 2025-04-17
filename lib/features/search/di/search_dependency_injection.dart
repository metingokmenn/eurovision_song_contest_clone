import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_local_datasource.dart';
import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_remote_datasource.dart';
import 'package:eurovision_song_contest_clone/features/search/data/repositories/search_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/usecases/search_contests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SearchDependencyInjection {
  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<SearchRepository>(
        create: (context) {
          final appDataManager = context.read<AppDataManager>();
          return SearchRepositoryImpl(
            remoteDataSource: SearchRemoteDataSource(
              client: http.Client(),
            ),
            localDataSource: SearchLocalDataSource(
              appDataManager: appDataManager,
            ),
            useCacheOnly: false, // Set to true to only use cache
          );
        },
      ),
      RepositoryProvider<SearchContests>(
        create: (context) => SearchContests(
          context.read<SearchRepository>(),
        ),
      ),
    ];
  }

  /// Creates repository providers that only use cached data
  static List<RepositoryProvider> getCacheOnlyRepositoryProviders(
      AppDataManager appDataManager) {
    return [
      RepositoryProvider<SearchRepository>(
        create: (context) => SearchRepositoryImpl(
          remoteDataSource: SearchRemoteDataSource(
            client: http.Client(),
          ),
          localDataSource: SearchLocalDataSource(
            appDataManager: appDataManager,
          ),
          useCacheOnly: true,
        ),
      ),
      RepositoryProvider<SearchContests>(
        create: (context) => SearchContests(
          context.read<SearchRepository>(),
        ),
      ),
    ];
  }
}
