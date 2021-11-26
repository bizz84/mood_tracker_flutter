import 'package:mood_tracker_flutter/repositories/mood_repository.dart';
import 'package:mood_tracker_flutter/repositories/mood_totals.dart';
import 'package:rxdart/rxdart.dart';

class FakeMoodRepository implements MoodRepository {
  var _moodTotals = MoodTotals.zero();
  final _moodTotalsSubject =
      BehaviorSubject<MoodTotals>.seeded(MoodTotals.zero());
  Stream<MoodTotals> get _moodTotalsStream => _moodTotalsSubject.stream;

  @override
  Future<void> addMood(String mood) async {
    switch (mood) {
      case '😀':
        _moodTotals = _moodTotals.copyWith(positive: _moodTotals.positive + 1);
        break;
      case '😐':
        _moodTotals = _moodTotals.copyWith(neutral: _moodTotals.neutral + 1);
        break;
      case '😟':
        _moodTotals = _moodTotals.copyWith(negative: _moodTotals.negative + 1);
        break;
      default:
        throw UnsupportedError('Mood not recognized: $mood');
    }
    _moodTotalsSubject.add(_moodTotals);
  }

  @override
  Stream<MoodTotals> moodTotals() => _moodTotalsStream;
}
