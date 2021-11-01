import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreDatabase {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addMood(String mood) async {
    final ref = _firestore.collection('mood');
    await ref.add({'mood': mood});
  }
}

final databaseProvider = Provider<FirestoreDatabase>((ref) {
  return FirestoreDatabase();
});
