import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_flutter/repositories/mood_totals.dart';

abstract class MoodRepository {
  Future<void> addMood(String mood);
  Stream<MoodTotals> moodTotals();
}

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
        .map((snapshot) => snapshot.data() ?? MoodTotals.zero());
  }
}

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return throw UnimplementedError();
});

final moodTotalsProvider = StreamProvider.autoDispose<MoodTotals>((ref) {
  return ref.watch(moodRepositoryProvider).moodTotals();
});
