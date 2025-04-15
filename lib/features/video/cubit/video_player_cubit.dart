import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

// State class for the VideoPlayerCubit
class VideoPlayerState {
  final VideoPlayerController? controller;
  final WebViewController? webViewController;
  final bool isPlaying;
  final bool isInitialized;
  final bool isError;
  final bool isYoutubeVideo;
  final bool isFullScreen;
  final bool isControlsVisible;
  final bool isAutoplay;
  final Duration position;
  final Duration duration;
  final String videoUrl;
  final String? title;
  final String? artistName;
  final String? songName;
  final String? lyrics;

  const VideoPlayerState({
    this.controller,
    this.webViewController,
    this.isPlaying = false,
    this.isInitialized = false,
    this.isError = false,
    this.isYoutubeVideo = false,
    this.isFullScreen = false,
    this.isControlsVisible = true,
    this.isAutoplay = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    required this.videoUrl,
    this.title,
    this.artistName,
    this.songName,
    this.lyrics,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    WebViewController? webViewController,
    bool? isPlaying,
    bool? isInitialized,
    bool? isError,
    bool? isYoutubeVideo,
    bool? isFullScreen,
    bool? isControlsVisible,
    bool? isAutoplay,
    Duration? position,
    Duration? duration,
    String? videoUrl,
    String? title,
    String? artistName,
    String? songName,
    String? lyrics,
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      webViewController: webViewController ?? this.webViewController,
      isPlaying: isPlaying ?? this.isPlaying,
      isInitialized: isInitialized ?? this.isInitialized,
      isError: isError ?? this.isError,
      isYoutubeVideo: isYoutubeVideo ?? this.isYoutubeVideo,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      isAutoplay: isAutoplay ?? this.isAutoplay,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      songName: songName ?? this.songName,
      lyrics: lyrics ?? this.lyrics,
    );
  }
}

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController? _controller;
  WebViewController? _webViewController;

  VideoPlayerCubit({
    required String videoUrl,
    String? title,
    String? artistName,
    String? songName,
    String? lyrics,
  }) : super(VideoPlayerState(
          videoUrl: videoUrl,
          title: title,
          artistName: artistName,
          songName: songName,
          lyrics: lyrics,
        )) {
    _initializePlayer();
  }

  // Method to handle orientation permissions
  void addOrientationListener() {
    // Set preferred orientations to allow both portrait and landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Initialize the player based on the video URL
  Future<void> _initializePlayer() async {
    try {
      if (_isYoutubeUrl(state.videoUrl)) {
        await _initializeYoutubePlayer();
      } else {
        await _initializeVideoPlayer();
      }
    } catch (e) {
      emit(state.copyWith(isError: true));
    }
  }

  // Initialize the YouTube player using WebView
  Future<void> _initializeYoutubePlayer() async {
    try {
      final youtubeEmbedUrl = _getYoutubeEmbedUrl(state.videoUrl);

      if (youtubeEmbedUrl != null) {
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.black)
          // Add custom JavaScript to prevent automatic fullscreen
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                // Inject JavaScript to override fullscreen behavior
                _webViewController?.runJavaScript('''
                  document.addEventListener('fullscreenchange', function(e) {
                    if (document.fullscreenElement) {
                      document.exitFullscreen();
                    }
                  });
                  
                  // Add CSS to disable native fullscreen button
                  var style = document.createElement('style');
                  style.innerHTML = '.ytp-fullscreen-button { display: none !important; }';
                  document.head.appendChild(style);
                ''');
              },
            ),
          )
          ..loadRequest(Uri.parse(youtubeEmbedUrl));

        emit(state.copyWith(
          isYoutubeVideo: true,
          webViewController: _webViewController,
        ));
      } else {
        emit(state.copyWith(isError: true));
      }
    } catch (e) {
      emit(state.copyWith(isError: true));
    }
  }

  // Initialize the native video player
  Future<void> _initializeVideoPlayer() async {
    try {
      // ignore: deprecated_member_use
      final controller = VideoPlayerController.network(state.videoUrl);
      await controller.initialize();

      if (controller.value.hasError ||
          controller.value.duration == Duration.zero) {
        emit(state.copyWith(isError: true));
        controller.dispose();
        return;
      }

      controller.addListener(_videoPlayerListener);
      emit(state.copyWith(
        controller: controller,
        isInitialized: true,
        duration: controller.value.duration,
      ));

      if (state.isAutoplay) {
        controller.play();
        emit(state.copyWith(isPlaying: true));
      }
    } catch (e) {
      emit(state.copyWith(isError: true));
    }
  }

  // Listener callback for the video player controller
  void _videoPlayerListener() {
    if (_controller != null) {
      emit(state.copyWith(
        position: _controller!.value.position,
        duration: _controller!.value.duration,
        isPlaying: _controller!.value.isPlaying,
      ));
    }
  }

  // Toggle play/pause state
  void togglePlayPause() {
    if (state.isYoutubeVideo) return; // YouTube controls handled by WebView

    if (state.controller == null) return;

    if (state.controller!.value.isPlaying) {
      state.controller!.pause();
    } else {
      state.controller!.play();

      // Auto-hide controls after a few seconds when playing
      Future.delayed(const Duration(seconds: 3), () {
        if (state.isPlaying) {
          toggleControlsVisibility(false);
        }
      });
    }

    toggleControlsVisibility(!state.isControlsVisible);
  }

  // Toggle fullscreen mode
  void toggleFullScreen() {
    final newFullScreenState = !state.isFullScreen;

    if (newFullScreenState) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    emit(state.copyWith(isFullScreen: newFullScreenState));
  }

  // Toggle controls visibility
  void toggleControlsVisibility(bool? visible) {
    emit(state.copyWith(
      isControlsVisible: visible ?? !state.isControlsVisible,
    ));
  }

  // Helper to check if a URL is a YouTube URL
  bool isYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  // Helper methods for YouTube URL handling
  bool _isYoutubeUrl(String url) {
    return isYoutubeUrl(url);
  }

  String? _getYoutubeEmbedUrl(String url) {
    // Extract video ID from YouTube URL
    String? videoId;

    // Handle youtu.be short links
    if (url.contains('youtu.be/')) {
      final uri = Uri.parse(url);
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    // Handle youtube.com/watch?v= links
    else if (url.contains('youtube.com/watch')) {
      final uri = Uri.parse(url);
      videoId = uri.queryParameters['v'];
    }
    // Handle youtube.com/embed/ links
    else if (url.contains('youtube.com/embed/')) {
      final uri = Uri.parse(url);
      videoId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
    }

    if (videoId != null) {
      // Configure YouTube parameters:
      // fs=0: Disable fullscreen button
      // rel=0: Don't show related videos
      // modestbranding=1: Minimal YouTube branding
      // playsinline=1: Play inline, don't open in fullscreen on mobile
      return 'https://www.youtube.com/embed/$videoId?autoplay=0&controls=1&showinfo=0&fs=0&rel=0&playsinline=1&modestbranding=1';
    }

    return null;
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void retryLoadVideo() {
    emit(state.copyWith(
      isError: false,
      isInitialized: false,
      controller: null,
      webViewController: null,
    ));

    if (isYoutubeUrl(state.videoUrl)) {
      _initializeYoutubePlayer();
    } else {
      _initializeVideoPlayer();
    }
  }

  @override
  Future<void> close() {
    // Reset to portrait only when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (_controller != null) {
      _controller!.removeListener(_videoPlayerListener);
      _controller!.dispose();
    }
    return super.close();
  }
}
