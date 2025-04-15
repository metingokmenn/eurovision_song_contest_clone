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
        create: (context) => SearchRepositoryImpl(
          remoteDataSource: SearchRemoteDataSource(
            client: http.Client(),
          ),
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
