import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_flutter/firestore_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        appBar: AppBar(
          title: const Text('Mood Tracker'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('How are you feeling?',
                style: Theme.of(context).textTheme.headline4),
            MoodTrackerWidget(),
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
