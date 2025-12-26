import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TimerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // بدء العداد
  Future<void> startTimer(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'startTime': FieldValue.serverTimestamp(),
        'isActive': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error starting timer: $e');
    }
  }

  // إيقاف العداد
  Future<void> stopTimer(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isActive': false,
        'endTime': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error stopping timer: $e');
    }
  }

  // الحصول على الوقت المنقضي
  Stream<Duration> getElapsedTime(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return Duration.zero;

      final data = doc.data();
      if (data == null || data['startTime'] == null) return Duration.zero;

      final startTime = (data['startTime'] as Timestamp).toDate();
      final isActive = data['isActive'] ?? false;

      if (!isActive && data['endTime'] != null) {
        final endTime = (data['endTime'] as Timestamp).toDate();
        return endTime.difference(startTime);
      }

      return DateTime.now().difference(startTime);
    });
  }

  // الحصول على عدد الأيام المتتالية
  Future<int> getStreakDays(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) return 0;

      final data = doc.data();
      if (data == null || data['startTime'] == null) return 0;

      final startTime = (data['startTime'] as Timestamp).toDate();
      final now = DateTime.now();

      // حساب الفرق بالأيام
      final difference = now.difference(startTime);
      return difference.inDays;

    } catch (e) {
      debugPrint('Error getting streak days: $e');
      return 0;
    }
  }

  // التحقق من حالة العداد
  Future<bool> isTimerActive(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return false;

      final data = doc.data();
      return data?['isActive'] ?? false;

    } catch (e) {
      debugPrint('Error checking timer status: $e');
      return false;
    }
  }

  // إعادة تعيين العداد
  Future<void> resetTimer(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'startTime': null,
        'endTime': null,
        'isActive': false,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error resetting timer: $e');
    }
  }

  // حفظ التقدم اليومي
  Future<void> saveDailyProgress(String userId, int minutes) async {
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month}-${today.day}';

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyProgress')
          .doc(dateKey)
          .set({
        'date': Timestamp.fromDate(today),
        'minutes': minutes,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } catch (e) {
      debugPrint('Error saving daily progress: $e');
    }
  }
}