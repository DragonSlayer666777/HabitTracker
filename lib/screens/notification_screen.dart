import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';  // Fixed: Add this import!

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: ListView.builder(
        itemCount: provider.habits.length,
        itemBuilder: (ctx, i) {
          final habit = provider.habits[i];
          return Card(
            child: ListTile(
              leading: Icon(habit.icon, color: Colors.blue),
              title: Text(habit.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(habit.reminderTime != null ? '${habit.reminderTime!.hour}:${habit.reminderTime!.minute.toString().padLeft(2, '0')}' : 'Off'),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editReminder(context, habit),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _editReminder(BuildContext context, Habit habit) async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(habit.reminderTime ?? DateTime.now()));
    if (time != null) {
      habit.reminderTime = DateTime(0, 0, 0, time.hour, time.minute);
      Provider.of<HabitProvider>(context, listen: false).updateHabit(habit);
    }
  }
}