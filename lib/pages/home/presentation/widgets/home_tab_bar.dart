import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;

  const HomeTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      splashFactory: NoSplash.splashFactory,
      dividerHeight: 0,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.magenta,
          width: 2.0,
        ),
      ),
      tabAlignment: TabAlignment.center,
      indicatorAnimation: TabIndicatorAnimation.elastic,
      padding: const EdgeInsets.symmetric(vertical: 16),
      labelColor: Colors.black,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
      ),
      unselectedLabelColor: Colors.black,
      isScrollable: true,
      controller: controller,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(
          text: 'Contestants',
        ),
        Tab(
          text: 'Voting',
        ),
        Tab(
          text: 'Rounds',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
