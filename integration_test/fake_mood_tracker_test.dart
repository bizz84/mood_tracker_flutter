import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mood_tracker_flutter/features/mood_tracker_page/mood_tracker_page.dart';
import 'package:mood_tracker_flutter/main.dart';
import 'package:mood_tracker_flutter/repositories/fake_mood_repository.dart';
import 'package:mood_tracker_flutter/repositories/mood_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpWidgetAppWithMocks(
      WidgetTester tester, FakeMoodRepository fakeMoodRepository) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        moodRepositoryProvider.overrideWithValue(fakeMoodRepository),
      ],
      child: const MyApp(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('Given just loaded Then totals are zero', (tester) async {
    final fakeMoodRepository = FakeMoodRepository();
    await pumpWidgetAppWithMocks(tester, fakeMoodRepository);

    expect(find.text('0'), findsNWidgets(3));
  });

  testWidgets('Given positive button tapped Then positive total is 1',
      (tester) async {
    final fakeMoodRepository = FakeMoodRepository();
    await pumpWidgetAppWithMocks(tester, fakeMoodRepository);

    // first tap the button
    await tester.tap(find.byKey(MoodTrackerWidget.positiveButtonKey));

    await tester.pumpAndSettle();

    // https://stackoverflow.com/a/54236046/436422
    // then find the text widget with the positive total
    final finderPositive = find.byKey(MoodTotalsWidget.positiveTotalKey);
    final positiveText = finderPositive.evaluate().single.widget as Text;
    // and check its value
    expect(positiveText.data, '1');
    // the other 2 text widgets should have value 0
    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('Given tap buttons a few times Then totals match',
      (tester) async {
    final fakeMoodRepository = FakeMoodRepository();
    await pumpWidgetAppWithMocks(tester, fakeMoodRepository);

    // 2 taps on positive
    await tester.tap(find.byKey(MoodTrackerWidget.positiveButtonKey));
    await tester.tap(find.byKey(MoodTrackerWidget.positiveButtonKey));
    // 0 taps on neutral
    // 1 tap on negative
    await tester.tap(find.byKey(MoodTrackerWidget.negativeButtonKey));

    await tester.pumpAndSettle();

    // https://stackoverflow.com/a/54236046/436422
    // check the positive value
    final finderPositive = find.byKey(MoodTotalsWidget.positiveTotalKey);
    final positiveText = finderPositive.evaluate().single.widget as Text;
    expect(positiveText.data, '2');
    // check the neutral value
    final finderNeutral = find.byKey(MoodTotalsWidget.neutralTotalKey);
    final neutralText = finderNeutral.evaluate().single.widget as Text;
    expect(neutralText.data, '0');
    // check the negative value
    final finderNegative = find.byKey(MoodTotalsWidget.negativeTotalKey);
    final negativeText = finderNegative.evaluate().single.widget as Text;
    expect(negativeText.data, '1');
  });
}
