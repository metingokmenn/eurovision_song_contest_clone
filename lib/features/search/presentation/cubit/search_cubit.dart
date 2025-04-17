import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/usecases/search_contests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchContests _searchContests;
  final SearchRepository _repository;

  SearchCubit({
    required SearchContests searchContests,
    required SearchRepository repository,
  })  : _searchContests = searchContests,
        _repository = repository,
        super(const SearchState());

  void updateQuery(String query) {
    emit(state.copyWith(query: query, clearError: true));
    if (query.isNotEmpty) {
      search();
    } else {
      emit(state.copyWith(
        contestResults: [],
        contestantResults: [],
        isLoading: false,
        usingCachedData: false,
      ));
    }
  }

  void setFilter(SearchFilter filter) {
    emit(state.copyWith(activeFilter: filter, clearError: true));
    if (state.query.isNotEmpty) {
      search();
    }
  }

  void setSelectedYear(int? year) {
    emit(state.copyWith(selectedYear: year, clearError: true));
    if (state.query.isNotEmpty) {
      search();
    }
  }

  Future<void> search() async {
    if (state.query.isEmpty) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      // Check if we have enough cached data for searching
      final hasCachedData = _repository.hasEnoughCachedData();

      // We now only search for contests
      await _searchContestsOnly(usingCache: hasCachedData);
    } catch (e) {
      emit(state.copyWith(
        error: 'Search failed: ${e.toString()}',
        isLoading: false,
        usingCachedData: false,
      ));
    }
  }

  Future<void> _searchContestsOnly({bool usingCache = false}) async {
    try {
      debugPrint(
          'Searching for "${state.query}" using ${usingCache ? 'cached data' : 'API'}');
      final results = await _searchContests(state.query);

      emit(state.copyWith(
        contestResults: results,
        contestantResults: [],
        isLoading: false,
        usingCachedData: usingCache && results.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to search contests: ${e.toString()}',
        isLoading: false,
        contestResults: [],
        usingCachedData: false,
      ));
    }
  }

  void clearSearch() {
    emit(const SearchState());
  }
}
