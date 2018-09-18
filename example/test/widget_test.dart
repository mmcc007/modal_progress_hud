import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Finder userName = find.byKey(Key('username'));
  final Finder password = find.byKey(Key('password'));
  final Finder login = find.byKey(Key('login'));
  final secretLoginData = LoginData(
    userName: 'username1',
    password: 'password1',
  );

  setUpAll(() async {
    expect(userName, isNotNull);
    expect(password, isNotNull);
    expect(login, isNotNull);
  });

  testWidgets('trigger sync validation', (WidgetTester tester) async {
    final loginData = LoginData();
    await tester.pumpWidget(new MaterialApp(
      theme: ThemeData(),
      home: LoginPage(inputLoginData: loginData),
    ));

    await tester.tap(userName);
    await tester.enterText(userName, 'user');

    await tester.tap(password);
    await tester.enterText(password, 'pass');

    await tester.tap(login);

    // Verify user is not logged-in.
    expect(loginData.isLoggedIn, isFalse);
    expect(loginData.userName, isNot(secretLoginData.userName));
    expect(loginData.password, isNot(secretLoginData.password));
  });

  testWidgets('trigger async validation', (WidgetTester tester) async {
    final loginData = LoginData();
    await tester.pumpWidget(
      new MaterialApp(
        theme: ThemeData(),
        home: LoginPage(inputLoginData: loginData),
      ),
    );

    await tester.tap(userName);
    await tester.enterText(userName, 'username');

    await tester.tap(password);
    await tester.enterText(password, 'password');

    await tester.tap(login);
    // wait for same time as demo async call
    await tester.pump(Duration(seconds: 1));

    // Verify
    expect(loginData.isLoggedIn, isFalse);
    expect(loginData.userName, isNot(secretLoginData.userName));
    expect(loginData.password, isNot(secretLoginData.password));
  });

  testWidgets('trigger async login', (WidgetTester tester) async {
    final loginData = LoginData();
    await tester.pumpWidget(
      new MaterialApp(
        theme: ThemeData(),
        home: LoginPage(inputLoginData: loginData),
      ),
    );

    await tester.tap(userName);
    await tester.enterText(userName, secretLoginData.userName);

    await tester.tap(password);
    await tester.enterText(password, secretLoginData.password);

    await tester.tap(login);
    // wait for same time as demo async call
    await tester.pump(Duration(seconds: 1));

    // Verify
    expect(loginData.isLoggedIn, isTrue);
    expect(loginData.userName, secretLoginData.userName);
    expect(loginData.password, secretLoginData.password);
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    // tap the submit button and trigger a frame
    await tester.tap(find.text('Login'));
    await tester.pump(new Duration(seconds: 1));
  });
}
