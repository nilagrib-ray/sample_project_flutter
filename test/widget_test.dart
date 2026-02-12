import 'package:flutter_test/flutter_test.dart';
import 'package:sample_project_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SampleApp(isLoggedIn: false));
    await tester.pumpAndSettle();

    // Verify login screen is shown
    expect(find.text('Log In'), findsWidgets);
  });
}
