import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/screens/notes_screen.dart';
import '../models/habit_model.dart';
import '../services/storage_service.dart';
import 'add_habit_screen.dart';
import 'pomodoro_screen.dart';
import 'journal_screen.dart'; // IMPORTANTE: Asegúrate de que este nombre coincida
import 'stats_screen.dart';   // IMPORTANTE: Asegúrate de que este nombre coincida

class DashboardScreen extends StatefulWidget {
  final List<Habit> habits;
  final List<Map<String, dynamic>> priorities;

  const DashboardScreen({super.key, required this.habits, required this.priorities});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; 
  // Nota: Si JournalScreen no necesita controlador externo, puedes quitarlo de aquí
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var p in widget.priorities) {
      p['controller'].addListener(() => StorageService.savePriorities(widget.priorities));
    }
  }

  // --- NAVEGACIÓN ENTRE PANTALLAS ---
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardView(); // Tu vista de hábitos y tareas
      case 1:
        return JournalScreen(habits: widget.habits,); // Navega a la pantalla JournalScreen
      case 2:
        return StatsScreen(habits: widget.habits, priorities: widget.priorities,);   // Navega a la pantalla StatsScreen
      default:
        return _buildDashboardView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      // Menú desplegable con Pomodoro y acceso rápido a Diario
      endDrawer: _buildRightMenu(context),

      body: _getBody(),

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white24,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Journal"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "Stats"),
        ],
      ),
    );
  }

  // --- VISTA DEL DASHBOARD (CONTENIDO DE HOY) ---
  Widget _buildDashboardView() {
    final activeHabits = widget.habits.where((h) => h.deletedAt == null).toList();
    int habitCompleted = activeHabits.where((h) => h.isCompletedToday).length;
    int taskCompleted = widget.priorities.where((p) => p['isDone']).length;
    String formattedDate = DateFormat('EEEE, d MMMM', 'es').format(DateTime.now());

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formattedDate.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    const Text("Hoy", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Icono para abrir el menú lateral
                Builder(builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_open_rounded, color: Colors.white, size: 28),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                )),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                _buildSquareStat("TAREAS", "$taskCompleted/${widget.priorities.length}"),
                const SizedBox(width: 15),
                _buildSquareStat("HÁBITOS", "$habitCompleted/${activeHabits.length}"),
              ],
            ),
            const SizedBox(height: 40),
            _buildPrioritiesSection(),
            const SizedBox(height: 40),
            _buildHabitsSection(activeHabits),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- MENÚ DESPLEGABLE (DRAWER) ---
  Widget _buildRightMenu(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text("ACCESOS RÁPIDOS", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined, color: Colors.white),
              title: const Text("Pomodoro", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PomodoroScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded, color: Colors.white),
              title: const Text("Diario", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Cierra el menú lateral
                // ESTA ES LA LÍNEA CLAVE:
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotesScreen(controller: _noteController)));
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS DE LA UI (HABITOS Y PRIORIDADES) ---
  Widget _buildPrioritiesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionHeader("PRIORIDADES"),
      ...List.generate(widget.priorities.length, (i) => _buildPriorityItem(i)),
    ]);
  }

  Widget _buildHabitsSection(List<Habit> habits) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _sectionHeader("HÁBITOS"),
        IconButton(icon: const Icon(Icons.add, color: Colors.white, size: 20), onPressed: _showAddHabit),
      ]),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: habits.length,
        separatorBuilder: (c, i) => const Divider(color: Colors.white10),
        itemBuilder: (c, i) => _buildHabitItem(habits[i]),
      ),
    ]);
  }

  Widget _buildHabitItem(Habit h) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: IconButton(
        icon: Icon(h.isCompletedToday ? Icons.check_box : Icons.check_box_outline_blank, 
          color: h.isCompletedToday ? h.color : Colors.white24),
        onPressed: () {
          setState(() {
            if (h.isCompletedToday) {
              h.completedDates.removeWhere((d) => isSameDay(d, DateTime.now()));
            } else {
              h.completedDates.add(DateTime.now());
            }
          });
          StorageService.saveHabits(widget.habits);
        },
      ),
      title: Text(h.name, style: const TextStyle(color: Colors.white)),
      trailing: Icon(Icons.circle, color: h.color, size: 12),
    );
  }

  Widget _buildPriorityItem(int i) {
    var p = widget.priorities[i];
    return Row(children: [
      Expanded(
        child: TextField(
          controller: p['controller'],
          style: TextStyle(color: Colors.white, decoration: p['isDone'] ? TextDecoration.lineThrough : null),
          decoration: InputDecoration(hintText: "Prioridad ${i + 1}", hintStyle: const TextStyle(color: Colors.white24), border: InputBorder.none),
        ),
      ),
      Checkbox(
        value: p['isDone'],
        onChanged: (v) {
          setState(() => p['isDone'] = v);
          StorageService.savePriorities(widget.priorities);
        },
        activeColor: Colors.white,
        checkColor: Colors.black,
      ),
    ]);
  }

  void _showAddHabit() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (c) => AddHabitScreen(
      existingHabits: widget.habits, 
      onSave: (h) {
        setState(() => widget.habits.add(h));
        StorageService.saveHabits(widget.habits);
      }
    ),
  );

  Widget _buildSquareStat(String t, String v) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Text(v, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget _sectionHeader(String t) => Text(t, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold));
  bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}