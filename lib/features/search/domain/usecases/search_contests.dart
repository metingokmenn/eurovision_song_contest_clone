import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';

class SearchContests {
  final SearchRepository repository;

  SearchContests(this.repository);

  Future<List<ContestModel>> call(String query) async {
    return await repository.searchContests(query);
  }
}
