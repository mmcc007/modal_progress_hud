import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('app test: ', () {
    FlutterDriver driver;
    SerializableFinder userName;
    SerializableFinder password;
    SerializableFinder login;
    SerializableFinder notLoggedIn;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      userName = find.byValueKey('username');
      expect(userName, isNotNull);
      password = find.byValueKey('password');
      expect(password, isNotNull);
      login = find.byValueKey('login');
      expect(login, isNotNull);
      notLoggedIn = find.byValueKey('notLoggedIn');
      expect(notLoggedIn, isNotNull);
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    test('trigger sync validation', () async {
      await driver.tap(userName);
      await driver.enterText('user');
      await driver.waitFor(find.text('user'));

      await driver.tap(password);
      await driver.enterText('pass');
      await driver.waitFor(find.text('pass'));

      await driver.tap(login);

      String loginStatus = await driver.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));
    });

    test('trigger async validation', () async {
      await driver.tap(userName);
      await driver.enterText('username');
      await driver.waitFor(find.text('username'));

      await driver.tap(password);
      await driver.enterText('password');
      await driver.waitFor(find.text('password'));

      await driver.tap(login);

      final SerializableFinder loggedIn = find.byValueKey('loggedIn');
      await driver.waitForAbsent(loggedIn);
    });

    test('try to login', () async {
      String loginStatus = await driver.getText(notLoggedIn);
      expect(loginStatus, equals('Not logged in'));

      await driver.tap(userName);
      await driver.enterText('username1');
      await driver.waitFor(find.text('username1'));

      await driver.tap(password);
      await driver.enterText('password1');
      await driver.waitFor(find.text('password1'));

      await driver.tap(login);

      await driver.waitFor(find.byValueKey('loggedIn'));
      final SerializableFinder loggedIn = find.byValueKey('loggedIn');
      expect(loggedIn, isNotNull);
    });
  });
}
