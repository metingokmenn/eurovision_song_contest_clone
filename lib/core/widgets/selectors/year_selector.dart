import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:eurovision_song_contest_clone/features/home/presentation/cubit/home_cubit.dart';
import 'package:eurovision_song_contest_clone/core/widgets/selectors/bottom_sheet_selector.dart';

class YearSelector extends StatelessWidget {
  final List<int> availableYears;
  final int selectedYear;

  const YearSelector({
    Key? key,
    required this.availableYears,
    required this.selectedYear,
  }) : super(key: key);

  static void show(
      BuildContext context, List<int> availableYears, int selectedYear) {
    if (availableYears.isEmpty) return;

    // Grab the HomeCubit before opening the bottom sheet
    final homeCubit = context.read<HomeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: homeCubit,
          child: _YearSelectorContent(
            availableYears: availableYears,
            selectedYear: selectedYear,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    return GestureDetector(
      onTap: () => show(context, availableYears, selectedYear),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(8.0),
          color: isDarkMode ? Colors.grey[800] : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Eurovision $selectedYear',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: textColor),
          ],
        ),
      ),
    );
  }
}

class _YearSelectorContent extends StatelessWidget {
  final List<int> availableYears;
  final int selectedYear;

  const _YearSelectorContent({
    Key? key,
    required this.availableYears,
    required this.selectedYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetSelector<int>(
      title: 'SELECT YEAR',
      items: availableYears,
      selectedItem: selectedYear,
      useGrid: true,
      onItemSelected: (year) {
        context.read<HomeCubit>().selectYear(year);
      },
      itemBuilder: (context, year, isSelected) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.magenta
                : (isDarkMode ? Colors.grey[800] : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.magenta
                  : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            year.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black87),
            ),
          ),
        );
      },
    );
  }
}
