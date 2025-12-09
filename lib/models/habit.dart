// lib/models/habit.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  // Simpan sebagai int (codePoint) + family biar aman
  @HiveField(3)
  int iconCodePoint;

  @HiveField(4)
  String iconFontFamily; // biasanya 'MaterialIcons'

  @HiveField(5)
  DateTime? reminderTime;

  @HiveField(6)
  Map<String, bool> completions; // '2025-12-08': true/false

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    required this.iconCodePoint,
    this.iconFontFamily = 'MaterialIcons',
    this.reminderTime,
    Map<String, bool>? completions,
  }) : completions = completions ?? {};

  // Helper biar gampang dipake di UI
  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily);
}