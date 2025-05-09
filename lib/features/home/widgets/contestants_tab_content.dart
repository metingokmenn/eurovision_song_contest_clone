import 'package:eurovision_song_contest_clone/core/utils/country_code_converter.dart';

import 'package:eurovision_song_contest_clone/core/widgets/selectors/contestant_selector.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_state.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/video/view/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constant_index.dart';

class ContestantsTabContent extends StatelessWidget {
  const ContestantsTabContent({super.key, required this.contest});

  final ContestModel contest;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.currentContestant != current.currentContestant ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContestantsDropdown(context, state),
                    AppSizedBox.large,
                    if (state.isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.magenta,
                        ),
                      )
                    else if (state.currentContestant != null)
                      _buildSelectedContestantInfo(context, state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_outline,
                color: AppColors.magenta,
                size: 30,
              ),
              AppSizedBox.widthSMedium,
              Text(
                'Contestants',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          AppSizedBox.small,
          Text(
            'Explore all artists competing in Eurovision ${contest.year}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestantsDropdown(BuildContext context, HomeState state) {
    // Get the currently selected contestant ID or default to the first contestant
    /* final currentContestantId = state.currentContestant?.id ??
        (contest.contestants?.isNotEmpty == true
            ? contest.contestants!.first!.id
            : null); */

    return ContestantSelector(
      contestants: contest.contestants ?? [],
      selectedContestant: state.currentContestant,
    );
  }

  Widget _buildSelectedContestantInfo(BuildContext context, HomeState state) {
    final contestant = state.currentContestant!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Artist header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCountryFlag(contestant.country),
                  AppSizedBox.widthMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contestant.artist ?? 'Unknown',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppSizedBox.small,
                        if (contestant.song != null) ...[
                          Text(
                            contestant.song!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        AppSizedBox.small,
                        Text(
                          contestant.country ?? 'Unknown Country',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        AppSizedBox.large,
        Text(
          'Song Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        AppSizedBox.medium,

        // Song details section
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailItem(
                context: context,
                label: 'Country',
                value: contestant.country ?? 'Unknown',
                icon: Icons.flag_outlined,
              ),
              if (contestant.tone != null)
                _buildDetailItem(
                  context: context,
                  label: 'Key',
                  value: contestant.tone!,
                  icon: Icons.music_note_outlined,
                ),
              if (contestant.bpm != null)
                _buildDetailItem(
                  context: context,
                  label: 'BPM',
                  value: contestant.bpm.toString(),
                  icon: Icons.speed_outlined,
                ),
              if (contestant.broadcaster != null)
                _buildDetailItem(
                  context: context,
                  label: 'Broadcaster',
                  value: contestant.broadcaster!,
                  icon: Icons.tv_outlined,
                ),
              if (contestant.stageDirector != null)
                _buildDetailItem(
                  context: context,
                  label: 'Stage Director',
                  value: contestant.stageDirector!,
                  icon: Icons.directions_outlined,
                ),
              if (contestant.spokesperson != null)
                _buildDetailItem(
                  context: context,
                  label: 'Spokesperson',
                  value: contestant.spokesperson!,
                  icon: Icons.record_voice_over_outlined,
                  showDivider: false,
                ),
            ],
          ),
        ),

        // Media section
        if (contestant.videoUrls != null &&
            contestant.videoUrls!.isNotEmpty) ...[
          AppSizedBox.large,
          Text(
            'Media',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          AppSizedBox.medium,
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.video_library_outlined,
                      color: AppColors.magenta,
                      size: 22,
                    ),
                    AppSizedBox.widthSmall,
                    Text(
                      'Videos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                AppSizedBox.medium,
                ...contestant.videoUrls!
                    .where((url) => url != null)
                    .map((url) => _buildVideoLink(url!)),
              ],
            ),
          ),
        ],

        // Lyrics section
        if (contestant.lyrics != null && contestant.lyrics!.isNotEmpty) ...[
          AppSizedBox.large,
          Text(
            'Lyrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          AppSizedBox.medium,
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.text_fields_outlined,
                      color: AppColors.magenta,
                      size: 22,
                    ),
                    AppSizedBox.widthSmall,
                    Expanded(
                      child: Text(
                        'Song Lyrics',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSizedBox.medium,
                _buildLyricsContent(context, contestant),
              ],
            ),
          ),
        ],
        AppSizedBox.large,
      ],
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.magenta.withAlpha(16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.magenta,
                  size: 20,
                ),
              ),
              AppSizedBox.widthMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    AppSizedBox.xsmall,
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 70),
      ],
    );
  }

  /* Widget _buildCountryAvatar(String? country) {
    if (country == null || country.isEmpty) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color.fromARGB(20, 216, 27, 96),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.help_outline,
          color: AppColors.magenta,
          size: 18,
        ),
      );
    }

    // Get country code safely
    String countryCode;
    if (country.length <= 2) {
      // If already a country code
      countryCode = country.toUpperCase();
    } else {
      // Try to extract initials from country name
      countryCode = _getCountryCode(country);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color.fromARGB(20, 216, 27, 96),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        countryCode,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.magenta,
          fontSize: 13,
        ),
      ),
    );
  } */

  Widget _buildCountryFlag(String? country) {
    if (country == null || country.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(20, 216, 27, 96),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.flag_outlined,
          color: AppColors.magenta,
          size: 30,
        ),
      );
    }

    // Get a safe country code without potential string range errors
    final countryCode = _getSafeCountryCode(country);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 216, 27, 96),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.flag_outlined,
            color: AppColors.magenta,
            size: 24,
          ),
          AppSizedBox.xsmall,
          Text(
            countryCode,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.magenta,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getSafeCountryCode(String country) {
    try {
      // Check if it's already a country code (2 chars)
      if (country.length == 2) {
        return country.toUpperCase();
      }

      // Try to get the corresponding country code for a known country name
      for (final entry in CountryCodeConverter.countryMap.entries) {
        if (entry.value.toLowerCase() == country.toLowerCase()) {
          return entry.key;
        }
      }

      // If not found in the map, use the regular method
      return _getCountryCode(country);
    } catch (e) {
      // Return a safe value if there's any string manipulation error
      return country.isNotEmpty ? country[0].toUpperCase() : '?';
    }
  }

  String _getCountryCode(String country) {
    // Handle special cases
    if (country.contains(' ')) {
      // For countries with multiple words, use first letter of each word
      final words = country.split(' ');
      if (words.length >= 2) {
        return '${_safeFirstChar(words[0])}${_safeFirstChar(words[1])}';
      }
    }

    // For single word countries, use first two letters
    if (country.length >= 2) {
      return country.substring(0, 2).toUpperCase();
    }

    // Fallback for very short names
    return country.toUpperCase();
  }

  String _safeFirstChar(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase();
  }

  Widget _buildVideoLink(String url) {
    String displayUrl = _getDisplayUrl(url);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Builder(builder: (context) {
        return InkWell(
          onTap: () => _openVideoPlayer(context, url),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.play_circle_outline,
                  color: AppColors.magenta.withAlpha(150),
                  size: 18,
                ),
              ),
              AppSizedBox.widthSMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayUrl,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Tap to play video',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _openVideoPlayer(BuildContext context, String url) {
    final state = context.read<HomeCubit>().state;
    final contestant = state.currentContestant;

    // Extract lyrics content if available
    String? lyrics;
    if (contestant?.lyrics != null && contestant!.lyrics!.isNotEmpty) {
      try {
        if (contestant.lyrics!.first?.content != null) {
          lyrics = contestant.lyrics!.first!.content;
        }
      } catch (e) {
        // Ignore errors when retrieving lyrics
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          videoUrl: url,
          videoTitle: _getVideoTitle(url),
          artistName: contestant?.artist,
          songName: contestant?.song,
          lyrics: lyrics,
        ),
      ),
    );
  }

  String _getVideoTitle(String url) {
    // Try to extract a meaningful title from the URL
    try {
      final uri = Uri.parse(url);

      // For YouTube URLs, extract video ID or title if possible
      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        // Extract the title from path segments if possible
        if (uri.pathSegments.isNotEmpty) {
          final lastSegment = uri.pathSegments.last;
          if (lastSegment.isNotEmpty && lastSegment != 'watch') {
            return 'YouTube Video: ${lastSegment.replaceAll('-', ' ')}';
          }
        }
        return 'YouTube Video';
      }

      // For other URLs, return the host name
      if (uri.host.isNotEmpty) {
        return 'Video from ${uri.host}';
      }
    } catch (_) {}

    // Default fallback
    return 'Video';
  }

  String _getDisplayUrl(String url) {
    // Handle null or empty URLs
    if (url.isEmpty) {
      return 'Video link';
    }

    // Try to make URL more readable
    try {
      if (url.length > 40) {
        final uri = Uri.parse(url);
        if (uri.host.isNotEmpty) {
          // Show domain and truncate the rest
          final path = uri.path.isEmpty
              ? ''
              : (uri.path.length > 20
                  ? '${uri.path.substring(0, 17)}...'
                  : uri.path);
          return '${uri.host}$path';
        } else {
          // Just truncate if can't parse properly
          return '${url.substring(0, 37)}...';
        }
      }
    } catch (e) {
      // If URL parsing fails, just return a safe truncated version
      return url.length > 40 ? '${url.substring(0, 37)}...' : url;
    }

    return url;
  }

  Widget _buildLyricsContent(BuildContext context, dynamic contestant) {
    // Extract lyrics text based on different possible structures
    String lyricsText = '';

    try {
      if (contestant.lyrics is String) {
        lyricsText = contestant.lyrics;
      } else if (contestant.lyrics is List && contestant.lyrics!.isNotEmpty) {
        if (contestant.lyrics!.first is Map ||
            contestant.lyrics!.first?.content != null) {
          // Handle LyricsModel type
          lyricsText = contestant.lyrics!.first?.content ??
              'No lyrics content available';
        } else {
          // Handle list of strings
          lyricsText = contestant.lyrics!
              .where((line) => line != null)
              .map((line) => line.toString())
              .join('\n');
        }
      }
    } catch (e) {
      lyricsText = 'Could not display lyrics: $e';
    }

    if (lyricsText.isEmpty) {
      return const Text('No lyrics available');
    }

    // Create a scrollable container for long lyrics
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Text(
          lyricsText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
        ),
      ),
    );
  }
}
