import 'package:flutter/material.dart';
import '../achievements/achievements_page.dart';
import '../home/home_page.dart';
import '../journey/enhanced_journey_page.dart';
import '../learning/learning_page.dart';
import '../profile/profile_page.dart';
import '../statistics/statistics_page.dart';


class MainLayoutPage extends StatefulWidget {
  final String userId;
  const MainLayoutPage({super.key, required this.userId});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userId: widget.userId),
      EnhancedJourneyPage(userId: widget.userId),
      LearningPage(userId: widget.userId),
      ProfilePage(userId: widget.userId),
      StatisticsPage(userId: widget.userId),
      const AchievementsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'اليوميات'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'التعليم'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'الإحصائيات'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'الإنجازات'),
        ],
      ),
    );
  }
}
