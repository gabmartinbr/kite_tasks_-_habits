import 'package:flutter/material.dart';

class Habit {
  String name;
  Color color;
  List<DateTime> completedDates;
  int currentStreak;
  DateTime createdAt;
  DateTime? deletedAt; // Null = Activo, Con fecha = Archivado

  Habit({
    required this.name,
    required this.color,
    required this.completedDates,
    this.currentStreak = 0,
    required this.createdAt,
    this.deletedAt,
  });

  bool get isCompletedToday {
    DateTime now = DateTime.now();
    return completedDates.any((d) => d.year == now.year && d.month == now.month && d.day == now.day);
  }
}