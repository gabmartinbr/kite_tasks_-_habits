import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';
import 'add_habit_screen.dart';
import 'pomodoro_screen.dart';
import 'notes_screen.dart';

class DashboardScreen extends StatefulWidget {
  final List<Habit> habits;
  final List<Map<String, dynamic>> priorities;

  const DashboardScreen({super.key, required this.habits, required this.priorities});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final activeHabits = widget.habits.where((h) => h.deletedAt == null).toList();
    int habitCompleted = activeHabits.where((h) => h.isCompletedToday).length;
    int taskCompleted = widget.priorities.where((p) => p['isDone']).length;
    String formattedDate = DateFormat('EEEE, MMMM d', 'es').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: _buildRightSlider(context),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(CupertinoIcons.bars, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Text(formattedDate.toUpperCase(), 
                  style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const Text("Hoy", 
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 25),
              
              // ESTADÍSTICAS CUADRADAS
              Row(
                children: [
                  _buildSquareStat("TAREAS", "$taskCompleted/${widget.priorities.length}"),
                  const SizedBox(width: 15),
                  _buildSquareStat("HÁBITOS", "$habitCompleted/${activeHabits.length}"),
                ],
              ),

              const SizedBox(height: 15),

              // NUEVO: CUADRADO RESUMEN DEL DÍA (Acceso a Notas)
              GestureDetector(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NotesScreen(controller: _noteController))
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("RESUMEN DEL DÍA", 
                              style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          Icon(CupertinoIcons.pencil_outline, color: Colors.white.withOpacity(0.2), size: 14),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteController,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                        decoration: const InputDecoration(
                          hintText: "¿Cómo definirías hoy en una frase?",
                          hintStyle: TextStyle(color: Colors.white10, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // PRIORIDADES
              _sectionHeader("PRIORIDADES DIARIAS"),
              const SizedBox(height: 10),
              ...List.generate(widget.priorities.length, (index) => _buildPriorityItem(index)),
              
              const SizedBox(height: 40),

              // HÁBITOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionHeader("HÁBITOS"),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    onPressed: () => _showAddHabit(),
                  ),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeHabits.length,
                separatorBuilder: (context, index) => Container(height: 0.5, color: Colors.white10),
                itemBuilder: (context, index) => _buildHabitItem(activeHabits[index]),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET DEL SLIDER LATERAL (BLUR STYLE) ---
  Widget _buildRightSlider(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: const Color(0xFF1C1C1E).withOpacity(0.85),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("MENU", 
                      style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    const SizedBox(height: 50),
                    _menuItem(context, CupertinoIcons.timer, "POMODORO", () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PomodoroScreen()));
                    }),
                    _menuItem(context, CupertinoIcons.doc_text, "NOTAS", () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotesScreen(controller: _noteController)));
                    }),
                    const Spacer(),
                    const Text("FOCUS APP", style: TextStyle(color: Colors.white10, fontSize: 8)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareStat(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E), 
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildPriorityItem(int index) {
    var priority = widget.priorities[index];
    return Row(
      children: [
        Text("${index + 1}.", style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: priority['controller'],
            style: TextStyle(
              color: Colors.white, 
              fontSize: 15, 
              decoration: priority['isDone'] ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white38
            ),
            decoration: const InputDecoration(border: InputBorder.none, hintText: "..."),
          ),
        ),
        Checkbox(
          value: priority['isDone'],
          activeColor: Colors.white,
          checkColor: Colors.black,
          onChanged: (v) => setState(() => priority['isDone'] = v),
        ),
      ],
    );
  }

  Widget _buildHabitItem(Habit habit) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: IconButton(
        icon: Icon(
          habit.isCompletedToday ? CupertinoIcons.checkmark_square_fill : CupertinoIcons.square,
          color: habit.isCompletedToday ? habit.color : Colors.white24,
        ),
        onPressed: () => setState(() {
          habit.isCompletedToday = !habit.isCompletedToday;
          DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          if (habit.isCompletedToday) {
            habit.currentStreak++;
            if (!habit.completedDates.contains(today)) habit.completedDates.add(today);
          } else {
            if (habit.currentStreak > 0) habit.currentStreak--;
            habit.completedDates.remove(today);
          }
        }),
      ),
      title: Text(habit.name, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Icon(Icons.circle, color: habit.color, size: 8),
    );
  }

  Widget _sectionHeader(String text) => Text(text, 
      style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2));

  void _showAddHabit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitScreen(
        existingHabits: widget.habits, 
        onSave: (h) => setState(() => widget.habits.add(h)),
      ),
    );
  }
}