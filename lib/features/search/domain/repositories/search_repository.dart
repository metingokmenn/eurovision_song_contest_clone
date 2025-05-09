import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';

abstract class SearchRepository {
  Future<List<ContestModel>> searchContests(String query);
}
