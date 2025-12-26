import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';
import '../services/timer_service.dart';

class AchievementsViewModel extends ChangeNotifier {
  final AchievementService _achievementService = AchievementService();
  final TimerService _timerService = TimerService();

  List<AchievementModel> _achievements = [];
  bool _isLoading = true;
  StreamSubscription? _achievementsSubscription;
  Timer? _checkTimer;

  List<AchievementModel> get achievements => _achievements;
  bool get isLoading => _isLoading;

  int get unlockedCount => _achievements.where((a) => a.isUnlocked).length;
  int get totalCount => _achievements.length;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  AchievementsViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (userId == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // الاستماع للتغييرات في الإنجازات
      _achievementsSubscription = _achievementService
          .achievementsStream(userId!)
          .listen((achievements) {
        _achievements = achievements;
        _isLoading = false;
        notifyListeners();
      });

      // فحص الإنجازات تلقائياً كل دقيقة
      _checkTimer = Timer.periodic(
        const Duration(minutes: 1),
            (_) => checkProgress(),
      );

      // فحص فوري
      await checkProgress();

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error initializing achievements: $e');
    }
  }

  Future<void> loadAchievements() async {
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _achievements = await _achievementService.getAchievements(userId!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading achievements: $e');
    }
  }

  Future<List<AchievementModel>> checkProgress() async {
    if (userId == null) return [];

    try {
      final currentStreak = await _timerService.getStreakDays(userId!);
      final newlyUnlocked = await _achievementService.checkAndUnlockAchievements(
        userId!,
        currentStreak,
      );

      // إشعار المستخدم بالإنجازات الجديدة
      if (newlyUnlocked.isNotEmpty) {
        debugPrint('🎉 Unlocked ${newlyUnlocked.length} new achievements!');
        for (var achievement in newlyUnlocked) {
          debugPrint('  - ${achievement.title}');
        }
      }

      return newlyUnlocked;
    } catch (e) {
      debugPrint('Error checking progress: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _achievementsSubscription?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }
}