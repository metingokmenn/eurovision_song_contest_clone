import 'package:eurovision_song_contest_clone/core/utils/country_code_converter.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contestant_model.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestants_by_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_years.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetContestByYear getContestByYear;
  final GetContestYears getContestYears;
  final GetContestantByYear getContestantByYear;
  final GetContestantsByYear getContestantsByYear;

  final TickerProvider vsync;

  HomeCubit({
    required this.getContestByYear,
    required this.getContestYears,
    required this.getContestantByYear,
    required this.getContestantsByYear,
    required this.vsync,
  }) : super(const HomeState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      emit(state.copyWith(isLoading: true));

      // Get available years
      final years = await getContestYears();

      // Initialize tab controller
      final tabController = TabController(
        length: 4,
        vsync: vsync,
      );

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
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> reload() async {
    await _initialize();
  }

  Future<void> selectYear(int year) async {
    try {
      emit(state.copyWith(isLoading: true));
      final contest = await getContestByYear(year);
      ContestantModel contestant = await getContestantByYear(year, 0);

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
    state.tabController?.dispose();
    return super.close();
  }
}
