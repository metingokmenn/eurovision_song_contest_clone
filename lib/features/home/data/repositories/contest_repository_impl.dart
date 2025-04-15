import 'package:eurovision_song_contest_clone/features/home/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';

class ContestRepositoryImpl implements ContestRepository {
  final ContestRemoteDataSource remoteDataSource;

  ContestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<int>> getContestYears() async {
    return await remoteDataSource.getContestYears();
  }

  @override
  Future<ContestModel> getContestByYear(int year) async {
    return await remoteDataSource.getContestByYear(year);
  }

  @override
  Future<List<int>> getJuniorContestYears() async {
    return await remoteDataSource.getJuniorContestYears();
  }

  @override
  Future<ContestModel> getJuniorContestByYear(int year) async {
    return await remoteDataSource.getJuniorContestByYear(year);
  }

  @override
  Future<String> convertCountryCodeToCountryName(String countryCode) async {
    return await remoteDataSource.convertCountryCodeToCountryName(countryCode);
  }
}
