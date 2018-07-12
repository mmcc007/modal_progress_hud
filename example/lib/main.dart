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
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  // manage state of modal progress HUD widget
  bool _inAsyncCall = false;

  final _LoginData _actualLoginData = _LoginData();
  final _LoginData _validLoginData = _LoginData(
    userName: 'username1',
    password: 'password1',
  );
  bool _isValidUserName = true; // managed by response from server
  bool _isValidPassword = true; // managed by response from server
  bool _isLoggedIn = false; // managed by response from server

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
          _isLoggedIn = false;
          if (_actualLoginData.userName == _validLoginData.userName)
            _isValidUserName = true;
          else
            _isValidUserName = false;
          if (_actualLoginData.password == _validLoginData.password)
            _isValidPassword = true;
          else
            _isValidPassword = false;
          if (_isValidUserName && _isValidPassword) _isLoggedIn = true;
          // stop the modal progress HUD
          _inAsyncCall = false;
        });
      });
    }
  }

  Widget _buildWidget() {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    // run the validators on reload
    _loginFormKey.currentState?.validate();
    return Form(
      key: this._loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 4.0),
            child: TextFormField(
              key: Key('username'),
              initialValue: _actualLoginData.userName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'enter username', labelText: 'User Name'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: this._validateUserName,
              onSaved: (String value) {
                _actualLoginData.userName = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
            child: TextFormField(
              key: Key('password'),
              obscureText: true,
              initialValue: _actualLoginData.userName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'enter password', labelText: 'Password'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: this._validatePassword,
              onSaved: (String value) {
                _actualLoginData.password = value;
              },
            ),
          ),
          RaisedButton(
            key: Key('login'),
            onPressed: _submit,
            child: Text('Login'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 4.0),
            child: _isLoggedIn
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modal Progress HUD Demo'),
        backgroundColor: Colors.blue,
      ),
      body: ModalProgressHUD(
        child: _buildWidget(),
        inAsyncCall: _inAsyncCall,
        // demo of additional parameters
        opacity: 0.5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}

class _LoginData {
  String userName;
  String password;
  _LoginData({this.userName, this.password});
}
