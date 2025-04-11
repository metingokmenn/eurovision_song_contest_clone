import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:flutter/material.dart';

class VotingTabContent extends StatelessWidget {
  const VotingTabContent({super.key, required this.contest});

  final ContestModel contest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildVotingInfoCard(),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Voting',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
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
            Text(
              contest.voting ?? 'No voting information available.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
