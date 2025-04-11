import 'package:eurovision_song_contest_clone/features/contestant/data/models/contestant_model.dart';
import 'package:flutter/material.dart';
import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';

class HomeState {
  final TabController? tabController;
  final ContestModel? currentContest;
  final ContestantModel? currentContestant;
  final List<ContestantModel>? contestants;
  final bool isLoading;
  final String? error;
  final List<int>? availableYears;
  final int? selectedYear;

  const HomeState({
    this.tabController,
    this.currentContest,
    this.currentContestant,
    this.contestants,
    this.isLoading = false,
    this.error,
    this.availableYears,
    this.selectedYear,
  });

  HomeState copyWith({
    TabController? tabController,
    ContestModel? currentContest,
    ContestantModel? currentContestant,
    List<ContestantModel>? contestants,
    bool? isLoading,
    String? error,
    List<int>? availableYears,
    int? selectedYear,
  }) {
    return HomeState(
      tabController: tabController ?? this.tabController,
      currentContest: currentContest ?? this.currentContest,
      currentContestant: currentContestant ?? this.currentContestant,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      availableYears: availableYears ?? this.availableYears,
      selectedYear: selectedYear ?? this.selectedYear,
      contestants: contestants ?? this.contestants,
    );
  }
}
