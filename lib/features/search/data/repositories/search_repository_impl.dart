import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_local_datasource.dart';
import 'package:eurovision_song_contest_clone/features/search/data/datasources/search_remote_datasource.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:flutter/material.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;
  final bool _useCacheOnly;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    bool useCacheOnly = false,
  }) : _useCacheOnly = useCacheOnly;

  @override
  Future<List<ContestModel>> searchContests(String query) async {
    try {
      // Try to search in cached data first
      if (localDataSource.hasSufficientCachedData()) {
        debugPrint('Searching contests in cache for query: $query');
        return await localDataSource.searchContests(query);
      }

      // If we're in cache-only mode, return empty list rather than using remote
      if (_useCacheOnly) {
        debugPrint('Cache-only mode, but insufficient cached data for search');
        return [];
      }

      // Fall back to remote search if cache doesn't have enough data
      debugPrint('Searching contests from API for query: $query');
      return await remoteDataSource.searchContests(query);
    } catch (e) {
      debugPrint('Error searching contests: $e');

      // If local search fails and we're in cache-only mode, return empty results
      if (_useCacheOnly) {
        return [];
      }

      // Otherwise, try remote search as a fallback
      try {
        return await remoteDataSource.searchContests(query);
      } catch (remoteError) {
        debugPrint('Remote search also failed: $remoteError');
        throw Exception('Failed to search contests: $remoteError');
      }
    }
  }

  @override
  bool hasEnoughCachedData() {
    return localDataSource.hasSufficientCachedData();
  }
}
