import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/video/cubit/video_player_cubit.dart';
import 'package:eurovision_song_contest_clone/features/video/widgets/video_player_widget.dart';

class VideoPlayerPageContent extends StatelessWidget {
  const VideoPlayerPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (context, state) {
        

        // Check if we're in landscape mode
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        // If in landscape mode, show a simpler layout
        if (isLandscape) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
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
          );
        }

        // Portrait mode with regular layout
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: state.title ?? 'Video Player',
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {
                  _shareVideo(context, state.videoUrl, state.title);
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

  // Share video URL with optional title
  void _shareVideo(BuildContext context, String videoUrl, String? title) {
    final cubit = context.read<VideoPlayerCubit>();
    final shareableUrl = cubit.getShareableUrl();

    final shareText = title != null
        ? 'Check out this video: $title\n$shareableUrl'
        : 'Check out this video: $shareableUrl';

    Share.share(shareText);
  }
}
