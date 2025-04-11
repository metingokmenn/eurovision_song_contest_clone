import 'package:eurovision_song_contest_clone/features/contestant/data/models/contestant_model.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/repositories/contestant_repository.dart';

class GetContestantsByYear {
  final ContestantRepository repository;

  GetContestantsByYear(this.repository);

  Future<List<ContestantModel>> call(int year) async {
    return await repository.getContestantsByContestYear(year);
  }
}
