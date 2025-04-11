import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:flutter/material.dart';

class RoundsTabContent extends StatelessWidget {
  const RoundsTabContent({super.key, required this.contest});

  final ContestModel contest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildRoundsInfoCard(),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Rounds',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRoundsInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: contest.rounds?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              contest.rounds?[index]?.name ?? 'No rounds available.',
            ),
            subtitle: Text(
              contest.rounds?[index]?.date ?? 'No date available.',
            ),
            trailing: Text(
              contest.rounds?[index]?.time ?? 'No time available.',
            ),
          ),
        ),
      ),
    );
  }
}
