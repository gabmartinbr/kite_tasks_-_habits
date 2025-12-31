import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

class StorageService {
  static const String _habitsKey = 'habits_data';
  static const String _prioritiesKey = 'priorities_data';

  // GUARDAR HÁBITOS
  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_habitsKey, encodedData);
  }

  // CARGAR HÁBITOS
  static Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsString = prefs.getString(_habitsKey);
    if (habitsString == null) return [];
    
    final List<dynamic> jsonData = jsonDecode(habitsString);
    return jsonData.map((h) => Habit.fromJson(h)).toList();
  }

  // GUARDAR PRIORIDADES (Solo el texto y el estado isDone)
  static Future<void> savePriorities(List<Map<String, dynamic>> priorities) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataToSave = priorities.map((p) => {
      'text': p['controller'].text,
      'isDone': p['isDone'],
    }).toList();
    await prefs.setString(_prioritiesKey, jsonEncode(dataToSave));
  }

  // CARGAR PRIORIDADES
  static Future<List<Map<String, dynamic>>> loadPriorities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_prioritiesKey);
    if (dataString == null) return [];
    
    return List<Map<String, dynamic>>.from(jsonDecode(dataString));
  }
}