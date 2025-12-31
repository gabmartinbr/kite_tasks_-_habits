import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/habit_model.dart';
import 'screens/dashboard_screen.dart'; // Asegúrate de que la ruta sea correcta
import 'services/storage_service.dart';

void main() async {
  // 1. Asegurar que los widgets estén inicializados para usar SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar el formato de fechas en español
  await initializeDateFormatting('es', null);

  // 3. Cargar datos persistentes
  final savedHabits = await StorageService.loadHabits();
  final savedPrioritiesData = await StorageService.loadPriorities();

  // 4. Reconstruir la lista de prioridades con sus controladores
  // Generamos 3 espacios (o los que necesites)
  List<Map<String, dynamic>> priorities = List.generate(3, (i) {
    String text = "";
    bool done = false;
    
    if (i < savedPrioritiesData.length) {
      text = savedPrioritiesData[i]['text'] ?? "";
      done = savedPrioritiesData[i]['isDone'] ?? false;
    }
    
    return {
      'controller': TextEditingController(text: text),
      'isDone': done,
    };
  });

  runApp(MyApp(
    initialHabits: savedHabits,
    initialPriorities: priorities,
  ));
}

class MyApp extends StatelessWidget {
  final List<Habit> initialHabits;
  final List<Map<String, dynamic>> initialPriorities;

  const MyApp({
    super.key, 
    required this.initialHabits, 
    required this.initialPriorities
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kite Habits',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // O la que estés usando
      ),
      home: DashboardScreen(
        habits: initialHabits,
        priorities: initialPriorities,
      ),
    );
  }
}