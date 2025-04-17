import 'package:eurovision_song_contest_clone/core/data/app_data_manager.dart';
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

  // Initialize the AppDataManager singleton
  final appDataManager = AppDataManager();
  await appDataManager.initialize();
  await appDataManager.loadInitialData();

  runApp(EurovisionSongContestApp(appDataManager: appDataManager));
}

class EurovisionSongContestApp extends StatefulWidget {
  final AppDataManager appDataManager;

  const EurovisionSongContestApp({super.key, required this.appDataManager});

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
    final contestRepository = RepositoryFactory.createRepository(
        appDataManager: widget.appDataManager);

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
          // AppDataManager provider
          RepositoryProvider<AppDataManager>(
            create: (context) => widget.appDataManager,
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
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
