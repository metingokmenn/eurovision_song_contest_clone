import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/repositories/contest_repository.dart';

class GetContestByYear {
  final ContestRepository repository;

  GetContestByYear(this.repository);

  Future<ContestModel> call(int year) async {
    return await repository.getContestByYear(year);
  }
}
