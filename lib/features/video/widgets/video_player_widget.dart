import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/video/cubit/video_player_cubit.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;
  final String? title;
  final String? artistName;
  final String? songName;
  final String? lyrics;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.title,
    this.artistName,
    this.songName,
    this.lyrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoPlayerCubit(
        videoUrl: videoUrl,
        title: title,
        artistName: artistName,
        songName: songName,
        lyrics: lyrics,
      ),
      child: _VideoPlayerContent(),
    );
  }
}

class _VideoPlayerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (context, state) {
        if (state.isError) {
          return _buildErrorWidget();
        }

        if (state.isYoutubeVideo) {
          return _buildYoutubePlayer(context, state, state.isFullScreen);
        }

        return state.isInitialized && state.controller != null
            ? _buildVideoPlayer(context, state, state.isFullScreen)
            : const Center(
                child: CircularProgressIndicator(
                  color: AppColors.magenta,
                ),
              );
      },
    );
  }

  Widget _buildVideoPlayer(
      BuildContext context, VideoPlayerState state, bool isFullScreen) {
    final cubit = context.read<VideoPlayerCubit>();

    // For fullscreen mode, use full screen size
    if (isFullScreen) {
      return Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Video centered in container
            Center(
              child: AspectRatio(
                aspectRatio: state.controller!.value.aspectRatio,
                child: VideoPlayer(state.controller!),
              ),
            ),
            // Overlay controls that show on tap
            _buildPlayPauseOverlay(context, state),
          ],
        ),
      );
    }

    // For portrait mode, use card layout
    return Column(
      children: [
        // Video container
        Expanded(
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            color: Colors.black,
            shape: const RoundedRectangleBorder(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video player with responsive aspect ratio
                Expanded(
                  child: AspectRatio(
                    aspectRatio: state.controller!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(state.controller!),
                        _buildPlayPauseOverlay(context, state),
                      ],
                    ),
                  ),
                ),
                // Video title
                if (state.title != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      state.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: VideoProgressIndicator(
                    state.controller!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: AppColors.magenta,
                      bufferedColor: AppColors.magenta.withAlpha(60),
                      backgroundColor: Colors.grey.shade800,
                    ),
                  ),
                ),
                // Duration info
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cubit.formatDuration(state.position),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        cubit.formatDuration(state.duration),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lyrics section if available (only in portrait mode)
        if (!isFullScreen && state.lyrics != null && state.lyrics!.isNotEmpty)
          _buildLyricsSection(context, state),
      ],
    );
  }

  Widget _buildLyricsSection(BuildContext context, VideoPlayerState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lyrics header
          Row(
            children: [
              const Icon(
                Icons.music_note,
                color: AppColors.magenta,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Lyrics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Scrollable lyrics container
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                state.lyrics!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: AppColors.text,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYoutubePlayer(
      BuildContext context, VideoPlayerState state, bool isFullScreen) {
    if (state.webViewController == null) {
      return _buildErrorWidget();
    }

    if (isFullScreen) {
      return SizedBox.expand(
        child: WebViewWidget(controller: state.webViewController!),
      );
    }

    return Column(
      children: [
        // YouTube player container
        Expanded(
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            color: Colors.black,
            shape: const RoundedRectangleBorder(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use a fixed aspect ratio for YouTube videos
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: WebViewWidget(controller: state.webViewController!),
                  ),
                ),
                if (state.title != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      state.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'YouTube video player',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lyrics section if available (only in portrait mode)
        if (!isFullScreen && state.lyrics != null && state.lyrics!.isNotEmpty)
          _buildLyricsSection(context, state),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return const Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.orange,
              size: 40,
            ),
            SizedBox(height: 12),
            Text(
              'Could not load video',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'The video format may not be supported',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayPauseOverlay(BuildContext context, VideoPlayerState state) {
    final cubit = context.read<VideoPlayerCubit>();

    return GestureDetector(
      onTap: () {
        // Toggle the overlay controls visibility
        cubit.toggleControlsVisibility(null);
      },
      child: AnimatedOpacity(
        opacity: state.isControlsVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          children: [
            // Semi-transparent background
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            // Centered play/pause button
            Center(
              child: IconButton(
                icon: Icon(
                  state.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 64.0,
                ),
                onPressed: () {
                  cubit.togglePlayPause();
                },
              ),
            ),
            // Fullscreen button at bottom right
            Positioned(
              bottom: 16,
              right: 16,
              child: IconButton(
                icon: Icon(
                  state.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 28.0,
                ),
                onPressed: () {
                  cubit.toggleFullScreen(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
