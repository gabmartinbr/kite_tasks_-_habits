import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppleNotes extends StatelessWidget {
  final TextEditingController controller;
  const AppleNotes({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.doc_text, color: Colors.orange[300], size: 14),
              const SizedBox(width: 8),
              Text("PENSAMIENTOS", style: TextStyle(color: Colors.orange[300], fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: null,
            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4, fontWeight: FontWeight.w400),
            decoration: const InputDecoration(
              hintText: "Escribe cómo va tu día...",
              hintStyle: TextStyle(color: Colors.white10),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}