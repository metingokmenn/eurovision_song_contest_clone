import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/core/widgets/selectors/bottom_sheet_selector.dart';

class ContestantSelector extends StatelessWidget {
  final List<dynamic> contestants;
  final dynamic selectedContestant;

  const ContestantSelector({
    Key? key,
    required this.contestants,
    this.selectedContestant,
  }) : super(key: key);

  static void show(BuildContext context, List<dynamic>? contestants,
      int? selectedContestantId) {
    if (contestants == null || contestants.isEmpty) return;

    // Grab the HomeCubit before opening the bottom sheet
    final homeCubit = context.read<HomeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: homeCubit,
          child: _ContestantSelectorContent(
            contestants: contestants,
            selectedContestantId: selectedContestantId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find current contestant by id
    final currentContestantId = selectedContestant?.id;
    final currentContestant = contestants.firstWhere(
      (c) => c?.id == currentContestantId,
      orElse: () => null,
    );

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.white;

    return GestureDetector(
      onTap: () => show(context, contestants, currentContestantId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor,
        ),
        child: Row(
          children: [
            if (currentContestant != null) ...[
              _buildCountryAvatar(context, currentContestant.country),
              AppSizedBox.widthSMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentContestant.artist ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (currentContestant.song != null)
                      Text(
                        currentContestant.song!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                'Select Contestant',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
            const Spacer(),
            Icon(Icons.keyboard_arrow_down, color: textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryAvatar(BuildContext context, String? country) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? Color.fromARGB(40, 216, 27, 96)
        : Color.fromARGB(20, 216, 27, 96);

    if (country == null || country.isEmpty) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.help_outline,
          color: AppColors.magenta,
          size: 18,
        ),
      );
    }

    // Country code logic (simplified)
    String countryCode = country.length <= 2
        ? country.toUpperCase()
        : country.substring(0, 2).toUpperCase();

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
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
}

class _ContestantSelectorContent extends StatelessWidget {
  final List<dynamic> contestants;
  final int? selectedContestantId;

  const _ContestantSelectorContent({
    Key? key,
    required this.contestants,
    required this.selectedContestantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetSelector<dynamic>(
      title: 'SELECT CONTESTANT',
      items: contestants,
      selectedItem: contestants.firstWhere(
        (contestant) => contestant?.id == selectedContestantId,
        orElse: () => null,
      ),
      onItemSelected: (contestant) {
        context.read<HomeCubit>().selectContestant(contestant.id);
      },
      itemBuilder: (context, contestant, isSelected) {
        if (contestant == null) return const SizedBox.shrink();

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final secondaryTextColor =
            isDarkMode ? Colors.grey[400] : AppColors.textSecondary;
        final tertiaryTextColor =
            isDarkMode ? Colors.grey[500] : AppColors.textTertiary;
        final backgroundColor = isSelected
            ? Color.fromARGB(isDarkMode ? 51 : 25, 216, 27, 96)
            : (isDarkMode ? Colors.grey[800] : Colors.white);
        final borderColor = isSelected
            ? AppColors.magenta
            : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!);

        return SelectionItem(
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          child: Row(
            children: [
              _buildCountryAvatar(context, contestant.country),
              AppSizedBox.widthSMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      contestant.artist ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? AppColors.magenta : textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (contestant.song != null)
                      Text(
                        contestant.song,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? const Color.fromARGB(204, 216, 27, 96)
                              : secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      contestant.country ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? const Color.fromARGB(153, 216, 27, 96)
                            : tertiaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.magenta,
                  size: 20,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryAvatar(BuildContext context, String? country) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? Color.fromARGB(40, 216, 27, 96)
        : Color.fromARGB(20, 216, 27, 96);

    if (country == null || country.isEmpty) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.help_outline,
          color: AppColors.magenta,
          size: 18,
        ),
      );
    }

    // Country code logic (simplified)
    String countryCode = country.length <= 2
        ? country.toUpperCase()
        : country.substring(0, 2).toUpperCase();

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
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
}
