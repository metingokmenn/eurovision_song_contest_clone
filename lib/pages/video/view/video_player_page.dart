import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/pages/video/cubit/video_player_cubit.dart';
import 'package:eurovision_song_contest_clone/pages/video/widgets/video_player_page_content.dart';

class VideoPlayerPage extends StatelessWidget {
  final String videoUrl;
  final String? videoTitle;
  final String? artistName;
  final String? songName;
  final String? lyrics;

  const VideoPlayerPage({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
    this.artistName,
    this.songName,
    this.lyrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoPlayerCubit(
        videoUrl: videoUrl,
        title: videoTitle,
        artistName: artistName,
        songName: songName,
        lyrics: lyrics,
      )..addOrientationListener(),
      child: VideoPlayerPageContent(),
    );
  }
}
