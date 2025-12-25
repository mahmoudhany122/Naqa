import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../journey/journey_page.dart';
import '../learning/learning_page.dart';
import '../profile/profile_page.dart';

class MainLayoutPage extends StatefulWidget {
  final String userId;
  const MainLayoutPage({super.key, required this.userId});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      HomePage(userId: widget.userId),
      const LearningPage(userId: ''),
      const JourneyPage(userId: ''),
      const ProfilePage(userId: ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learning'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journey'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}