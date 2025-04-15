import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_cubit.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_state.dart';
import 'package:eurovision_song_contest_clone/core/navigation/widgets/custom_navigation_bar.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/view/home_page.dart';
import 'package:eurovision_song_contest_clone/features/profile/presentation/view/profile_page.dart';
import 'package:eurovision_song_contest_clone/features/search/presentation/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.index,
            children: const [
              // Index 0: Home
              HomePage(),
              // Index 1: Search
              SearchPage(),
              // Index 2: Profile
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: const CustomNavigationBar(),
        );
      },
    );
  }
}
