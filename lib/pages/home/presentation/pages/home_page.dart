import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/usecases/get_contestants_by_year.dart';
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
import 'package:eurovision_song_contest_clone/core/navigation/widgets/custom_navigation_bar.dart';

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

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.error}')),
          );
        }

        final tabController = state.tabController;
        if (tabController == null || state.currentContest == null) {
          return const Scaffold(
            body: Center(child: Text('Initializing...')),
          );
        }

        return Scaffold(
          appBar: const CustomAppBar(),
          body: Column(
            children: [
              HomeTabBar(controller: tabController),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: state.selectedYear,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: state.availableYears?.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(
                          'Eurovision $year',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
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
              const SizedBox(height: 8),
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
          bottomNavigationBar: const CustomNavigationBar(),
        );
      },
    );
  }
}
