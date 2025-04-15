import 'package:eurovision_song_contest_clone/features/home/data/models/contestant_model.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contestant_repository.dart';

class GetContestantByYear {
  final ContestantRepository repository;

  GetContestantByYear(this.repository);

  Future<ContestantModel> call(int year, int id) async {
    return await repository.getContestantByContestYear(year, id);
  }
}
