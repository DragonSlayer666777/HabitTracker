import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';
import '../services/notification_service.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  final Box _box = Hive.box('habits');

  HabitProvider() {
    _loadHabits();
  }

  List<Habit> get habits => _habits;

  void _loadHabits() {
    _habits = _box.values.cast<Habit>().toList();
    notifyListeners();
  }

  void addHabit(String name, String description, int iconCodePoint, DateTime? reminderTime) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final habit = Habit(
      id: id,
      name: name,
      description: description,
      iconCodePoint: iconCodePoint,
      reminderTime: reminderTime,
    );
    _habits.add(habit);
    _box.put(id, habit);
    if (reminderTime != null) NotificationService().scheduleNotification(habit);
    notifyListeners();
  }

  void updateHabit(Habit habit) {
    _box.put(habit.id, habit);
    if (habit.reminderTime != null) {
      NotificationService().scheduleNotification(habit);
    }
    notifyListeners();
  }

  void deleteHabit(Habit habit) {
    _habits.remove(habit);
    _box.delete(habit.id);
    NotificationService().cancelNotification(int.parse(habit.id));
    notifyListeners();
  }

  Color getHabitColor(Habit habit) {
    final todayKey = _getTodayKey();
    if (!habit.completions.containsKey(todayKey)) {
      return Colors.grey; // Pending
    }
    return habit.completions[todayKey]! ? Colors.green : Colors.red;
  }

  void markHabit(Habit habit, bool done) {
    final todayKey = _getTodayKey();
    habit.completions[todayKey] = done;
    updateHabit(habit);
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  double calculateWinrate({int month = -1, int year = -1}) {
    final now = DateTime.now();
    month = month == -1 ? now.month : month;
    year = year == -1 ? now.year : year;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    int completedDays = 0;
    for (var habit in _habits) {
      for (int day = 1; day <= daysInMonth; day++) {
        final key = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        if (habit.completions[key] == true) completedDays++;
      }
    }
    final totalPossible = daysInMonth * _habits.length;
    return totalPossible > 0 ? (completedDays / totalPossible) * 100 : 0;
  }

  List<double> getYearlyWinrates(int year) {
    return List.generate(12, (m) => calculateWinrate(month: m + 1, year: year));
  }

  int getTotalCompletions(int year) {
    int total = 0;
    for (var habit in _habits) {
      total += habit.completions.values.where((v) => v && habit.completions.keys.where((k) => int.parse(k.split('-')[0]) == year).isNotEmpty).length;
    }
    return total;
  }
  

}