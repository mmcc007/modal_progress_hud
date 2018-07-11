import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Modal works smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    // tap the submit button and trigger a frame
    await tester.tap(find.text('Login'));
    await tester.pump(new Duration(seconds: 4));
  });
}
