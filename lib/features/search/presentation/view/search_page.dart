import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_cubit.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:eurovision_song_contest_clone/core/widgets/common/custom_text_field.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/usecases/search_contests.dart';

import 'package:eurovision_song_contest_clone/features/search/presentation/cubit/search_cubit.dart';
import 'package:eurovision_song_contest_clone/features/search/presentation/cubit/search_state.dart';
import 'package:eurovision_song_contest_clone/features/search/presentation/widgets/contest_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a builder pattern to ensure we have access to the correct BuildContext
    return Builder(
      builder: (context) {
        return BlocProvider(
          create: (context) => SearchCubit(
            searchContests: context.read<SearchContests>(),
          ),
          child: const _SearchPageView(),
        );
      },
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search',
        showBackButton: false,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextField(
                  controller: _searchController,
                  hintText: 'Search for contests...',
                  onChanged: (value) {
                    context.read<SearchCubit>().updateQuery(value);
                  },
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.magenta,
                  ),
                  suffixIcon: state.query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchCubit>().clearSearch();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                ),
              ),

              AppSizedBox.medium,

              // Search results
              Expanded(
                child: _buildSearchResults(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.magenta,
        ),
      );
    }

    if (state.error != null) {
      return Center(
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
                context.read<SearchCubit>().search();
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
      );
    }

    if (state.query.isEmpty) {
      return const Center(
        child: Text(
          'Enter a search term to find Eurovision contests',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    if (state.contestResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
            ),
            AppSizedBox.medium,
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSizedBox.small,
            Text(
              'Try different keywords or filters',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          // Contests section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Contests (${state.contestResults.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final contest = state.contestResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ContestSearchResultItem(
                    contest: contest,
                    onTap: () {
                      // Pass the selected year directly to the NavigationCubit
                      context.read<NavigationCubit>().updateIndex(0, data: {
                        'selectedYear': contest.year,
                      });

                      // Show a confirmation snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Showing Eurovision ${contest.year}'),
                          backgroundColor: AppColors.magenta,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: state.contestResults.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}
