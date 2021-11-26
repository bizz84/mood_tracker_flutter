import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_flutter/firestore_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Use local Firestore emulator
  final firestore = FirebaseFirestore.instance;
  firestore.settings =
      const Settings(persistenceEnabled: false, sslEnabled: false);
  firestore.useFirestoreEmulator('localhost', 8080);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MoodTrackerPage(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        MoodEmojiButton(
          emoji: '😀',
        ),
        MoodEmojiButton(
          emoji: '😐',
        ),
        MoodEmojiButton(
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
      onTap: () => ref.read(databaseProvider).addMood(emoji),
      child: Text(
        emoji,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class MoodTotalsWidget extends ConsumerWidget {
  const MoodTotalsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodTotalsValue = ref.watch(moodTotalsProvider);
    return moodTotalsValue.when(
      data: (moodTotals) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MoodTotal(
            emoji: '😀',
            total: moodTotals.positive,
          ),
          MoodTotal(
            emoji: '😐',
            total: moodTotals.neutral,
          ),
          MoodTotal(
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
  const MoodTotal({Key? key, required this.emoji, required this.total})
      : super(key: key);
  final String emoji;
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
          style: Theme.of(context).textTheme.headline5,
        )
      ],
    );
  }
}
