import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashAnimationState {
  final double animationValue;
  final bool hasCompletedAnimation;
  final Animation<double>? fadeAnimation;
  final AnimationController? animationController;

  SplashAnimationState({
    this.animationValue = 0.0,
    this.hasCompletedAnimation = false,
    this.fadeAnimation,
    this.animationController,
  });

  SplashAnimationState copyWith({
    double? animationValue,
    bool? hasCompletedAnimation,
    Animation<double>? fadeAnimation,
    AnimationController? animationController,
  }) {
    return SplashAnimationState(
      animationValue: animationValue ?? this.animationValue,
      hasCompletedAnimation:
          hasCompletedAnimation ?? this.hasCompletedAnimation,
      fadeAnimation: fadeAnimation ?? this.fadeAnimation,
      animationController: animationController ?? this.animationController,
    );
  }
}

class SplashAnimationCubit extends Cubit<SplashAnimationState> {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  final Function? onAnimationCompleted;

  SplashAnimationCubit({this.onAnimationCompleted})
      : super(SplashAnimationState());

  void initializeAnimation(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(
          milliseconds: 2400), // Animation is 240 frames at 60fps = 4 seconds
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Add listener to update animation value
    _animationController!.addListener(_updateAnimationValue);

    // Add status listener to check for animation completion
    _animationController!.addStatusListener(_handleAnimationStatus);

    // Start the animation
    _animationController!.forward();

    // Update state with animation objects
    emit(state.copyWith(
      fadeAnimation: _fadeAnimation,
      animationController: _animationController,
    ));
  }

  void _updateAnimationValue() {
    if (_animationController != null) {
      emit(state.copyWith(animationValue: _animationController!.value));
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      emit(state.copyWith(hasCompletedAnimation: true));

      // Notify when animation completes
      if (onAnimationCompleted != null) {
        onAnimationCompleted!();
      }
    }
  }

  @override
  Future<void> close() {
    _animationController?.removeListener(_updateAnimationValue);
    _animationController?.removeStatusListener(_handleAnimationStatus);
    _animationController?.dispose();
    return super.close();
  }
}
