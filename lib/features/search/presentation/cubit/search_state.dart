import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';

enum SearchFilter { all, contests }

class SearchState {
  final String query;
  final bool isLoading;
  final String? error;
  final List<ContestModel> contestResults;
  final List<dynamic> contestantResults; // Keeping for backwards compatibility
  final SearchFilter activeFilter;
  final int? selectedYear;
  final bool usingCachedData; // Indicates if search results are from cache

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.error,
    this.contestResults = const [],
    this.contestantResults = const [],
    this.activeFilter = SearchFilter.all,
    this.selectedYear,
    this.usingCachedData = false,
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    String? error,
    List<ContestModel>? contestResults,
    List<dynamic>? contestantResults,
    SearchFilter? activeFilter,
    int? selectedYear,
    bool? usingCachedData,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      contestResults: contestResults ?? this.contestResults,
      contestantResults: contestantResults ?? this.contestantResults,
      activeFilter: activeFilter ?? this.activeFilter,
      selectedYear: selectedYear ?? this.selectedYear,
      usingCachedData: usingCachedData ?? this.usingCachedData,
    );
  }
}
