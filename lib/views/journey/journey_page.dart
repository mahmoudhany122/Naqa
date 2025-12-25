import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key, required String userId});

  final List<String> journalEntries = const [
    "Day 1: Started digital detox, feeling motivated.",
    "Day 2: Avoided triggers successfully, small wins.",
    "Day 3: Meditation helped me stay calm.",
    "Day 4: Recorded progress in app, feeling proud.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: journalEntries.length,
              itemBuilder: (context, index) {
                final entry = journalEntries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 100,
                    borderRadius: 20,
                    blur: 20,
                    border: 2,
                    linearGradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderGradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.5)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        entry,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
