import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Separate variables for in-app and email notifications
  bool _inAppNotificationsEnabled = false;
  bool _emailNotificationsEnabled = false;

  // Method to toggle In-App notifications
  void _toggleInAppNotifications(bool value) {
    setState(() {
      _inAppNotificationsEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'In-app Notifications ${_inAppNotificationsEnabled ? "enabled" : "disabled"}'),
      ),
    );
  }

  // Method to toggle Email notifications
  void _toggleEmailNotifications(bool value) {
    setState(() {
      _emailNotificationsEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Email Notifications ${_emailNotificationsEnabled ? "enabled" : "disabled"}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // In-App Notifications Switch
            SwitchListTile(
              title: const Text('Enable In-app Notifications'),
              value: _inAppNotificationsEnabled,
              onChanged: _toggleInAppNotifications,
            ),
            ListTile(
              title: const Text('In-app Notifications'),
              onTap: () {
                // You can add functionality here if needed
              },
            ),
            const Divider(),

            // Email Notifications Switch
            SwitchListTile(
              title: const Text('Enable Email Notifications'),
              value: _emailNotificationsEnabled,
              onChanged: _toggleEmailNotifications,
            ),
            ListTile(
              title: const Text('Email Notifications'),
              onTap: () {
                // You can add functionality here if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
