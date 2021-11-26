import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_flutter/repositories/mood_totals.dart';

abstract class MoodRepository {
  Future<void> addMood(String mood);
  Stream<MoodTotals> moodTotals();
}

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return throw UnimplementedError();
});

final moodTotalsProvider = StreamProvider.autoDispose<MoodTotals>((ref) {
  return ref.watch(moodRepositoryProvider).moodTotals();
});
