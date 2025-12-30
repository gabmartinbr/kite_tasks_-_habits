import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final TextEditingController controller;
  const NotesScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Generamos los últimos 14 días para tener una lista larga
    List<DateTime> days = List.generate(14, (index) => DateTime.now().subtract(Duration(days: index)));

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // AppBar estilo Apple que se expande/contrae al hacer scroll
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Diario", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            border: null,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  DateTime date = days[index];
                  bool isToday = index == 0;

                  return _buildTimelineItem(date, isToday);
                },
                childCount: days.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(DateTime date, bool isToday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicador de Fecha
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 20),
          child: Row(
            children: [
              Text(
                "${date.day} ${getMonthName(date.month).toUpperCase()}",
                style: TextStyle(
                  color: isToday ? Colors.orange : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Container(height: 0.5, color: Colors.white10)),
            ],
          ),
        ),
        // Tarjeta de Nota
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isToday ? Colors.orange.withOpacity(0.1) : Colors.white.withOpacity(0.03),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getWeekdayName(date.weekday),
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              isToday
                  ? TextField(
                      controller: controller,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                      decoration: const InputDecoration(
                        hintText: "Añade un pensamiento...",
                        hintStyle: TextStyle(color: Colors.white10),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  : const Text(
                      "Sin entrada de diario para este día.",
                      style: TextStyle(color: Colors.white10, fontSize: 14, fontStyle: FontStyle.italic),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  String getMonthName(int month) => ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"][month - 1];
  String getWeekdayName(int day) => ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"][day - 1];
}