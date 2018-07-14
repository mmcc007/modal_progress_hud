import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(
        loginData: LoginData(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final LoginData loginData;
  LoginPage({@required this.loginData});
  @override
  _LoginPageState createState() => _LoginPageState(loginData: loginData);
}

class _LoginPageState extends State<LoginPage> {
  final LoginData loginData;
  _LoginPageState({this.loginData});

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  // manage state of modal progress HUD widget
  bool _inAsyncCall = false;

  final LoginData _validLoginData = LoginData(
    userName: 'username1',
    password: 'password1',
  );
  bool _isValidUserName = true; // managed by response from server
  bool _isValidPassword = true; // managed by response from server

  // validate user name
  String _validateUserName(String userName) {
    if (userName.length < 8) {
      return 'Username must be at least 8 characters';
    }

    if (!_isValidUserName) {
      _isValidUserName = true;
      return 'Incorrect user name';
    }

    return null;
  }

  // validate password
  String _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!_isValidPassword) {
      _isValidPassword = true;
      return 'Incorrect password';
    }

    return null;
  }

  void _submit() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      // dismiss keyboard
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _inAsyncCall = true;
      });

      // Simulate a service call
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          if (loginData.userName == _validLoginData.userName)
            _isValidUserName = true;
          else
            _isValidUserName = false;
          if (loginData.password == _validLoginData.password)
            _isValidPassword = true;
          else
            _isValidPassword = false;
          if (_isValidUserName && _isValidPassword) {
            loginData.loggedIn = true;
          }
          // stop the modal progress HUD
          _inAsyncCall = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modal Progress HUD Demo'),
        backgroundColor: Colors.blue,
      ),
      body: ModalProgressHUD(
        child: LoginForm(
          loginFormKey: _loginFormKey,
          submit: _submit,
          loginData: loginData,
          validateUserName: _validateUserName,
          validatePassword: _validatePassword,
        ),
        inAsyncCall: _inAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> loginFormKey;
  final LoginData loginData;
  final Function validateUserName;
  final Function validatePassword;
  final Function submit;
  LoginForm({
    @required this.loginFormKey,
    @required this.submit,
    @required this.loginData,
    @required this.validateUserName,
    @required this.validatePassword,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    // run the validators on reload
    loginFormKey.currentState?.validate();
    return Form(
      key: this.loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 4.0),
            child: TextFormField(
              key: Key('username'),
              initialValue: loginData.userName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'enter username', labelText: 'User Name'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: validateUserName,
              onSaved: (String value) {
                loginData.userName = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
            child: TextFormField(
              key: Key('password'),
              obscureText: true,
              initialValue: loginData.userName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'enter password', labelText: 'Password'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: validatePassword,
              onSaved: (String value) {
                loginData.password = value;
              },
            ),
          ),
          RaisedButton(
            key: Key('login'),
            onPressed: submit,
            child: Text('Login'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 4.0),
            child: loginData.loggedIn
                ? Text(
                    'Login successful!',
                    key: Key('loggedIn'),
                    style: TextStyle(fontSize: 20.0),
                  )
                : Text(
                    'Not logged in',
                    key: Key('notLoggedIn'),
                    style: TextStyle(fontSize: 20.0),
                  ),
          ),
        ],
      ),
    );
  }
}

class LoginData {
  String userName;
  String password;
  bool loggedIn;
  LoginData({this.userName, this.password, this.loggedIn = false});

  @override
  String toString() {
    return 'LoginData{\n'
        '\tuserName = $userName\n'
        '\tpassword = $password\n'
        '\tloggedIn = $loggedIn\n'
        '}';
  }
}
