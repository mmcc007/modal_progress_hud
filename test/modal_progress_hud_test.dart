//import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() {
  testWidgets('sends events to modal progress hud',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: new ModalProgressHUD(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(child: Container()),
          ],
        ),
        saving: false,
      ),
    ));
  });
}
