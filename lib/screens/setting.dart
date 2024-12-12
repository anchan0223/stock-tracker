import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue[100],
      ),
      body: ListView(
        children: [
          // Profile Section
          const ListTile(
            leading: Icon(Icons.person, size: 30, color: Colors.blue),
            title: Text(
              'User Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('View and edit your profile'),
          ),
          const Divider(),

          // General Settings
          ListTile(
            leading:
                const Icon(Icons.notifications, size: 30, color: Colors.orange),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings tapped!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security, size: 30, color: Colors.green),
            title: const Text(
              'Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings tapped!')),
              );
            },
          ),
          const Divider(),

          // Log Out Section
          ListTile(
            leading: const Icon(Icons.logout, size: 30, color: Colors.red),
            title: const Text(
              'Log Out',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Function to show a confirmation dialog for logging out
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logout(context); // Perform logout action
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to handle Firebase logout
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out user
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Go back to the login screen
        (route) => false, // Remove all previous routes from the stack
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }
}
