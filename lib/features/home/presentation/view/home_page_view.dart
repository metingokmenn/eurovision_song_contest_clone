import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_cubit.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_state.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:eurovision_song_contest_clone/core/widgets/selectors/year_selector.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_state.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/tab_animation_cubit.dart';
import 'package:eurovision_song_contest_clone/features/home/widgets/contestants_tab_content.dart';
import 'package:eurovision_song_contest_clone/features/home/widgets/home_tab_bar.dart';
import 'package:eurovision_song_contest_clone/features/home/widgets/overview_tab_content.dart';
import 'package:eurovision_song_contest_clone/features/home/widgets/rounds_tab_content.dart';
import 'package:eurovision_song_contest_clone/features/home/widgets/voting_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageView extends StatelessWidget {
  final TabController tabController;

  const HomePageView({
    Key? key,
    required this.tabController,
  }) : super(key: key);

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
        // Listen for TabAnimationCubit changes
        BlocListener<TabAnimationCubit, TabAnimationState>(
          listenWhen: (previous, current) =>
              previous.currentIndex != current.currentIndex,
          listener: (context, state) {
            // Synchronize the tab controller with the cubit state if they're out of sync
            if (tabController.index != state.currentIndex &&
                state.tabController != null) {
              tabController.index = state.currentIndex;
            }
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

          if (state.error != null && state.currentContest == null) {
            // Only show error screen if we couldn't load any data
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

          // Use the parent's TabController if available, otherwise use the one from the state
          final currentTabController = state.tabController ?? tabController;
          if (state.currentContest == null) {
            return const Scaffold(
              body: Center(
                child: Text('Initializing...'),
              ),
            );
          }

          return Scaffold(
            appBar: const CustomAppBar(
              showBackButton: false,
            ),
            body: Column(
              children: [
                // Show offline indicator if needed
                if (state.isOffline || state.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    color: Colors.orange,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You\'re offline. Using cached data.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                        InkWell(
                          onTap: () => context.read<HomeCubit>().reload(),
                          child: Text(
                            'Retry',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                HomeTabBar(
                  controller: currentTabController,
                  onTabChanged: (index) {
                    // Update the TabAnimationCubit when tab changes via UI
                    context.read<TabAnimationCubit>().animateToTab(index);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child:
                      state.availableYears != null && state.selectedYear != null
                          ? YearSelector(
                              availableYears: state.availableYears!,
                              selectedYear: state.selectedYear!,
                            )
                          : const SizedBox.shrink(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: currentTabController,
                    children: [
                      OverviewTabContent(
                        contest: state.currentContest!,
                      ),
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
