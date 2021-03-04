import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() {
  group('Modal Progress HUD', () {
    Widget sut(bool inAsyncCall, Offset? offset) {
      return MaterialApp(
        home: new ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          offset: offset,
          child: Text(''),
        ),
      );
    }

    testWidgets('should show progress indicator when in async call',
        (tester) async {
      final inAsyncCall = true;
      await tester.pumpWidget(sut(inAsyncCall, null));

      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not show progress indicator when not in async call',
        (tester) async {
      final inAsyncCall = false;
      await tester.pumpWidget(sut(inAsyncCall, null));

      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should allow positioning of progress indicator',
        (tester) async {
      final inAsyncCall = true;
      final offset = Offset(0.1, 0.1);
      await tester.pumpWidget(sut(inAsyncCall, offset));

      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
