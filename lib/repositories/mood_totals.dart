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
