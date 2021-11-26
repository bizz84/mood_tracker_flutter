import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_flutter/repositories/mood_repository.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Mood Tracker'),
        // ),
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Text('How are you feeling?',
            style: Theme.of(context).textTheme.headline5),
        const SizedBox(height: 24),
        const MoodTrackerWidget(),
        const SizedBox(height: 48),
        //const Spacer(flex: 2),
        Text('Totals', style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 24),
        const MoodTotalsWidget(),
        const Spacer(flex: 3),
      ],
    ));
  }
}

class MoodTrackerWidget extends StatelessWidget {
  const MoodTrackerWidget({Key? key}) : super(key: key);

  static const positiveButtonKey = Key('button-positive');
  static const neutralButtonKey = Key('button-neutral');
  static const negativeButtonKey = Key('button-negative');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        MoodEmojiButton(
          key: positiveButtonKey,
          emoji: '😀',
        ),
        MoodEmojiButton(
          key: neutralButtonKey,
          emoji: '😐',
        ),
        MoodEmojiButton(
          key: negativeButtonKey,
          emoji: '😟',
        ),
      ],
    );
  }
}

class MoodEmojiButton extends ConsumerWidget {
  const MoodEmojiButton({Key? key, required this.emoji}) : super(key: key);
  final String emoji;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(moodRepositoryProvider).addMood(emoji),
      child: Text(
        emoji,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class MoodTotalsWidget extends ConsumerWidget {
  const MoodTotalsWidget({Key? key}) : super(key: key);

  static const positiveTotalKey = Key('total-positive');
  static const neutralTotalKey = Key('total-neutral');
  static const negativeTotalKey = Key('total-negative');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodTotalsValue = ref.watch(moodTotalsProvider);
    return moodTotalsValue.when(
      data: (moodTotals) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MoodTotal(
            textKey: positiveTotalKey,
            emoji: '😀',
            total: moodTotals.positive,
          ),
          MoodTotal(
            textKey: neutralTotalKey,
            emoji: '😐',
            total: moodTotals.neutral,
          ),
          MoodTotal(
            textKey: negativeTotalKey,
            emoji: '😟',
            total: moodTotals.negative,
          ),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => Text(
        'Some error occurred',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

class MoodTotal extends StatelessWidget {
  const MoodTotal(
      {Key? key,
      required this.textKey,
      required this.emoji,
      required this.total})
      : super(key: key);
  final String emoji;
  final Key textKey;
  final int total;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          emoji,
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          '$total',
          key: textKey,
          style: Theme.of(context).textTheme.headline5,
        )
      ],
    );
  }
}
