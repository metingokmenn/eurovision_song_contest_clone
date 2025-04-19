import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_remote_datasource.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:flutter/material.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<ContestModel>> searchContests(String query) async {
    try {
      debugPrint('Searching contests from API for query: $query');
      return await remoteDataSource.searchContests(query);
    } catch (e) {
      debugPrint('Error searching contests: $e');
      throw Exception('Failed to search contests: $e');
    }
  }
}
