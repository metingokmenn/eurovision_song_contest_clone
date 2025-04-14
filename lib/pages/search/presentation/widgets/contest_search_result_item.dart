import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/contest/data/models/contest_model.dart';
import 'package:flutter/material.dart';

class ContestSearchResultItem extends StatelessWidget {
  final ContestModel contest;
  final VoidCallback onTap;

  const ContestSearchResultItem({
    super.key,
    required this.contest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo or placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.magenta.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: contest.logoUrl != null && contest.logoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        contest.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.music_note,
                          color: AppColors.magenta,
                          size: 30,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.music_note,
                      color: AppColors.magenta,
                      size: 30,
                    ),
            ),
            const SizedBox(width: 12),
            // Contest details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eurovision ${contest.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (contest.slogan != null && contest.slogan!.isNotEmpty)
                    Text(
                      contest.slogan!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '${contest.city ?? 'Unknown city'}, ${contest.country ?? 'Unknown country'}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.magenta,
            ),
          ],
        ),
      ),
    );
  }
}
