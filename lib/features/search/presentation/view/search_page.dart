import 'package:eurovision_song_contest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:eurovision_song_contest_clone/features/search/domain/usecases/search_contests.dart';
import 'package:eurovision_song_contest_clone/features/search/presentation/cubit/search_cubit.dart';
import 'package:eurovision_song_contest_clone/features/search/presentation/view/search_page_view.dart';
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
            repository: context.read<SearchRepository>(),
          ),
          child: const SearchPageView(),
        );
      },
    );
  }
}
