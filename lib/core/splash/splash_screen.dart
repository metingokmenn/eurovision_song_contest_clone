import 'package:eurovision_song_contest_clone/core/navigation/app_layout.dart';
import 'package:eurovision_song_contest_clone/core/splash/cubit/splash_animation_cubit.dart';
import 'package:eurovision_song_contest_clone/core/splash/cubit/splash_cubit.dart';

import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/core/widgets/animation/animation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(
          create: (context) => SplashAnimationCubit(
            onAnimationCompleted: () {
              // Try to navigate if data is loaded
              context.read<SplashCubit>().tryNavigateWhenReady();
            },
          ),
        ),
      ],
      child: const SplashAnimationWrapper(),
    );
  }
}

class SplashAnimationWrapper extends StatelessWidget {
  const SplashAnimationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationProvider(
      onInitialize: (vsync) {
        context.read<SplashAnimationCubit>().initializeAnimation(vsync);

        // Start loading data
        context.read<SplashCubit>().loadData();
      },
      child: const SplashScreenContent(),
    );
  }
}

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (previous, current) =>
          !previous.canNavigate && current.canNavigate,
      listener: (context, state) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AppLayout(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              var curve = Curves.easeInOut;

              var opacityTween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return FadeTransition(
                opacity: animation.drive(opacityTween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      },
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          return BlocBuilder<SplashAnimationCubit, SplashAnimationState>(
            builder: (context, animationState) {
              return Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.magenta.withAlpha(50),
                        Colors.white,
                        Colors.white,
                        AppColors.magenta.withAlpha(30),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),
                        // Animation with scale effect
                        Transform.scale(
                          scale: 1.0 + (animationState.animationValue * 0.05),
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: Lottie.asset(
                              'assets/animation/splash-animation.json',
                              controller: animationState.animationController,
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Title with fade animation
                        if (animationState.fadeAnimation != null)
                          FadeTransition(
                            opacity: animationState.fadeAnimation!,
                            child: Column(
                              children: [
                                const Text(
                                  'Eurovision',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.magenta,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Song Contest',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AnimatedOpacity(
                                  opacity: animationState.hasCompletedAnimation
                                      ? 0.0
                                      : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.magenta.withAlpha(30),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Experience the music',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.magenta,
                                      ),
                                    ),
                                  ),
                                ),

                                // Loading indicator
                                if (state.isLoadingData || !state.isDataLoaded)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Column(
                                      children: [
                                        // Progress indicator
                                        SizedBox(
                                          width: 200,
                                          child: LinearProgressIndicator(
                                            value: state.loadingProgress,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(AppColors.magenta),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),

                                        // Loading status text
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            state.errorMessage ??
                                                state.loadingMessage,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: state.errorMessage != null
                                                  ? Colors.red
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),

                                        // Retry button if error occurred
                                        if (state.errorMessage != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: ElevatedButton(
                                              onPressed: () => context
                                                  .read<SplashCubit>()
                                                  .loadData(),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.magenta,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                              ),
                                              child: const Text('Retry'),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const Spacer(flex: 2),
                        AnimatedOpacity(
                          opacity:
                              animationState.hasCompletedAnimation ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'v1.0.1',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
