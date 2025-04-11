import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';

abstract class ContestRepository {
  Future<List<int>> getContestYears();
  Future<ContestModel> getContestByYear(int year);
  Future<List<int>> getJuniorContestYears();
  Future<ContestModel> getJuniorContestByYear(int year);
}
