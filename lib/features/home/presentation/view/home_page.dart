
import 'package:eurovision_song_contest_clone/core/widgets/animation/animation_provider.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestants_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_years.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/tab_animation_cubit.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/view/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TabAnimationCubit(tabCount: 4),
        ),
      ],
      child: Builder(builder: (context) {
        // Use a variable to store the vsync for later use
        TickerProvider? vsyncProvider;

        return TabControllerProvider(
          onInitialize: (vsync) {
            // Store the vsync reference
            vsyncProvider = vsync;

            // Initialize the TabController through the cubit
            context.read<TabAnimationCubit>().initializeTabController(vsync);
          },
          child: BlocBuilder<TabAnimationCubit, TabAnimationState>(
            builder: (context, tabState) {
              // Only proceed with building the HomeCubit when TabController is initialized
              if (tabState.tabController == null || vsyncProvider == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return BlocProvider(
                create: (context) => HomeCubit(
                  getContestByYear: context.read<GetContestByYear>(),
                  getContestYears: context.read<GetContestYears>(),
                  getContestantByYear: context.read<GetContestantByYear>(),
                  getContestantsByYear: context.read<GetContestantsByYear>(),
                  vsync: vsyncProvider!,
                  tabController: tabState.tabController,
                ),
                child: HomePageView(tabController: tabState.tabController!),
              );
            },
          ),
        );
      }),
    );
  }
}
