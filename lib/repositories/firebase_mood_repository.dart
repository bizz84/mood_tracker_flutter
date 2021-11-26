import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_tracker_flutter/repositories/mood_repository.dart';
import 'package:mood_tracker_flutter/repositories/mood_totals.dart';

class FirebaseMoodRepository implements MoodRepository {
  FirebaseMoodRepository(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> addMood(String mood) async {
    final ref = _firestore.collection('mood');
    await ref.add({'mood': mood});
  }

  @override
  Stream<MoodTotals> moodTotals() {
    final ref = _firestore.doc('totals/mood').withConverter(
        fromFirestore: (doc, _) => MoodTotals.fromMap(doc.data()),
        toFirestore: (MoodTotals mood, options) => mood.toMap());
    return ref
        .snapshots()
        // return snapshot.data() or fallback if the document doesn't exist
        .map((snapshot) => snapshot.data() ?? MoodTotals.zero());
  }
}
