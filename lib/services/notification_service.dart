import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/habit.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInit);
    await notifications.initialize(initSettings);
  }

  Future<void> scheduleNotification(Habit habit) async {
    if (habit.reminderTime == null) return;
    final now = DateTime.now();
    var scheduledTime = tz.TZDateTime.local(
      now.year,
      now.month,
      now.day,
      habit.reminderTime!.hour,
      habit.reminderTime!.minute,
    );
    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    await notifications.zonedSchedule(
      int.parse(habit.id),
      'Habit Reminder',
      'Time to do ${habit.name}!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails('habit_channel', 'Habits', importance: Importance.high),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notifications.cancel(id);
  }
}