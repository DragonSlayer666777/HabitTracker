import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('About'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'HabitTracker',
              applicationVersion: '1.0',
              children: [const Text('Simple habit tracking app to stay consistent.')],
            ),
          ),
          // Add more settings as needed, e.g., theme, export data
        ],
      ),
    );
  }
}