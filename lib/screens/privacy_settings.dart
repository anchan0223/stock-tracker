import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Who can see your profile?'),
              subtitle: const Text('Set who can view your profile details.'),
              onTap: () {
                // Add action for changing profile visibility
              },
            ),
            ListTile(
              title: const Text('Data sharing preferences'),
              subtitle: const Text('Control what data you share with us.'),
              onTap: () {
                // Add action for changing data sharing preferences
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Change password'),
              onTap: () {
                // Add action for password change
              },
            ),
          ],
        ),
      ),
    );
  }
}
