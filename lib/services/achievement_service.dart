import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';

class AchievementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final List<Map<String, dynamic>> _achievementTemplates = [
    {
      'id': 'first_day',
      'title': 'البداية',
      'description': 'أكملت أول يوم بنجاح',
      'requiredDays': 1,
      'icon': '🥉',
    },
    {
      'id': 'three_days',
      'title': 'ثلاثة أيام',
      'description': 'أكملت 3 أيام متتالية',
      'requiredDays': 3,
      'icon': '🥉',
    },
    {
      'id': 'one_week',
      'title': 'أسبوع كامل',
      'description': 'أكملت 7 أيام متتالية',
      'requiredDays': 7,
      'icon': '🥈',
    },
    {
      'id': 'two_weeks',
      'title': 'أسبوعان',
      'description': 'أكملت 14 يوم متتالية',
      'requiredDays': 14,
      'icon': '🥈',
    },
    {
      'id': 'one_month',
      'title': 'شهر كامل',
      'description': 'أكملت 30 يوم متتالية',
      'requiredDays': 30,
      'icon': '🥇',
    },
    {
      'id': 'three_months',
      'title': 'ثلاثة أشهر',
      'description': 'أكملت 90 يوم متتالية',
      'requiredDays': 90,
      'icon': '🏆',
    },
  ];

  // تهيئة الإنجازات للمستخدم الجديد
  Future<void> initializeAchievements(String userId) async {
    try {
      final batch = _firestore.batch();

      for (var template in _achievementTemplates) {
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('achievements')
            .doc(template['id']);

        batch.set(docRef, {
          ...template,
          'isUnlocked': false,
          'unlockedAt': null,
        });
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error initializing achievements: $e');
    }
  }

  // فحص وفتح الإنجازات تلقائياً
  Future<List<AchievementModel>> checkAndUnlockAchievements(
      String userId,
      int currentStreak,
      ) async {
    try {
      final unlockedAchievements = <AchievementModel>[];

      // جلب كل الإنجازات
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final isUnlocked = data['isUnlocked'] ?? false;
        final requiredDays = data['requiredDays'] ?? 0;

        // إذا لم يكن مفتوحاً ووصل للهدف
        if (!isUnlocked && currentStreak >= requiredDays) {
          // فتح الإنجاز
          await doc.reference.update({
            'isUnlocked': true,
            'unlockedAt': FieldValue.serverTimestamp(),
          });

          // إضافة للقائمة
          unlockedAchievements.add(
            AchievementModel(
              id: data['id'],
              title: data['title'],
              description: data['description'],
              iconPath: data['icon'] ?? '🏆',
              requiredDays: requiredDays,
              isUnlocked: true,
              unlockedAt: DateTime.now(),
            ),
          );
        }
      }

      return unlockedAchievements;

    } catch (e) {
      debugPrint('Error checking achievements: $e');
      return [];
    }
  }

  // الحصول على كل الإنجازات
  Future<List<AchievementModel>> getAchievements(String userId) async {
    try {
      // التحقق من وجود إنجازات
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .get();

      // إذا لم توجد، تهيئتها
      if (snapshot.docs.isEmpty) {
        await initializeAchievements(userId);
        return getAchievements(userId); // استدعاء مرة أخرى
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AchievementModel(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          iconPath: data['icon'] ?? '🏆',
          requiredDays: data['requiredDays'],
          isUnlocked: data['isUnlocked'] ?? false,
          unlockedAt: data['unlockedAt'] != null
              ? (data['unlockedAt'] as Timestamp).toDate()
              : null,
        );
      }).toList();

    } catch (e) {
      debugPrint('Error loading achievements: $e');
      return [];
    }
  }

  // Stream للإنجازات
  Stream<List<AchievementModel>> achievementsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AchievementModel(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          iconPath: data['icon'] ?? '🏆',
          requiredDays: data['requiredDays'],
          isUnlocked: data['isUnlocked'] ?? false,
          unlockedAt: data['unlockedAt'] != null
              ? (data['unlockedAt'] as Timestamp).toDate()
              : null,
        );
      }).toList();
    });
  }
}
