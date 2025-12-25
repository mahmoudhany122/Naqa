import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key, required String userId});

  final List<Map<String, String>> lessons = const [
    {"title": "Meditation Basics", "duration": "5 min"},
    {"title": "Focus Training", "duration": "10 min"},
    {"title": "Digital Detox", "duration": "7 min"},
    {"title": "Breathing Exercise", "duration": "4 min"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 80,
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
                    child: ListTile(
                      title: Text(
                        lesson['title']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        lesson['duration']!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      leading: const Icon(Icons.school, color: Colors.white),
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