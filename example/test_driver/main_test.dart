import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('app test: ', () {
    final userSync = 'Username must be at least 8 characters';
    final userASync = 'Incorrect user name';
    final passSync = 'Password must be at least 8 characters';
    final passASync = 'Incorrect password';

    FlutterDriver? driver;
    final userName = find.byValueKey('username');
    final password = find.byValueKey('password');
    final login = find.byType('RaisedButton');
    final notLoggedIn = find.byValueKey('notLoggedIn');

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver!.close();
    });

    test('trigger sync validation', () async {
      await driver!.tap(userName);
      await driver!.enterText('user');
      await driver!.waitFor(find.text('user'));

      await driver!.tap(password);
      await driver!.enterText('pass');
      await driver!.waitFor(find.text('pass'));

      await driver!.tap(login);

      // verify sync validators ran
      driver!.waitFor(find.text(userSync));
      driver!.waitFor(find.text(passSync));
      driver!.waitForAbsent(find.text(userASync));
      driver!.waitForAbsent(find.text(passASync));

      // verify not logged in
      String loginStatus = await driver!.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));
    });

    test('trigger async validation', () async {
      await driver!.tap(userName);
      await driver!.enterText('username');
      await driver!.waitFor(find.text('username'));

      await driver!.tap(password);
      await driver!.enterText('password');
      await driver!.waitFor(find.text('password'));

      await driver!.tap(login);

      // verify user async validator ran
      driver!.waitForAbsent(find.text(userSync));
      driver!.waitForAbsent(find.text(passSync));
      driver!.waitFor(find.text(userASync));
      driver!.waitForAbsent(find.text(passASync));

      // verify not logged in
      String loginStatus = await driver!.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));
      final SerializableFinder loggedIn = find.byValueKey('loggedIn');
      await driver!.waitForAbsent(loggedIn);
    });

    test('try to login', () async {
      String loginStatus = await driver!.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));

      await driver!.tap(userName);
      await driver!.enterText('username1');
      await driver!.waitFor(find.text('username1'));

      await driver!.tap(password);
      await driver!.enterText('password1');
      await driver!.waitFor(find.text('password1'));

      await driver!.tap(login);

      // verify no validator ran
      driver!.waitForAbsent(find.text(userSync));
      driver!.waitForAbsent(find.text(passSync));
      driver!.waitForAbsent(find.text(userASync));
      driver!.waitForAbsent(find.text(passASync));

      await driver!.waitFor(find.byValueKey('loggedIn'));
      final SerializableFinder loggedIn = find.byValueKey('loggedIn');
      expect(loggedIn, isNotNull);
    });
  });
}
