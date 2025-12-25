import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journey_entry_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // App Lock Status
  Stream<bool> appLockStatus(String userId) {
    if (userId.isEmpty) {
      return Stream.value(false);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['appLock'] ?? false);
  }

  // Toggle App Lock
  Future<void> toggleAppLock(String userId, bool value) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .set({'appLock': value}, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to toggle app lock');
    }
  }

  // Get Journey Log
  Stream<List<JourneyEntryModel>> getJourneyLog(String userId) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('journeyLog')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => JourneyEntryModel.fromJson(doc.data()))
        .toList());
  }

  // Add Journey Entry
  Future<void> addJourneyEntry(String userId, String text) async {
    if (userId.isEmpty || text.isEmpty) {
      throw Exception('Invalid input');
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journeyLog')
          .add({
        'text': text,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to add journey entry');
    }
  }

  // Get User Data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user data');
    }
  }

  // Update User Data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update user data');
    }
  }
}