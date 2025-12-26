import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/timer_service.dart';

class TimerViewModel extends ChangeNotifier {
  final String userId;
  final TimerService _timerService = TimerService();

  bool _isActive = false;
  int _streakDays = 0;
  Stream<Duration>? _elapsedTimeStream;

  bool get isActive => _isActive;
  int get streakDays => _streakDays;
  Stream<Duration> get elapsedTimeStream =>
      _elapsedTimeStream ?? Stream.value(Duration.zero);

  TimerViewModel({required this.userId}) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // التحقق من حالة Timer
      _isActive = await _timerService.isTimerActive(userId);

      // جلب عدد الأيام
      _streakDays = await _timerService.getStreakDays(userId);

      // الاستماع للوقت المنقضي
      _elapsedTimeStream = _timerService.getElapsedTime(userId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing timer: $e');
    }
  }

  Future<void> startTimer() async {
    try {
      await _timerService.startTimer(userId);
      _isActive = true;
      _elapsedTimeStream = _timerService.getElapsedTime(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting timer: $e');
    }
  }

  Future<void> stopTimer() async {
    try {
      await _timerService.stopTimer(userId);
      _isActive = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping timer: $e');
    }
  }

  Future<void> resetTimer() async {
    try {
      await _timerService.resetTimer(userId);
      _isActive = false;
      _streakDays = 0;
      _elapsedTimeStream = Stream.value(Duration.zero);
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting timer: $e');
    }
  }
}