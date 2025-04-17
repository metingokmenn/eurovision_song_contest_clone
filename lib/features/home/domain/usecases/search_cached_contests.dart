import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:flutter/material.dart';

/// Search for contests within cached data, without making network requests
class SearchCachedContests {
  final AppDataManager _appDataManager;

  SearchCachedContests(this._appDataManager);

  /// Search for contests within cached data based on a query string
  List<ContestModel> call(String query) {
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
      // Check for matches in various fields
      final yearMatch = contest.year.toString().contains(queryLower);
      final cityMatch =
          contest.city?.toLowerCase().contains(queryLower) ?? false;
      final arenaMatch =
          contest.arena?.toLowerCase().contains(queryLower) ?? false;
      final countryMatch =
          contest.country?.toLowerCase().contains(queryLower) ?? false;
      final sloganMatch =
          contest.slogan?.toLowerCase().contains(queryLower) ?? false;

      // If any field matches, add to results
      if (yearMatch || cityMatch || arenaMatch || countryMatch || sloganMatch) {
        results.add(contest);
      }

      // Also search in presenters
      if (contest.presenters != null) {
        for (final presenter in contest.presenters!) {
          if (presenter.toLowerCase().contains(queryLower)) {
            results.add(contest);
            break;
          }
        }
      }
    }

    // Sort by year (newest first)
    results.sort((a, b) => b.year.compareTo(a.year));

    debugPrint('Found ${results.length} cached contests matching "$query"');
    return results;
  }

  /// Check if there's enough data in cache to search effectively
  bool hasSufficientCachedData() {
    return _appDataManager.contests.isNotEmpty;
  }
}
