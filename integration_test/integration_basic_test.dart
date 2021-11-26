import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mood_tracker_flutter/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpWidgetAppWithMocks(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [],
      child: MyApp(),
    ));
  }

  testWidgets('product selection', (tester) async {
    await pumpWidgetAppWithMocks(tester);
  });
}
