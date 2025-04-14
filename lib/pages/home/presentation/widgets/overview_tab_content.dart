import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';

import 'package:flutter/material.dart';

import '../../../../core/constants/constant_index.dart';
import '../../../../core/theme/theme_index.dart';

class OverviewTabContent extends StatelessWidget {
  final ContestModel contest;

  const OverviewTabContent({
    super.key,
    required this.contest,
  });

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
                  _buildInfoSection(context),
                  AppSizedBox.large,
                  _buildPeopleSection(context),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.magenta,
            AppColors.magenta.withAlpha(180),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppPadding.large,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Eurovision ${contest.year}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                        ),
                        if (contest.slogan != null) ...[
                          AppSizedBox.small,
                          Text(
                            contest.slogan!,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withAlpha(230),
                                      fontStyle: FontStyle.italic,
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppSizedBox.medium,
                  _buildLogoDisplay(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoDisplay(BuildContext context) {
    if (contest.logoUrl == null) {
      // Display default music note icon when logo is not available
      return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.music_note,
          size: 36,
          color: AppColors.magenta,
        ),
      );
    }

    // When logo is available
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 100,
        maxHeight: 100,
        minWidth: 70,
        minHeight: 70,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          contest.logoUrl!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image_outlined, size: 42),
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress?.expectedTotalBytes !=
                      loadingProgress?.cumulativeBytesLoaded
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.magenta,
                        strokeWidth: 2,
                      ),
                    )
                  : child,
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
        ),
        AppSizedBox.large,
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
              // Host City & Location
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.magenta.withAlpha(12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.magenta,
                        size: 26,
                      ),
                    ),
                    AppSizedBox.widthMedium,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Host City',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AppSizedBox.xsmall,
                          Text(
                            '${contest.city}, ${contest.country}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              // Arena
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.magenta.withAlpha(12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.stadium_outlined,
                        color: AppColors.magenta,
                        size: 26,
                      ),
                    ),
                    AppSizedBox.widthMedium,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Venue',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AppSizedBox.xsmall,
                          Text(
                            contest.arena ?? 'Not specified',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Add more info sections as needed
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'People',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
        ),
        AppSizedBox.large,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Presenters Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.mic_outlined,
                      color: AppColors.magenta,
                      size: 22,
                    ),
                    AppSizedBox.widthSmall,
                    Text(
                      'Presenters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (contest.presenters != null && contest.presenters!.isNotEmpty)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: contest.presenters!.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final presenter = contest.presenters![index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.magenta.withAlpha(16),
                            child: Text(
                              presenter.substring(0, 1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.magenta,
                              ),
                            ),
                          ),
                          AppSizedBox.widthMedium,
                          Expanded(
                            child: Text(
                              presenter,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text('No presenters listed'),
                ),

              const Divider(height: 24, thickness: 1),

              // Broadcasters Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tv_outlined,
                      color: AppColors.magenta,
                      size: 22,
                    ),
                    AppSizedBox.widthSmall,
                    Text(
                      'Broadcasters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (contest.broadcasters != null &&
                  contest.broadcasters!.isNotEmpty)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: contest.broadcasters!.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final broadcaster = contest.broadcasters![index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.magenta.withAlpha(16),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              broadcaster.substring(0, 1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.magenta,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          AppSizedBox.widthMedium,
                          Expanded(
                            child: Text(
                              broadcaster,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text('No broadcasters listed'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
