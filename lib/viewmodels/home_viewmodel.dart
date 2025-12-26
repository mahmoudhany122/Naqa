import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_model.dart';

class HomeViewModel extends ChangeNotifier {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isActive = false;
  List<ProgressModel> _weeklyProgress = [];
  String _currentMotivationMessage = 'كل يوم جديد هو فرصة للنمو';

  Duration get duration => _duration;
  bool get isActive => _isActive;
  List<ProgressModel> get weeklyProgress => _weeklyProgress;
  String get currentMotivationMessage => _currentMotivationMessage;

  String get formattedTime {
    final days = _duration.inDays;
    final hours = _duration.inHours % 24;
    final minutes = _duration.inMinutes % 60;
    final seconds = _duration.inSeconds % 60;

    if (days > 0) {
      return '$days يوم ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  HomeViewModel({required this.userId}) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // جلب حالة Timer
      await _loadTimerState();

      // جلب البيانات الأسبوعية
      await _loadWeeklyProgress();

      // تحديث رسالة التحفيز
      _updateMotivationMessage();

      // بدء Timer إذا كان نشطاً
      if (_isActive) {
        _startLocalTimer();
      }
    } catch (e) {
      debugPrint('Error initializing HomeViewModel: $e');
    }
  }

  Future<void> _loadTimerState() async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data();
        _isActive = data?['isActive'] ?? false;

        if (data?['startTime'] != null) {
          final startTime = (data!['startTime'] as Timestamp).toDate();
          _duration = DateTime.now().difference(startTime);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading timer state: $e');
    }
  }

  Future<void> _loadWeeklyProgress() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyProgress')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
          .orderBy('date')
          .get();

      final Map<String, int> progressMap = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final dayName = _getDayShortName(date.weekday);
        final minutes = (data['minutes'] as num?)?.toInt() ?? 0;
        progressMap[dayName] = (progressMap[dayName] ?? 0) + minutes;
      }

      _weeklyProgress = progressMap.entries
          .map((e) => ProgressModel(day: e.key, progress: e.value))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading weekly progress: $e');
      // بيانات افتراضية
      _weeklyProgress = [
        ProgressModel(day: 'Mon', progress: 0),
        ProgressModel(day: 'Tue', progress: 0),
        ProgressModel(day: 'Wed', progress: 0),
        ProgressModel(day: 'Thu', progress: 0),
        ProgressModel(day: 'Fri', progress: 0),
        ProgressModel(day: 'Sat', progress: 0),
        ProgressModel(day: 'Sun', progress: 0),
      ];
    }
  }

  String _getDayShortName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  void _updateMotivationMessage() {
    final messages = [
      'كل يوم جديد هو فرصة للنمو والتطور',
      'أنت أقوى مما تعتقد',
      'التغيير يبدأ من الآن',
      'رحلة الألف ميل تبدأ بخطوة',
      'النجاح هو مجموع الجهود الصغيرة المتكررة',
    ];

    final daysPassed = _duration.inDays;
    _currentMotivationMessage = messages[daysPassed % messages.length];
  }

  void _startLocalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _duration = _duration + const Duration(seconds: 1);
      _updateMotivationMessage();
      notifyListeners();
    });
  }

  Future<void> startTimer() async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'startTime': FieldValue.serverTimestamp(),
        'isActive': true,
      }, SetOptions(merge: true));

      _isActive = true;
      _startLocalTimer();
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting timer: $e');
    }
  }

  Future<void> stopTimer() async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isActive': false,
        'endTime': FieldValue.serverTimestamp(),
      });

      _isActive = false;
      _timer?.cancel();
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping timer: $e');
    }
  }

  Future<void> resetTimer() async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'startTime': null,
        'endTime': null,
        'isActive': false,
      });

      _isActive = false;
      _duration = Duration.zero;
      _timer?.cancel();
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting timer: $e');
    }
  }

  // Journey Log Methods
  Stream<List<JourneyEntry>> getJourneyLog(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('journalEntries')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return JourneyEntry(text: data['text'] ?? '');
      }).toList();
    });
  }

  Future<void> addJourneyEntry(String userId, String text) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journalEntries')
          .add({
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding journey entry: $e');
    }
  }

  // App Lock Methods
  Stream<bool> getAppLockStatus(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['appLocked'] ?? false);
  }

  Future<void> toggleAppLock(String userId, bool isLocked) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'appLocked': isLocked,
      });
    } catch (e) {
      debugPrint('Error toggling app lock: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Helper class for Journey Entry
class JourneyEntry {
  final String text;
  JourneyEntry({required this.text});
}