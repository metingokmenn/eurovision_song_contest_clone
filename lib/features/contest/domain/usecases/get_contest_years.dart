import 'package:eurovision_song_contest_clone/features/contest/domain/repositories/contest_repository.dart';

class GetContestYears {
  final ContestRepository repository;

  GetContestYears(this.repository);

  Future<List<int>> call() async {
    return await repository.getContestYears();
  }
}
