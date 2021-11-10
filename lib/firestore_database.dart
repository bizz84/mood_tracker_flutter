import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodTotals {
  MoodTotals({
    required this.positive,
    required this.neutral,
    required this.negative,
  });
  final int positive;
  final int neutral;
  final int negative;

  // helper method to be used when there is no document
  MoodTotals.zero()
      : positive = 0,
        neutral = 0,
        negative = 0;

  Map<String, dynamic> toMap() {
    return {
      'positive': positive,
      'neutral': neutral,
      'negative': negative,
    };
  }

  factory MoodTotals.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return MoodTotals.zero();
    }
    return MoodTotals(
      positive: map['positive'],
      neutral: map['neutral'],
      negative: map['negative'],
    );
  }

  @override
  String toString() =>
      'Mood(positive: $positive, neutral: $neutral, negative: $negative)';
}

class FirestoreDatabase {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addMood(String mood) async {
    final ref = _firestore.collection('mood');
    await ref.add({'mood': mood});
  }

  Stream<MoodTotals> moodTotals() {
    final ref = _firestore.doc('totals/mood').withConverter(
        fromFirestore: (doc, _) => MoodTotals.fromMap(doc.data()),
        toFirestore: (MoodTotals mood, options) => mood.toMap());
    return ref
        .snapshots()
        .map((snapshot) => snapshot.data() ?? MoodTotals.zero());
  }
}

final databaseProvider = Provider<FirestoreDatabase>((ref) {
  return FirestoreDatabase();
});

final moodTotalsProvider = StreamProvider.autoDispose<MoodTotals>((ref) {
  return ref.watch(databaseProvider).moodTotals();
});
