import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/home/data/models/contest_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constant_index.dart';

class VotingTabContent extends StatelessWidget {
  const VotingTabContent({super.key, required this.contest});

  final ContestModel contest;

  @override
  Widget build(BuildContext context) {
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
                _buildVotingSystemSection(context),
                AppSizedBox.large,
                if (!_isExceptionalYear(contest.year))
                  _buildVotingDistributionSection(context)
                else
                  _buildExceptionalYearMessage(context),
              ],
            ),
          ),
        ],
      ),
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
                Icons.how_to_vote_outlined,
                color: AppColors.magenta,
                size: 30,
              ),
              AppSizedBox.widthSMedium,
              Text(
                'Voting',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          AppSizedBox.small,
          Text(
            'Explore the Eurovision ${contest.year} voting system',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotingSystemSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voting System',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.magenta.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _isExceptionalYear(contest.year)
                          ? Icons.event_busy_outlined
                          : Icons.info_outline,
                      color: AppColors.magenta,
                      size: 24,
                    ),
                  ),
                  AppSizedBox.widthMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isExceptionalYear(contest.year)
                              ? 'Special Information'
                              : 'How Voting Works',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        AppSizedBox.sMedium,
                        Text(
                          _getVotingSystemText(contest.year),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.6,
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
      ],
    );
  }

  String _getVotingSystemText(int year) {
    if (year == 2020) {
      return 'Eurovision Song Contest 2020 was canceled due to the COVID-19 pandemic. No competition was held, and consequently, no voting took place.';
    } else if (contest.voting != null && contest.voting!.isNotEmpty) {
      return contest.voting!;
    } else {
      return 'Detailed voting information is not available for Eurovision $year.';
    }
  }

  bool _isExceptionalYear(int year) {
    // Eurovision 2020 was canceled due to COVID-19
    return year == 2020 || (contest.voting == null || contest.voting!.isEmpty);
  }

  Widget _buildExceptionalYearMessage(BuildContext context) {
    IconData icon;
    String title;
    String message;

    if (contest.year == 2020) {
      icon = Icons.event_busy_outlined;
      title = 'Contest Canceled';
      message =
          'Eurovision 2020 was canceled due to the COVID-19 pandemic. No voting took place.';
    } else {
      icon = Icons.info_outline;
      title = 'No Voting Data';
      message =
          'Voting information is not available for Eurovision ${contest.year}.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vote Distribution',
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
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                    AppSizedBox.widthMedium,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          AppSizedBox.small,
                          Text(
                            message,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVotingDistributionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vote Distribution',
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
                    Icons.bar_chart,
                    color: AppColors.magenta,
                    size: 22,
                  ),
                  AppSizedBox.widthSmall,
                  Expanded(
                    child: Text(
                      'Voting Breakdown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              AppSizedBox.medium,
              _buildVotingBreakdown(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVotingBreakdown(BuildContext context) {
    // Get voting breakdown based on the year
    final votingData = _getVotingDataForYear(contest.year);

    if (votingData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 20,
            ),
            AppSizedBox.widthSMedium,
            Expanded(
              child: Text(
                'Detailed voting breakdown not available for ${contest.year}.',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...votingData
            .map((vote) => Column(
                  children: [
                    _buildVoteTypeItem(
                      vote.name,
                      vote.percentage,
                      vote.color,
                      vote.icon,
                    ),
                    AppSizedBox.sMedium,
                  ],
                ))
            .toList(),
        AppSizedBox.small,
        Text(
          _getVotingInfoText(contest.year),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  String _getVotingInfoText(int year) {
    if (year < 1997) {
      return 'From 1956-1996, voting was primarily conducted by juries of music professionals.';
    } else if (year < 2009) {
      return 'From 1997-2008, televoting was gradually introduced to give viewers a voice.';
    } else if (year < 2016) {
      return 'From 2009-2015, televoting became the primary method with backup juries.';
    } else {
      return 'Since 2016, jury and televoting results are presented separately and then combined.';
    }
  }

  List<VoteTypeData> _getVotingDataForYear(int year) {
    // Define vote distributions based on Eurovision history
    if (year < 1997) {
      // Before 1997: Only jury voting
      return [
        VoteTypeData(
          name: 'National Juries',
          percentage: '100%',
          color: Colors.blue.shade300,
          icon: Icons.people_outline,
        ),
      ];
    } else if (year < 2004) {
      // 1997-2003: Mixed system introduced in some countries
      return [
        VoteTypeData(
          name: 'National Juries',
          percentage: '70%',
          color: Colors.blue.shade300,
          icon: Icons.people_outline,
        ),
        VoteTypeData(
          name: 'Televoting',
          percentage: '30%',
          color: Colors.green.shade300,
          icon: Icons.phone_android_outlined,
        ),
      ];
    } else if (year < 2009) {
      // 2004-2008: Televoting dominated
      return [
        VoteTypeData(
          name: 'National Juries',
          percentage: '25%',
          color: Colors.blue.shade300,
          icon: Icons.people_outline,
        ),
        VoteTypeData(
          name: 'Televoting',
          percentage: '75%',
          color: Colors.green.shade300,
          icon: Icons.phone_android_outlined,
        ),
      ];
    } else if (year < 2016) {
      // 2009-2015: Return to mixed system
      return [
        VoteTypeData(
          name: 'National Juries',
          percentage: '50%',
          color: Colors.blue.shade300,
          icon: Icons.people_outline,
        ),
        VoteTypeData(
          name: 'Televoting',
          percentage: '50%',
          color: Colors.green.shade300,
          icon: Icons.phone_android_outlined,
        ),
      ];
    } else {
      // 2016 onwards: Split voting presentation
      return [
        VoteTypeData(
          name: 'National Juries',
          percentage: '50%',
          color: Colors.blue.shade300,
          icon: Icons.people_outline,
        ),
        VoteTypeData(
          name: 'Televoting',
          percentage: '50%',
          color: Colors.green.shade300,
          icon: Icons.phone_android_outlined,
        ),
      ];
    }
  }

  Widget _buildVoteTypeItem(
      String name, String percentage, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color.withAlpha(180),
            size: 24,
          ),
          AppSizedBox.widthMedium,
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              percentage,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoteTypeData {
  final String name;
  final String percentage;
  final Color color;
  final IconData icon;

  VoteTypeData({
    required this.name,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}
