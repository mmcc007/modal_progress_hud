//import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() {
  final text = 'testing';

  Widget sut(bool inAsyncCall) {
    return MaterialApp(
      home: new ModalProgressHUD(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(child: Text(text)),
          ],
        ),
        inAsyncCall: inAsyncCall,
      ),
    );
  }

  testWidgets('should show progress indicator when in async call',
      (tester) async {
    final inAsyncCall = true;
    await tester.pumpWidget(sut(inAsyncCall));

    expect(find.text(text), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should not show progress indicator when not in async call',
      (tester) async {
    final inAsyncCall = false;
    await tester.pumpWidget(sut(inAsyncCall));

    expect(find.text(text), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
