import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Finder userName = find.byKey(Key('username'));
  final Finder password = find.byKey(Key('password'));
  final Finder login = find.byType(RaisedButton);

  final secretUsername = 'username1';
  final secretPassword = 'password1';
  bool isLoggedIn;

  setUp(() {
    isLoggedIn = false;
  });

  testWidgets('trigger sync validation', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      theme: ThemeData(),
      home: LoginPage(onSignIn: () => isLoggedIn = true),
    ));

    await tester.tap(userName);
    await tester.enterText(userName, 'user');

    await tester.tap(password);
    await tester.enterText(password, 'pass');

    await tester.tap(login);

    // Verify user is not logged-in.
    expect(isLoggedIn, isFalse);
  });

  testWidgets('trigger async validation', (WidgetTester tester) async {
    await tester.pumpWidget(
      new MaterialApp(
        theme: ThemeData(),
        home: LoginPage(onSignIn: () => isLoggedIn = true),
      ),
    );

    await tester.tap(userName);
    await tester.enterText(userName, 'username');

    await tester.tap(password);
    await tester.enterText(password, 'password');

    await tester.tap(login);
    // wait for same time as demo async call
    await tester.pump(Duration(seconds: 1));

    // verify async username validator ran
    expect(find.text('Incorrect user name'), findsOneWidget);
    expect(find.text('Incorrect password'), findsNothing);

    await tester.tap(userName);
    await tester.enterText(userName, 'username1');
    await tester.tap(login);
    // wait for same time as demo async call
    await tester.pump(Duration(seconds: 1));

    // verify async password validator ran
    expect(find.text('Incorrect password'), findsOneWidget);

    expect(isLoggedIn, isFalse);
  });

  testWidgets('trigger async login', (WidgetTester tester) async {
    await tester.pumpWidget(
      new MaterialApp(
        theme: ThemeData(),
        home: LoginPage(onSignIn: () => isLoggedIn = true),
      ),
    );

    await tester.tap(userName);
    await tester.enterText(userName, secretUsername);

    await tester.tap(password);
    await tester.enterText(password, secretPassword);

    await tester.tap(login);
    // wait for same time as demo async call
    await tester.pump(Duration(seconds: 1));

    // Verify
    expect(isLoggedIn, isTrue);
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    expect(find.byType(LoginPage), findsOneWidget);

    // tap the submit button and trigger a frame
    await tester.tap(login);
    await tester.pump();
  });
}
