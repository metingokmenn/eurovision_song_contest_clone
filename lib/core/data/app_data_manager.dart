import 'dart:convert';

import 'package:eurovision_song_contest_clone/core/api/api_service.dart';
import 'package:eurovision_song_contest_clone/core/di/service_provider.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataManager {
  ApiService? _apiService;
  late SharedPreferences _prefs;

  List<int>? _contestYears;
  Map<int, ContestModel> _contests = {};
  Map<int, List<dynamic>> _contestants = {};
  dynamic _featuredContent;
  dynamic _userProfile;

  bool _isLoadingComplete = false;
  bool get isLoadingComplete => _isLoadingComplete;
  bool _isInitializing = false;
  int _totalYearsToLoad = 0;
  int _yearsLoaded = 0;

  List<int>? get contestYears => _contestYears;
  Map<int, ContestModel> get contests => _contests;
  Map<int, List<dynamic>> get contestants => _contestants;
  dynamic get featuredContent => _featuredContent;
  dynamic get userProfile => _userProfile;

  static final AppDataManager _instance = AppDataManager._internal();

  factory AppDataManager({ApiService? apiService}) {
    if (apiService != null) {
      _instance._apiService = apiService;
    }
    return _instance;
  }

  AppDataManager._internal();

  Future<void> initialize() async {
    if (_isInitializing) return;
    _isInitializing = true;

    _prefs = await SharedPreferences.getInstance();

    // Initialize API service if not already set
    _apiService ??= ServiceProvider().apiService;

    _loadCachedData();

    _isInitializing = false;
  }

  Future<void> loadInitialData() async {
    if (_isLoadingComplete) return;

    try {
      await loadContestYearsData();

      if (_contestYears != null && _contestYears!.isNotEmpty) {
        final latestYear =
            _contestYears!.reduce((curr, next) => curr > next ? curr : next);
        await loadContestData(latestYear);

        _yearsLoaded++;

        _loadAllContestData();
      } else {
        _isLoadingComplete = true;
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      _isLoadingComplete = true;
    }
  }

  Future<void> _loadAllContestData() async {
    if (_contestYears == null || _contestYears!.isEmpty) {
      _isLoadingComplete = true;
      return;
    }

    final latestYear =
        _contestYears!.reduce((curr, next) => curr > next ? curr : next);
    final yearsToLoad =
        _contestYears!.where((year) => year != latestYear).toList();

    _totalYearsToLoad = _contestYears!.length;

    final recentYears = yearsToLoad.length > 10
        ? yearsToLoad.sublist(yearsToLoad.length - 10)
        : yearsToLoad;

    final batchSize = 3;
    for (var i = 0; i < recentYears.length; i += batchSize) {
      final end = (i + batchSize < recentYears.length)
          ? i + batchSize
          : recentYears.length;
      final batch = recentYears.sublist(i, end);

      await Future.wait(batch.map((year) => _loadYearData(year)));

      if (end < recentYears.length) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    _isLoadingComplete = true;
    debugPrint('Completed loading data for ${_yearsLoaded} years');
  }

  Future<void> _loadYearData(int year) async {
    try {
      await loadContestData(year);
      _yearsLoaded++;
    } catch (e) {
      debugPrint('Error loading data for year $year: $e');
    }
  }

  Future<void> loadContestData(int year) async {
    try {
      if (_contests.containsKey(year)) {
        return;
      }

      final contest = await _apiService!.getContestByYear(year);

      _contests[year] = contest;

      await loadContestantsData(year);

      _cacheData();
    } catch (e) {
      debugPrint('Error loading contest data for year $year: $e');
    }
  }

  Future<void> loadContestantsData(int year) async {
    try {
      if (_contestants.containsKey(year)) {
        return;
      }

      final contestants = await _apiService!.getContestantsByYear(year);

      _contestants[year] = contestants;

      _cacheData();
    } catch (e) {
      debugPrint('Error loading contestants data for year $year: $e');
    }
  }

  Future<void> loadContestYearsData() async {
    try {
      if (_contestYears != null && _contestYears!.isNotEmpty) {
        return;
      }

      final contestYears = await _apiService!.getContestYears();

      _contestYears = contestYears;
      _cacheData();
    } catch (e) {
      debugPrint('Error loading contest years data: $e');
    }
  }

  /// Get cached contest years
  Future<List<int>> getContestYears() async {
    if (_contestYears != null && _contestYears!.isNotEmpty) {
      return List<int>.from(_contestYears!);
    }

    // Return some default years if no years are cached
    // This prevents issues with empty lists when offline
    return List.generate(10, (index) => 2024 - index);
  }

  void _loadCachedData() {
    try {
      final cachedYears = _prefs.getString('contestYears');
      if (cachedYears != null) {
        final List<dynamic> yearsList = jsonDecode(cachedYears);
        _contestYears = yearsList.map((year) => year as int).toList();
        debugPrint('Loaded ${_contestYears!.length} contest years from cache');
      }

      final cachedContests = _prefs.getString('contests');
      if (cachedContests != null) {
        final Map<String, dynamic> contestsMap = jsonDecode(cachedContests);
        contestsMap.forEach((key, value) {
          final year = int.parse(key);
          _contests[year] = ContestModel.fromJson(value);
        });
        debugPrint('Loaded ${_contests.length} contests from cache');
      }

      final cachedContestants = _prefs.getString('contestants');
      if (cachedContestants != null) {
        final Map<String, dynamic> contestantsMap =
            jsonDecode(cachedContestants);
        contestantsMap.forEach((key, value) {
          final year = int.parse(key);
          _contestants[year] = value;
        });
        debugPrint(
            'Loaded contestants for ${_contestants.length} years from cache');
      }

      if (_contestYears != null && _contestYears!.isNotEmpty) {
        _totalYearsToLoad = _contestYears!.length;
        _yearsLoaded = _contests.length;

        if (_yearsLoaded >= _totalYearsToLoad) {
          _isLoadingComplete = true;
          debugPrint('All years loaded from cache, marking as complete');
        }
      }
    } catch (e) {
      debugPrint('Error loading cached data: $e');
    }
  }

  void _cacheData() {
    try {
      if (_contestYears != null && _contestYears!.isNotEmpty) {
        _prefs.setString('contestYears', jsonEncode(_contestYears));
        debugPrint('Cached ${_contestYears!.length} contest years');
      } else {
        debugPrint('No contest years to cache');
      }

      if (_contests.isNotEmpty) {
        final Map<String, dynamic> contestsMap = {};
        _contests.forEach((year, contest) {
          contestsMap[year.toString()] = contest.toJson();
        });

        _prefs.setString('contests', jsonEncode(contestsMap));
        debugPrint('Cached ${_contests.length} contests');
      }

      if (_contestants.isNotEmpty) {
        final Map<String, dynamic> contestantsMap = {};

        final List<int> sortedYears = _contestants.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        final recentYears = sortedYears.take(10).toList();

        for (final year in recentYears) {
          contestantsMap[year.toString()] = _contestants[year];
        }

        _prefs.setString('contestants', jsonEncode(contestantsMap));
        debugPrint(
            'Cached contestants for ${contestantsMap.length} recent years');
      }
    } catch (e) {
      debugPrint('Error caching data: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _prefs.clear();
      _contestYears = null;
      _contests.clear();
      _contestants.clear();
      _featuredContent = null;
      _userProfile = null;
      _isLoadingComplete = false;
      _yearsLoaded = 0;
      _totalYearsToLoad = 0;
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
}
