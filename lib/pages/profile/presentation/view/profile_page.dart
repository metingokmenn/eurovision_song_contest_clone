import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';

import 'package:eurovision_song_contest_clone/core/widgets/common/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_section.dart';
import '../widgets/theme_selector.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Settings section
            SettingsSection(),

            // Theme selection
            ThemeSelector(),

            // Version info
            Text(
              'Eurovision Clone App v1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
