import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/search/data/repositories/search_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/usecases/search_contests.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchDependencyInjection {
  static List<RepositoryProvider> getRepositoryProviders() {
    final client = http.Client();
    final remoteDataSource = SearchRemoteDataSource(client: client);
    final repository = SearchRepositoryImpl(remoteDataSource: remoteDataSource);

    return [
      RepositoryProvider<SearchRepository>(
        create: (context) => repository,
      ),
      RepositoryProvider<SearchContests>(
        create: (context) => SearchContests(repository),
      ),
    ];
  }
}
