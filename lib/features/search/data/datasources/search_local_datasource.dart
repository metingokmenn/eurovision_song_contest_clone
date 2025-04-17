import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:flutter/material.dart';

class SearchLocalDataSource {
  final AppDataManager _appDataManager;

  SearchLocalDataSource({
    required AppDataManager appDataManager,
  }) : _appDataManager = appDataManager;

  /// Search for contests in cached data based on the query
  Future<List<ContestModel>> searchContests(String query) async {
    final queryLower = query.toLowerCase();
    final results = <ContestModel>[];

    // Get all cached contests
    final cachedContests = _appDataManager.contests;
    if (cachedContests.isEmpty) {
      debugPrint('No cached contest data available for searching');
      return [];
    }

    // Search through all cached contests
    for (final contest in cachedContests.values) {
      bool isMatch = false;

      // Check for matches in various fields
      if (contest.year.toString().contains(queryLower)) {
        isMatch = true;
      } else if (contest.city?.toLowerCase().contains(queryLower) ?? false) {
        isMatch = true;
      } else if (contest.arena?.toLowerCase().contains(queryLower) ?? false) {
        isMatch = true;
      } else if (contest.country?.toLowerCase().contains(queryLower) ?? false) {
        isMatch = true;
      } else if (contest.slogan?.toLowerCase().contains(queryLower) ?? false) {
        isMatch = true;
      }

      // Also search in presenters
      if (!isMatch && contest.presenters != null) {
        for (final presenter in contest.presenters!) {
          if (presenter.toLowerCase().contains(queryLower)) {
            isMatch = true;
            break;
          }
        }
      }

      // Add to results if any field matches
      if (isMatch) {
        results.add(contest);
      }
    }

    // Sort by year (newest first)
    results.sort((a, b) => b.year.compareTo(a.year));

    debugPrint('Found ${results.length} cached contests matching "$query"');
    return results;
  }

  /// Check if there is enough cached data to perform a search
  bool hasSufficientCachedData() {
    return _appDataManager.contests.isNotEmpty;
  }
}
