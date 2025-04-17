import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomeTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final Function(int)? onTabChanged;

  const HomeTabBar({
    super.key,
    required this.controller,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(10, 0, 0, 0),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        dividerHeight: 0,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.magenta,
              width: 3.0,
            ),
          ),
        ),
        tabAlignment: TabAlignment.center,
        indicatorAnimation: TabIndicatorAnimation.elastic,
        padding: const EdgeInsets.symmetric(vertical: 8),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        isScrollable: true,
        controller: controller,
        onTap: onTabChanged,
        tabs: const [
          Tab(
            text: 'Overview',
            icon: Icon(Icons.home_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Contestants',
            icon: Icon(Icons.people_outline),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Voting',
            icon: Icon(Icons.how_to_vote_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Rounds',
            icon: Icon(Icons.event_note_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
