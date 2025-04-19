import 'package:eurovision_song_contest_clone/features/search/domain/usecases/search_contests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchContests _searchContests;

  SearchCubit({
    required SearchContests searchContests,
  })  : _searchContests = searchContests,
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
      // Search for contests
      await _searchContestsOnly();
    } catch (e) {
      emit(state.copyWith(
        error: 'Search failed: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  Future<void> _searchContestsOnly() async {
    try {
      debugPrint('Searching for "${state.query}" using API');
      final results = await _searchContests(state.query);

      emit(state.copyWith(
        contestResults: results,
        contestantResults: [],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to search contests: ${e.toString()}',
        isLoading: false,
        contestResults: [],
      ));
    }
  }

  void clearSearch() {
    emit(const SearchState());
  }
}
