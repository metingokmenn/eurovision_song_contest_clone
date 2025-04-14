import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/usecases/get_contestants_by_year.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_cubit.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_state.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/cubit/home_state.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/widgets/contestants_tab_content.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/widgets/home_tab_bar.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/widgets/overview_tab_content.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/usecases/get_contest_by_year.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/usecases/get_contest_years.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/widgets/rounds_tab_content.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/widgets/voting_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';

import '../../../../core/constants/constant_index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        getContestByYear: context.read<GetContestByYear>(),
        getContestYears: context.read<GetContestYears>(),
        getContestantByYear: context.read<GetContestantByYear>(),
        getContestantsByYear: context.read<GetContestantsByYear>(),
        vsync: this,
      ),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationCubit, NavigationState>(
          listenWhen: (previous, current) =>
              current.index == 0 && // Only when Home tab is active
              current.data != null &&
              current.data!.containsKey('selectedYear'),
          listener: (context, state) {
            // Get the selected year from NavigationCubit data
            final selectedYear = state.data!['selectedYear'] as int;

            // Update the HomeCubit with the selected year
            context.read<HomeCubit>().selectYear(selectedYear);

            // Clear the data after it's been used
            context.read<NavigationCubit>().clearData();
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.magenta,
                ),
              ),
            );
          }

          if (state.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48,
                    ),
                    AppSizedBox.medium,
                    Text(
                      'Error: ${state.error}',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    AppSizedBox.large,
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().reload();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.magenta,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final tabController = state.tabController;
          if (tabController == null || state.currentContest == null) {
            return const Scaffold(
              body: Center(
                child: Text('Initializing...'),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const CustomAppBar(
              showBackButton: false,
            ),
            body: Column(
              children: [
                HomeTabBar(controller: tabController),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: state.selectedYear,
                        isExpanded: true,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.magenta.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.magenta,
                          ),
                        ),
                        items: state.availableYears?.map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(
                              'Eurovision $year',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          if (value != null) {
                            context.read<HomeCubit>().selectYear(value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      OverviewTabContent(contest: state.currentContest!),
                      ContestantsTabContent(contest: state.currentContest!),
                      VotingTabContent(contest: state.currentContest!),
                      RoundsTabContent(contest: state.currentContest!),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
