import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/journey_service.dart';

class JourneyViewModel extends ChangeNotifier {
  final JourneyService _journeyService = JourneyService();
  final String userId;

  List<Map<String, dynamic>> _entries = [];
  bool _isLoading = true;
  String? _error;
  StreamSubscription? _entriesSubscription;

  List<Map<String, dynamic>> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  JourneyViewModel({required this.userId}) {
    _initialize();
  }

  void _initialize() {
    _entriesSubscription = _journeyService.getEntries(userId).listen(
          (entries) {
        _entries = entries;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load entries: $e';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> addEntry(String text) async {
    try {
      await _journeyService.addEntry(userId, text);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEntry(String entryId, String newText) async {
    try {
      await _journeyService.updateEntry(userId, entryId, newText);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEntry(String entryId) async {
    try {
      await _journeyService.deleteEntry(userId, entryId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> searchEntries(String query) async {
    if (query.trim().isEmpty) {
      _initialize(); // Reset to all entries
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      _entries = await _journeyService.searchEntries(userId, query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Search failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _entriesSubscription?.cancel();
    super.dispose();
  }
}