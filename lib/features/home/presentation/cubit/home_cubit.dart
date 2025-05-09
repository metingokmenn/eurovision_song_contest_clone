import 'dart:io';

import 'package:eurovision_song_contest_clone/core/utils/country_code_converter.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contestant_model.dart';

import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestants_by_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_years.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  // Regular use cases for initial loading
  final GetContestByYear getContestByYear;
  final GetContestYears getContestYears;
  final GetContestantByYear getContestantByYear;
  final GetContestantsByYear getContestantsByYear;

  final TickerProvider vsync;

  // This TabController is created externally and passed to us
  final TabController? _tabController;

  HomeCubit({
    required this.getContestByYear,
    required this.getContestYears,
    required this.getContestantByYear,
    required this.getContestantsByYear,
    required this.vsync,
    TabController? tabController,
  })  : _tabController = tabController,
        super(const HomeState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      emit(state.copyWith(isLoading: true));

      // Get available years
      List<int> years = [];
      try {
        years = await getContestYears();
      } catch (e) {
        debugPrint('Error loading years: $e');
        // Fall back to cache if API fails
        years = await getContestYears();
      }

      if (years.isEmpty) {
        throw Exception('Failed to load contest years');
      }

      // Create TabController only if it wasn't passed in constructor
      TabController? tabController;
      if (_tabController == null) {
        tabController = TabController(
          length: 4,
          vsync: vsync,
        );
      } else {
        tabController = _tabController;
      }

      // Get latest contest data
      final latestYear = years.last;
      final contest = await getContestByYear(latestYear);
      ContestantModel contestant = await getContestantByYear(latestYear, 0);
      final contestants = await getContestantsByYear(latestYear);

      // Safe country code conversion
      if (contestant.country != null && contestant.country!.isNotEmpty) {
        final countryName =
            await CountryCodeConverter.convertCountryCodeToCountryName(
                contestant.country!);
        contestant = contestant.copyWith(country: countryName);
      }

      emit(state.copyWith(
        isLoading: false,
        tabController: tabController,
        currentContest: contest,
        availableYears: years,
        selectedYear: latestYear,
        currentContestant: contestant,
        contestants: contestants,
      ));
    } catch (e) {
      debugPrint('Error initializing home: $e');

      // Try to use cache for initial data if available
      try {
        final cachedYears = await getContestYears();
        if (cachedYears.isNotEmpty) {
          final latestCachedYear = cachedYears.last;

          // Create TabController only if it wasn't passed in constructor
          TabController? tabController;
          if (_tabController == null) {
            tabController = TabController(
              length: 4,
              vsync: vsync,
            );
          } else {
            tabController = _tabController;
          }

          // Get latest cached contest data
          final contest = await getContestByYear(latestCachedYear);
          final contestants = await getContestantsByYear(latestCachedYear);

          // Use first contestant if available
          ContestantModel? contestant;
          if (contestants.isNotEmpty) {
            contestant = contestants[0];
          }

          emit(state.copyWith(
            isLoading: false,
            tabController: tabController,
            currentContest: contest,
            availableYears: cachedYears,
            selectedYear: latestCachedYear,
            currentContestant: contestant,
            contestants: contestants.whereType<ContestantModel>().toList(),
            error: "Network error: Using cached data",
            isOffline: true,
          ));

          return;
        }
      } catch (cacheError) {
        debugPrint('Error loading from cache: $cacheError');
      }

      // If we get here, both network and cache failed
      emit(state.copyWith(
        isLoading: false,
        error: e is SocketException || e.toString().contains('ClientException')
            ? 'No internet connection. Please check your network settings.'
            : e.toString(),
        isOffline: true,
      ));
    }
  }

  Future<void> reload() async {
    // Clear any error state before reloading
    emit(state.copyWith(
      error: null,
      isOffline: false,
      isLoading: true,
    ));

    // Reuse the same initialization logic
    await _initialize();
  }

  Future<void> selectYear(int year) async {
    try {
      emit(state.copyWith(isLoading: true));

      ContestModel contest;
      List<ContestantModel> contestants = [];

      // If not available in cache, use the regular use cases
      debugPrint('Cache miss for year $year, using API');
      contest = await getContestByYear(year);
      contestants = await getContestantsByYear(year);

      // Get first contestant
      ContestantModel contestant;
      if (contestants.isNotEmpty) {
        contestant = contestants[0];
      } else {
        contestant = await getContestantByYear(year, 0);
      }

      // Safe country code conversion
      if (contestant.country != null && contestant.country!.isNotEmpty) {
        final countryName =
            await CountryCodeConverter.convertCountryCodeToCountryName(
                contestant.country!);
        contestant = contestant.copyWith(country: countryName);
      }

      emit(state.copyWith(
        isLoading: false,
        currentContest: contest,
        selectedYear: year,
        currentContestant: contestant,
        contestants: contestants,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> selectContestant(int contestantId) async {
    try {
      emit(state.copyWith(isLoading: true));
      ContestantModel contestant =
          await getContestantByYear(state.selectedYear!, contestantId);

      // Safe country code conversion
      if (contestant.country != null && contestant.country!.isNotEmpty) {
        final countryName =
            await CountryCodeConverter.convertCountryCodeToCountryName(
                contestant.country!);
        contestant = contestant.copyWith(country: countryName);
      }

      emit(state.copyWith(
        isLoading: false,
        currentContestant: contestant,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    // Only dispose TabController if we created it
    if (_tabController == null && state.tabController != null) {
      try {
        state.tabController!.dispose();
      } catch (e) {
        debugPrint('Error disposing TabController: $e');
      }
    }
    return super.close();
  }
}
