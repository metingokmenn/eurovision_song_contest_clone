import 'package:eurovision_song_contest_clone/features/contest/domain/repositories/contest_repository.dart';

class GetJuniorContestYears {
  final ContestRepository repository;

  GetJuniorContestYears(this.repository);

  Future<List<int>> call() async {
    return await repository.getJuniorContestYears();
  }
}
