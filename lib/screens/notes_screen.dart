import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final TextEditingController controller;
  const NotesScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = List.generate(14, (i) => DateTime.now().subtract(Duration(days: i)));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("DIARIO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2))),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          DateTime date = days[index];
          bool isToday = index == 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text("${date.day} ${getMonth(date.month)}", style: TextStyle(color: isToday ? const Color.fromARGB(255, 206, 206, 206) : const Color.fromARGB(192, 255, 255, 255), fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 0.5, color: Colors.white10)),
              ]),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(20), border: Border.all(color: isToday ? Colors.orange.withOpacity(0.1) : Colors.transparent)),
                child: isToday 
                  ? TextField(controller: controller, maxLines: null, style: const TextStyle(color: Colors.white, fontSize: 15), decoration: const InputDecoration(hintText: "Escribe algo...", border: InputBorder.none))
                  : const Text("Sin entrada.", style: TextStyle(color: Colors.white10, fontSize: 14)),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  String getMonth(int m) => ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"][m - 1];
}