import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/theme/theme_index.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildThemeOption(
                      context,
                      title: 'Light Theme',
                      icon: Icons.light_mode,
                      isSelected: state.themeMode == ThemeMode.light,
                      onTap: () => context
                          .read<ThemeCubit>()
                          .setThemeMode(ThemeMode.light),
                    ),
                    const SizedBox(height: 8),
                    _buildThemeOption(
                      context,
                      title: 'Dark Theme',
                      icon: Icons.dark_mode,
                      isSelected: state.themeMode == ThemeMode.dark,
                      onTap: () => context
                          .read<ThemeCubit>()
                          .setThemeMode(ThemeMode.dark),
                    ),
                    const SizedBox(height: 8),
                    _buildThemeOption(
                      context,
                      title: 'System Default',
                      icon: Icons.settings_brightness,
                      isSelected: state.themeMode == ThemeMode.system,
                      onTap: () => context
                          .read<ThemeCubit>()
                          .setThemeMode(ThemeMode.system),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(26, 216, 27, 96) // 10% opacity of AppColors.magenta
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.magenta : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.magenta : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.magenta : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.magenta,
              ),
          ],
        ),
      ),
    );
  }
}
