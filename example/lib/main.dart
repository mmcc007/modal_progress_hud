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
        inputLoginData: LoginData(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final LoginData inputLoginData;
  LoginPage({@required this.inputLoginData});
  @override
  _LoginPageState createState() =>
      _LoginPageState(inputLoginData: inputLoginData);
}

class _LoginPageState extends State<LoginPage> {
  final LoginData inputLoginData;
  _LoginPageState({this.inputLoginData});

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  // manage state of modal progress HUD widget
  bool _inAsyncCall = false;

  final LoginData _serverLoginData = LoginData(
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
          if (inputLoginData.userName == _serverLoginData.userName) {
            _isValidUserName = true;
            // only validate password if username exists in database
            if (inputLoginData.password == _serverLoginData.password)
              _isValidPassword = true;
            else
              _isValidPassword = false;
          } else {
            _isValidUserName = false;
            // no such user, so password validator not triggered
            _isValidPassword = true;
          }
          if (_isValidUserName && _isValidPassword) {
            inputLoginData.isLoggedIn = true;
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: buildLoginForm(context),
          ),
        ),
        inAsyncCall: _inAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    // run the validators on reload
    _loginFormKey.currentState?.validate();
    return Form(
      key: this._loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: Key('username'),
              decoration: InputDecoration(
                  hintText: 'enter username', labelText: 'User Name'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: _validateUserName,
              onSaved: (String value) {
                inputLoginData.userName = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: Key('password'),
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'enter password', labelText: 'Password'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: _validatePassword,
              onSaved: (String value) {
                inputLoginData.password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RaisedButton(
              key: Key('login'),
              onPressed: _submit,
              child: Text('Login'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: inputLoginData.isLoggedIn
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
  bool isLoggedIn;
  LoginData({this.userName, this.password, this.isLoggedIn = false});
}
