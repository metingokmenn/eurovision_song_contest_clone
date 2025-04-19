import 'package:eurovision_song_contest_clone/core/di/service_provider.dart';
import 'package:eurovision_song_contest_clone/core/splash/splash_screen.dart';
import 'package:eurovision_song_contest_clone/core/theme/cubit/theme_cubit.dart';

import 'package:eurovision_song_contest_clone/features/home/data/datasources/contestant_remote_data_source.dart';
import 'package:eurovision_song_contest_clone/features/home/data/repositories/contestant_repository_impl.dart';
import 'package:eurovision_song_contest_clone/features/home/di/repository_factory.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestant_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contestants_by_year.dart';

import 'package:eurovision_song_contest_clone/features/search/di/search_dependency_injection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_theme.dart';
import 'package:eurovision_song_contest_clone/core/navigation/cubit/navigation_cubit.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_by_year.dart';
import 'package:eurovision_song_contest_clone/features/home/domain/usecases/get_contest_years.dart';

import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EurovisionSongContestApp());
}

class EurovisionSongContestApp extends StatefulWidget {
  const EurovisionSongContestApp({super.key});

  @override
  State<EurovisionSongContestApp> createState() =>
      _EurovisionSongContestAppState();
}

class _EurovisionSongContestAppState extends State<EurovisionSongContestApp> {
  final ServiceProvider _serviceProvider = ServiceProvider();

  @override
  void dispose() {
    // Clean up resources when app is closed
    _serviceProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create repositories for initial data loading
    final contestRepository = RepositoryFactory.createRepository();

    final contestantRepository = ContestantRepositoryImpl(
      remoteDataSource: ContestantRemoteDataSource(client: http.Client()),
    );

    // Use case instances
    final getContestYears = GetContestYears(contestRepository);
    final getContestByYear = GetContestByYear(contestRepository);
    final getContestantsByYear = GetContestantsByYear(contestantRepository);
    final getContestantByYear = GetContestantByYear(contestantRepository);

    return MultiBlocProvider(
      providers: [
        // Theme cubit for handling app theme
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        // Navigation cubit for handling app navigation
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        // Core repository providers
        RepositoryProvider(
          create: (context) => contestRepository,
        ),
        RepositoryProvider(
          create: (context) => getContestYears,
        ),
        RepositoryProvider(
          create: (context) => getContestByYear,
        ),
        RepositoryProvider(
          create: (context) => getContestantsByYear,
        ),
        RepositoryProvider(
          create: (context) => getContestantByYear,
        ),
        // Add search-related providers
        ...SearchDependencyInjection.getRepositoryProviders(),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Eurovision Song Contest',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
