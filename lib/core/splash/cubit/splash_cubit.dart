import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/splash/data_initializer.dart';

class SplashState {
  final bool hasCompletedAnimation;
  final bool isLoadingData;
  final bool isDataLoaded;
  final String? errorMessage;
  final double animationValue;
  final double loadingProgress;
  final String loadingMessage;
  final bool canNavigate;

  const SplashState({
    this.hasCompletedAnimation = false,
    this.isLoadingData = false,
    this.isDataLoaded = false,
    this.errorMessage,
    this.animationValue = 0.0,
    this.loadingProgress = 0.0,
    this.loadingMessage = 'Loading...',
    this.canNavigate = false,
  });

  SplashState copyWith({
    bool? hasCompletedAnimation,
    bool? isLoadingData,
    bool? isDataLoaded,
    String? errorMessage,
    double? animationValue,
    double? loadingProgress,
    String? loadingMessage,
    bool? canNavigate,
  }) {
    return SplashState(
      hasCompletedAnimation:
          hasCompletedAnimation ?? this.hasCompletedAnimation,
      isLoadingData: isLoadingData ?? this.isLoadingData,
      isDataLoaded: isDataLoaded ?? this.isDataLoaded,
      errorMessage: errorMessage ?? this.errorMessage,
      animationValue: animationValue ?? this.animationValue,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      canNavigate: canNavigate ?? this.canNavigate,
    );
  }

  // Special case for clearing error
  SplashState clearError() {
    return SplashState(
      hasCompletedAnimation: hasCompletedAnimation,
      isLoadingData: isLoadingData,
      isDataLoaded: isDataLoaded,
      errorMessage: null,
      animationValue: animationValue,
      loadingProgress: loadingProgress,
      loadingMessage: loadingMessage,
      canNavigate: canNavigate,
    );
  }
}

class SplashCubit extends Cubit<SplashState> {
  final DataInitializer _dataInitializer;
  AnimationController? _animationController;
  Timer? _navigationTimer;
  StreamSubscription? _progressSubscription;

  SplashCubit({
    DataInitializer? dataInitializer,
  })  : _dataInitializer = dataInitializer ?? DataInitializer(),
        super(const SplashState());

  void initializeAnimation(AnimationController controller) {
    _animationController = controller;

    // Add listener to update animation value
    _animationController!.addListener(() {
      emit(state.copyWith(
        animationValue: _animationController!.value,
      ));
    });

    // Add status listener to handle animation completion
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        emit(state.copyWith(
          hasCompletedAnimation: true,
        ));

        // Try to navigate if data is loaded
        _tryNavigate();
      }
    });

    // Start animation
    _animationController!.forward();

    // Start loading data in parallel
    loadData();
  }

  Future<void> loadData() async {
    if (state.isLoadingData) return;

    emit(state
        .copyWith(
          isLoadingData: true,
        )
        .clearError());

    try {
      // Subscribe to progress updates
      _progressSubscription =
          _dataInitializer.progressStream.listen((progress) {
        emit(state.copyWith(
          loadingProgress: progress,
          loadingMessage: _dataInitializer.loadingMessage,
        ));
      });

      final success = await _dataInitializer.initializeAppData();

      emit(state.copyWith(
        isDataLoaded: success,
        isLoadingData: false,
        errorMessage: _dataInitializer.errorMessage,
      ));

      // Try to navigate if animation has completed
      _tryNavigate();
    } catch (e) {
      emit(state.copyWith(
        isLoadingData: false,
        isDataLoaded: false,
        errorMessage: 'Failed to load data: $e',
      ));
    }
  }

  // Try to navigate to main app if conditions are met
  void _tryNavigate() {
    if (state.hasCompletedAnimation && state.isDataLoaded) {
      if (_navigationTimer != null) {
        return; // Already scheduled navigation
      }

      // Set a timer to navigate after a short delay
      _navigationTimer = Timer(const Duration(milliseconds: 500), () {
        emit(state.copyWith(
          canNavigate: true,
        ));
      });
    }
  }

  bool canNavigateToApp() {
    return state.canNavigate;
  }

  void tryNavigateWhenReady() {
    if (state.isDataLoaded) {
      emit(state.copyWith(canNavigate: true));
    }
  }

  @override
  Future<void> close() {
    _navigationTimer?.cancel();
    _progressSubscription?.cancel();
    _dataInitializer.dispose();
    return super.close();
  }
}
