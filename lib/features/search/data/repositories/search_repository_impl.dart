import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_remote_datasource.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ContestModel>> searchContests(String query) async {
    return await remoteDataSource.searchContests(query);
  }
}
