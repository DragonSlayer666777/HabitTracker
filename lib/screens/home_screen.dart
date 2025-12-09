import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'add_habit_screen.dart';
import 'progress_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),

      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        elevation: 8,
        child: const Icon(Icons.add, size: 36),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      
      body: provider.habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No habits yet',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Get Started', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 90), 
              itemCount: provider.habits.length,
              itemBuilder: (ctx, i) {
                final habit = provider.habits[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: provider.getHabitColor(habit),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(habit.icon, color: Colors.white, size: 32),
                    ),
                    title: Text(
                      habit.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    onTap: () => _showConfirmationDialog(context, habit),
                  ),
                );
              },
            ),
    );
  }

  
  void _showConfirmationDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Did you ${habit.name} Today?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 50),
            onPressed: () {
              Provider.of<HabitProvider>(context, listen: false).markHabit(habit, false);
              Navigator.pop(ctx);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green, size: 50),
            onPressed: () {
              Provider.of<HabitProvider>(context, listen: false).markHabit(habit, true);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.redAccent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('HabitTracker', style: TextStyle(color: Colors.white, fontSize: 26)),
                Text('Stay Hard', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: true,
            selectedTileColor: Colors.redAccent.withOpacity(0.3),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Progress'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
    );
  }
}