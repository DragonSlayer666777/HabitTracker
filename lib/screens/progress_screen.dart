import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/habit_provider.dart';
import 'growth_graph_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
            ),
            eventLoader: (day) {
              final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
              bool allDone = provider.habits.every((h) => h.completions[key] == true);
              bool someDone = provider.habits.any((h) => h.completions[key] == true);
              if (allDone) return [Colors.green];
              if (someDone) return [Colors.orange];
              return [Colors.red];
            },
          ),
          Card(
            child: ListTile(
              title: const Text('Your WR'),
              subtitle: Text('${provider.calculateWinrate().toStringAsFixed(0)}%'),
              trailing: const CircleAvatar(backgroundColor: Colors.black),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.show_chart),
            label: const Text('View Growth Graph'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GrowthGraphScreen())),
          ),
        ],
      ),
    );
  }
}