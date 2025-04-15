import 'package:eurovision_song_contest_clone/features/home/data/datasources/contestant_remote_data_source.dart';

import '../models/contestant_model.dart';
import '../../domain/repositories/contestant_repository.dart';

class ContestantRepositoryImpl implements ContestantRepository {
  final ContestantRemoteDataSource remoteDataSource;

  ContestantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ContestantModel> getContestantByContestYear(int year, int id) async {
    return await remoteDataSource.getContestantByContestYear(year, id);
  }

  @override
  Future<List<ContestantModel>> getContestantsByContestYear(int year) async {
    return await remoteDataSource.getContestantsByContestYear(year);
  }
}
