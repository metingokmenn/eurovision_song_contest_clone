import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:eurovision_song_contest_clone/features/contest/data/models/round_model.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constant_index.dart';

class RoundsTabContent extends StatelessWidget {
  const RoundsTabContent({super.key, required this.contest});

  final ContestModel contest;

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Competition Schedule',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  AppSizedBox.medium,
                  _buildRoundsTimeline(context),
                ],
              ),
            ),
          ],
        ),
      ),
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
                Icons.event_note_outlined,
                color: AppColors.magenta,
                size: 30,
              ),
              AppSizedBox.widthSMedium,
              Text(
                'Competition Rounds',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          AppSizedBox.small,
          Text(
            'Eurovision ${contest.year} event schedule',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundsTimeline(BuildContext context) {
    if (contest.rounds == null || contest.rounds!.isEmpty) {
      return _buildNoRoundsInfo(context);
    }

    return Container(
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
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: contest.rounds?.length ?? 0,
        itemBuilder: (context, index) {
          final round = contest.rounds?[index];
          final isLastItem = index == (contest.rounds?.length ?? 0) - 1;

          return _buildRoundTimelineItem(
            context: context,
            round: round,
            isLastItem: isLastItem,
            roundNumber: index + 1,
          );
        },
      ),
    );
  }

  Widget _buildNoRoundsInfo(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.magenta.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_busy_outlined,
              color: AppColors.magenta,
              size: 24,
            ),
          ),
          AppSizedBox.widthMedium,
          Expanded(
            child: Text(
              'No rounds information available for this contest.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundTimelineItem({
    required BuildContext context,
    required RoundModel? round,
    required bool isLastItem,
    required int roundNumber,
  }) {
    final name = round?.name ?? 'Unnamed Round';
    final date = round?.date ?? 'Date not available';
    final time = round?.time ?? 'Time not available';

    // Format the round name for display
    final formattedName = _formatRoundName(name);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Round number indicator with timeline
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.magenta,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      roundNumber.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!isLastItem)
                    Container(
                      width: 2,
                      height: 40,
                      color: AppColors.magenta.withAlpha(100),
                    ),
                ],
              ),
              AppSizedBox.widthMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    AppSizedBox.small,
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        AppSizedBox.widthSmall,
                        Text(
                          date,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.xsmall,
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        AppSizedBox.widthSmall,
                        Text(
                          time,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLastItem) const Divider(height: 1, indent: 52),
      ],
    );
  }

  /// Formats the round name to be more user-friendly and modern
  String _formatRoundName(String name) {
    // Convert to lowercase for case-insensitive comparison
    final lowerName = name.toLowerCase();

    // Check for common patterns and format appropriately
    if (lowerName.contains('semi') && lowerName.contains('final')) {
      if (lowerName.contains('1') || lowerName.contains('first')) {
        return 'First Semi-Final';
      } else if (lowerName.contains('2') || lowerName.contains('second')) {
        return 'Second Semi-Final';
      } else {
        return 'Semi-Final';
      }
    } else if (lowerName.contains('grand') && lowerName.contains('final')) {
      return 'Grand Final';
    } else if (lowerName.contains('final')) {
      return 'Final';
    }

    // If no pattern matches, capitalize each word for better presentation
    return name.split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
      return '';
    }).join(' ');
  }
}
