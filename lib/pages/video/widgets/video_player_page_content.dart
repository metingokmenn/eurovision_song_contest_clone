import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/pages/video/cubit/video_player_cubit.dart';
import 'package:eurovision_song_contest_clone/pages/video/widgets/video_player_widget.dart';

class VideoPlayerPageContent extends StatelessWidget {
  const VideoPlayerPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (context, state) {
        final cubit = context.read<VideoPlayerCubit>();

        // Check if we're in landscape mode
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        // If in landscape or fullscreen mode, show only the video
        if (isLandscape || state.isFullScreen) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: GestureDetector(
                onTap: cubit.toggleFullScreen,
                child: Center(
                  child: VideoPlayerWidget(
                    videoUrl: state.videoUrl,
                    title: state.title,
                    artistName: state.artistName,
                    songName: state.songName,
                    lyrics: state.lyrics,
                  ),
                ),
              ),
            ),
          );
        }

        // Portrait mode with regular layout
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: state.title ?? 'Video Player',
            actions: [
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: cubit.toggleFullScreen,
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality coming soon'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: VideoPlayerWidget(
              videoUrl: state.videoUrl,
              title: state.title,
              artistName: state.artistName,
              songName: state.songName,
              lyrics: state.lyrics,
            ),
          ),
        );
      },
    );
  }
}
