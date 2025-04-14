import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/pages/home/presentation/cubit/home_state.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return Container(
          color: AppColors.background,
          child: SingleChildScrollView(
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
                      const SizedBox(height: 24),
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
        color: Colors.white,
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
              const SizedBox(width: 12),
              Text(
                'Contestants',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Explore all artists competing in Eurovision ${contest.year}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestantsDropdown(BuildContext context, HomeState state) {
    // Get the currently selected contestant ID or default to the first contestant
    final currentContestantId = state.currentContestant?.id ??
        (contest.contestants?.isNotEmpty == true
            ? contest.contestants!.first!.id
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Contestant',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: currentContestantId,
              hint: const Text('Select a contestant'),
              isExpanded: true,
              itemHeight: null, // Allow items to dynamically size
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.magenta.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.magenta,
                ),
              ),
              items: contest.contestants?.map((contestant) {
                    return DropdownMenuItem<int>(
                      value: contestant?.id,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCountryAvatar(contestant?.country),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    contestant?.artist ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    contestant?.song ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    contestant?.country ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
              onChanged: (int? value) {
                if (value != null) {
                  context.read<HomeCubit>().selectContestant(value);
                }
              },
            ),
          ),
        ),
      ],
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
            color: Colors.white,
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
                  const SizedBox(width: 16),
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
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
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

        const SizedBox(height: 24),
        Text(
          'Song Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 16),

        // Song details section
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          const SizedBox(height: 24),
          Text(
            'Media',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    const SizedBox(width: 8),
                    Text(
                      'Videos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...contestant.videoUrls!
                    .where((url) => url != null)
                    .map((url) => _buildVideoLink(url!)),
              ],
            ),
          ),
        ],

        // Lyrics section
        if (contestant.lyrics != null && contestant.lyrics!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Lyrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
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
                    const SizedBox(width: 8),
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
                const SizedBox(height: 16),
                _buildLyricsContent(context, contestant),
              ],
            ),
          ),
        ],
        const SizedBox(height: 30),
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
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
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

  Widget _buildCountryAvatar(String? country) {
    if (country == null || country.isEmpty) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.magenta.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.help_outline,
          color: AppColors.magenta,
          size: 18,
        ),
      );
    }

    final countryCode = _getCountryCode(country);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.magenta.withAlpha(20),
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
  }

  Widget _buildCountryFlag(String? country) {
    if (country == null || country.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.magenta.withAlpha(20),
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
        color: AppColors.magenta.withAlpha(20),
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
          const SizedBox(height: 4),
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
          const SizedBox(width: 12),
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
                  'Tap to open video',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Text(
          lyricsText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: AppColors.text,
              ),
        ),
      ),
    );
  }
}
