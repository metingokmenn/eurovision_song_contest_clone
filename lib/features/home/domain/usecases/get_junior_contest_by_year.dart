import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/repositories/contest_repository.dart';

class GetJuniorContestByYear {
  final ContestRepository repository;

  GetJuniorContestByYear(this.repository);

  Future<ContestModel> call(int year) async {
    return await repository.getJuniorContestByYear(year);
  }
}
