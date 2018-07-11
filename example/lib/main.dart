import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _monitor = true;
  bool _lights = false;
  bool _kitchen = false;
  bool _bedroom = false;
  bool _saving = false;

  void _submit() {
    print('submit called...');

    setState(() {
      _saving = true;
    });

    //Simulate a service call
    print('submitting to backend...');
    new Future.delayed(new Duration(seconds: 4), () {
      setState(() {
        _saving = false;
      });
    });
  }

  Widget _buildWidget() {
    return new Form(
      child: new Column(
        children: [
          new CheckboxListTile(
            title: const Text('Enable Monitoring?'),
            value: _monitor,
            onChanged: (bool value) {
              setState(() {
                _monitor = value;
              });
            },
            secondary: const Icon(Icons.power),
          ),
          new SwitchListTile(
            title: const Text('Lights'),
            value: _lights,
            onChanged: (bool value) {
              setState(() {
                _lights = value;
              });
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          new SwitchListTile(
            title: const Text('Kitchen'),
            value: _kitchen,
            onChanged: (bool value) {
              setState(() {
                _kitchen = value;
              });
            },
            secondary: const Icon(Icons.kitchen),
          ),
          new SwitchListTile(
            title: const Text('Bedroom'),
            value: _bedroom,
            onChanged: (bool value) {
              setState(() {
                _bedroom = value;
              });
            },
            secondary: const Icon(Icons.hotel),
          ),
          new RaisedButton(
            onPressed: _submit,
            child: new Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Progress Indicator Demo'),
        backgroundColor: Colors.blue,
      ),
      body: ModalProgressHUD(child: _buildWidget(), saving: _saving),
    );
  }
}
