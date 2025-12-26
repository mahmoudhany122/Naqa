import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_model.dart';

class StatisticsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _totalDays = 0;
  double _successRate = 0.0;
  List<ProgressModel> _weeklyProgress = [];

  bool get isLoading => _isLoading;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get totalDays => _totalDays;
  double get successRate => _successRate;
  List<ProgressModel> get weeklyProgress => _weeklyProgress;

  Future<void> loadStatistics(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // جلب بيانات المستخدم
      final userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();

        // حساب الـ streak الحالي
        if (data?['startTime'] != null) {
          final startTime = (data!['startTime'] as Timestamp).toDate();
          _currentStreak = DateTime.now().difference(startTime).inDays;
        }

        // جلب البيانات اليومية
        final progressSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('dailyProgress')
            .orderBy('date', descending: true)
            .limit(30)
            .get();

        // حساب إجمالي الأيام
        _totalDays = progressSnapshot.docs.length;

        // حساب أطول streak
        _longestStreak = _calculateLongestStreak(progressSnapshot.docs);

        // حساب معدل النجاح
        _successRate = _currentStreak > 0
            ? (_currentStreak / _totalDays.clamp(1, double.infinity))
            : 0.0;

        // جلب بيانات الأسبوع الأخير
        _weeklyProgress = await _getWeeklyProgress(userId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading statistics: $e');
    }
  }

  int _calculateLongestStreak(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) return 0;

    int longest = 1;
    int current = 1;

    for (int i = 1; i < docs.length; i++) {
      final prevDate = (docs[i - 1].data() as Map)['date'] as Timestamp;
      final currDate = (docs[i].data() as Map)['date'] as Timestamp;

      final diff = prevDate.toDate().difference(currDate.toDate()).inDays;

      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }

    return longest;
  }

  Future<List<ProgressModel>> _getWeeklyProgress(String userId) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('dailyProgress')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .orderBy('date')
        .get();

    final Map<String, int> progressMap = {};

    // تهيئة الأيام السبعة
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      progressMap[dayName] = 0;
    }

    // ملء البيانات الفعلية
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp).toDate();
      final dayName = _getDayName(date.weekday);
      progressMap[dayName] = data['minutes'] ?? 0;
    }

    return progressMap.entries
        .map((e) => ProgressModel(day: e.key, progress: e.value))
        .toList();
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'الإثنين';
      case 2: return 'الثلاثاء';
      case 3: return 'الأربعاء';
      case 4: return 'الخميس';
      case 5: return 'الجمعة';
      case 6: return 'السبت';
      case 7: return 'الأحد';
      default: return '';
    }
  }
}