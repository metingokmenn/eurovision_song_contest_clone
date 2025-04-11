import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';

import 'package:flutter/material.dart';

class OverviewTabContent extends StatelessWidget {
  final ContestModel contest;

  const OverviewTabContent({
    super.key,
    required this.contest,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildHostCityCard(),
          const SizedBox(height: 16),
          _buildPresentersCard(),
          const SizedBox(height: 16),
          _buildBroadcastersCard(),
          const SizedBox(height: 16),
          _buildVotingInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eurovision ${contest.year}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contest.slogan ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: contest.logoUrl != null
                  ? Image.network(contest.logoUrl!,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.music_note, size: 60),
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress?.expectedTotalBytes !=
                                  loadingProgress?.cumulativeBytesLoaded
                              ? CircularProgressIndicator(
                                  value: loadingProgress?.cumulativeBytesLoaded
                                      .toDouble(),
                                )
                              : child)
                  : const Icon(Icons.music_note, size: 60),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostCityCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Host City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.location_city, size: 40),
              title: Text('${contest.city}, ${contest.country}'),
              subtitle: Text('Venue: ${contest.arena}'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresentersCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Presenters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...contest.presenters
                    ?.map((presenter) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              presenter.substring(0, 1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          title: Text(presenter),
                          contentPadding: EdgeInsets.zero,
                        ))
                    .toList() ??
                [],
          ],
        ),
      ),
    );
  }

  Widget _buildBroadcastersCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Broadcasters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...contest.broadcasters
                    ?.map((broadcaster) => ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              broadcaster,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(broadcaster),
                          contentPadding: EdgeInsets.zero,
                        ))
                    .toList() ??
                [],
          ],
        ),
      ),
    );
  }

  Widget _buildVotingInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voting System',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(contest.voting ?? ''),
          ],
        ),
      ),
    );
  }
}
