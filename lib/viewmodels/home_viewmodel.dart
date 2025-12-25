import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/journey_entry_model.dart';
import '../services/firstore_setup.dart';

class HomeViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  late Timer _timer;
  Duration _duration = Duration.zero;
  int _messageIndex = 0;

  Duration get duration => _duration;
  int get messageIndex => _messageIndex;
  String get currentMotivationMessage =>
      AppConstants.motivationMessages[_messageIndex];

  HomeViewModel() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _duration += const Duration(seconds: 1);

      if (_duration.inSeconds % 10 == 0) {
        _messageIndex = (_messageIndex + 1) % AppConstants.motivationMessages.length;
      }

      notifyListeners();
    });
  }

  String get formattedTime {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  // App Lock
  Stream<bool> getAppLockStatus(String userId) {
    return _firestoreService.appLockStatus(userId);
  }

  Future<void> toggleAppLock(String userId, bool value) async {
    try {
      await _firestoreService.toggleAppLock(userId, value);
    } catch (e) {
      debugPrint('Error toggling app lock: $e');
    }
  }

  // Journey Log
  Stream<List<JourneyEntryModel>> getJourneyLog(String userId) {
    return _firestoreService.getJourneyLog(userId);
  }

  Future<void> addJourneyEntry(String userId, String text) async {
    try {
      await _firestoreService.addJourneyEntry(userId, text);
    } catch (e) {
      debugPrint('Error adding journey entry: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
