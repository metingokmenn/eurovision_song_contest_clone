import 'package:eurovision_song_contest_clone/features/home/data/models/contestant_model.dart';

abstract class ContestantRepository {
  Future<ContestantModel> getContestantByContestYear(int year, int id);
  Future<List<ContestantModel>> getContestantsByContestYear(int year);
}
