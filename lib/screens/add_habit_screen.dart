import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class AddHabitScreen extends StatefulWidget {
  final List<Habit> existingHabits;
  final Function(Habit) onSave;

  const AddHabitScreen({super.key, required this.existingHabits, required this.onSave});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _controller = TextEditingController();
  Color _selectedColor = Colors.blue;

  final List<Color> _colors = [
    Colors.blue, Colors.red, Colors.green, Colors.yellow, 
    Colors.purple, Colors.orange, Colors.teal, Colors.pink
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24, left: 24, right: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("NUEVO HÁBITO", 
            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            decoration: const InputDecoration(
              hintText: "Ej: Leer 30 min",
              hintStyle: TextStyle(color: Colors.white24),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => _selectedColor = _colors[index]),
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: _colors[index],
                    shape: BoxShape.circle,
                    border: _selectedColor == _colors[index] 
                      ? Border.all(color: Colors.white, width: 2) 
                      : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  // --- AQUÍ ESTÁ LA CORRECCIÓN ---
                  final newHabit = Habit(
                    name: _controller.text,
                    completedDates: [],
                    colorValue: _selectedColor.value, // Pasamos el .value (int)
                    createdAt: DateTime.now(),
                  );
                  // -------------------------------
                  widget.onSave(newHabit);
                  Navigator.pop(context);
                }
              },
              child: const Text("GUARDAR", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}