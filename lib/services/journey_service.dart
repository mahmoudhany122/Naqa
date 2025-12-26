import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journey_entry_model.dart';

class JourneyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إضافة مدخل جديد
  Future<void> addEntry(String userId, String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journeyLog')
          .add({
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add entry: $e');
    }
  }

  // تحديث مدخل
  Future<void> updateEntry(String userId, String entryId, String newText) async {
    if (newText.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journeyLog')
          .doc(entryId)
          .update({
        'text': newText.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update entry: $e');
    }
  }

  // حذف مدخل
  Future<void> deleteEntry(String userId, String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journeyLog')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete entry: $e');
    }
  }

  // الحصول على كل المدخلات (Stream)
  Stream<List<Map<String, dynamic>>> getEntries(String userId) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('journeyLog')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'text': data['text'] ?? '',
          'timestamp': data['timestamp'],
          'createdAt': data['createdAt'],
        };
      }).toList();
    });
  }

  // البحث في المدخلات
  Future<List<Map<String, dynamic>>> searchEntries(
      String userId,
      String query,
      ) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('journeyLog')
          .get();

      return snapshot.docs
          .where((doc) =>
      (doc.data()['text'] as String?)
          ?.toLowerCase()
          .contains(query.toLowerCase()) ??
          false)
          .map((doc) => {
        'id': doc.id,
        'text': doc.data()['text'],
        'timestamp': doc.data()['timestamp'],
      })
          .toList();
    } catch (e) {
      return [];
    }
  }
}