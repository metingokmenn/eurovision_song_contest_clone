import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/contestant/data/models/contestant_model.dart';

abstract class SearchRepository {
  Future<List<ContestModel>> searchContests(String query);
  
}
