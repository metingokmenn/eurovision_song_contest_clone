import 'package:flutter/material.dart';

import '../../../../core/theme/theme_index.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Notification setting
            ListTile(
              leading:
                  const Icon(Icons.notifications, color: AppColors.magenta),
              title: const Text('Notifications'),
              trailing: Switch(
                value: false,
                onChanged: (_) {},
                activeColor: AppColors.magenta,
              ),
            ),

            // Language setting
            const ListTile(
              leading: Icon(Icons.language, color: AppColors.magenta),
              title: Text('Language'),
              trailing: Text('English'),
            ),

            // Data usage setting
            const ListTile(
              leading: Icon(Icons.data_usage, color: AppColors.magenta),
              title: Text('Data Usage'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
