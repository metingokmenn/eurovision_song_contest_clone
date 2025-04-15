import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/constant_index.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isSelected: state.index == 0,
                    onTap: () => context.read<NavigationCubit>().updateIndex(0),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.search_outlined,
                    activeIcon: Icons.search,
                    label: 'Search',
                    isSelected: state.index == 1,
                    onTap: () => context.read<NavigationCubit>().updateIndex(1),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isSelected: state.index == 2,
                    onTap: () => context.read<NavigationCubit>().updateIndex(2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.magenta.withAlpha(16) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.magenta : AppColors.textTertiary,
              size: 24,
            ),
            AppSizedBox.xsmall,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.magenta : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
