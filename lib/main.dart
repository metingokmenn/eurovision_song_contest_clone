import 'package:eurovision_song_contest_clone/core/navigation/app_layout.dart';
import 'package:eurovision_song_contest_clone/core/theme/cubit/theme_cubit.dart';
import 'package:eurovision_song_contest_clone/features/contestant/data/datasources/contestant_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/contestant/data/repositories/contestant_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/contestant/domain/usecases/get_contestants_by_year.dart';
import 'package:eurovision_song_contest_clone/features/search/di/search_dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_theme.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_cubit.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/usecases/get_contest_by_year.dart';
import 'package:eurovision_song_contest_clone/features/contest/domain/usecases/get_contest_years.dart';
import 'package:eurovision_song_contest_clone/features/contest/di/contest_dependency_injection.dart';
import 'package:eurovision_song_contest_clone/features/contest/data/datasources/contest_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/contest/data/repositories/contest_repository_impl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependencies
    ContestDependencyInjection.setup();

    final contestRepository = ContestRepositoryImpl(
      remoteDataSource: ContestRemoteDataSource(client: http.Client()),
    );

    final contestantRepository = ContestantRepositoryImpl(
      remoteDataSource: ContestantRemoteDataSource(client: http.Client()),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          // Contest and contestant providers
          RepositoryProvider<GetContestByYear>(
            create: (context) => GetContestByYear(contestRepository),
          ),
          RepositoryProvider<GetContestYears>(
            create: (context) => GetContestYears(contestRepository),
          ),
          RepositoryProvider<GetContestantByYear>(
            create: (context) => GetContestantByYear(contestantRepository),
          ),
          RepositoryProvider<GetContestantsByYear>(
            create: (context) => GetContestantsByYear(contestantRepository),
          ),
          // Search providers
          ...SearchDependencyInjection.getRepositoryProviders(),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Eurovision Song Contest',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              home: const AppLayout(),
            );
          },
        ),
      ),
    );
  }
}
