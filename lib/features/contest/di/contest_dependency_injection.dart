import 'package:eurovision_song_contest_clone/features/contest/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/contest/data/repositories/contest_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/repositories/contest_repository.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/usecases/get_contest_by_year.dart';
import 'package:http/http.dart' as http;

class ContestDependencyInjection {
  static void setup() {
    // Data sources
    final remoteDataSource = ContestRemoteDataSource(client: http.Client());

    // Repositories
    final repository =
        ContestRepositoryImpl(remoteDataSource: remoteDataSource);

    // Use cases
    final getContestByYear = GetContestByYear(repository);
  }
}
