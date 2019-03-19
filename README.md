# modal_progress_hud

A simple widget wrapper to enable modal progress HUD (a modal progress indicator, HUD = Heads Up Display)

[![pub package](https://img.shields.io/pub/v/modal_progress_hud.svg)](https://pub.dartlang.org/packages/modal_progress_hud)
[![Build Status](https://travis-ci.org/mmcc007/modal_progress_hud.svg?branch=master)](https://travis-ci.org/mmcc007/modal_progress_hud)
[![Coverage Status](https://coveralls.io/repos/github/mmcc007/modal_progress_hud/badge.svg?branch=master)](https://coveralls.io/github/mmcc007/modal_progress_hud?branch=master)

Inspired by [this](https://codingwithjoe.com/flutter-how-to-build-a-modal-progress-indicator/) article.


## Demo

![Demo](https://raw.githubusercontent.com/mmcc007/modal_progress_hud/master/modal_progress_hud.gif)

*See example for details*


## Usage

Add the package to your `pubspec.yml` file.

```yml
dependencies:
  modal_progress_hud: ^0.1.3
```

Next, import the library into your widget.

```dart
import 'package:modal_progress_hud/modal_progress_hud.dart';
```

Now, all you have to do is simply wrap your widget as a child of `ModalProgressHUD`, typically a form, together with a boolean that is maintained in local state.

```dart
...
bool _saving = false
...

@override
Widget build(BuildContext context) {
  return Scaffold(
     body: ModalProgressHUD(child: Container(
       Form(...)
     ), inAsyncCall: _saving),
  );
}
```


## Options

The current parameters are customizable in the constructor
```dart
ModalProgressHUD(
  @required inAsyncCall: bool,
  @required child: Widget,
  opacity: double,
  color: Color,
  progressIndicator: CircularProgressIndicator,
  offset: double
  dismissible: bool,
);
```


## Example

Here is an example app that demonstrates the usage. 

1. On initial load, `_saving` is false which causes your child widget to display
2. When the form is submitted, `_saving` is set to true, which will display the modal
3. Once the async call is complete, `_saving` is set back to false, hiding the modal


```dart
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _saving = false;

  void _submit() {

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
      body: ModalProgressHUD(child: _buildWidget(), inAsyncCall: _saving),
    );
  }
}

```

Update: See this [article](https://medium.com/@nocnoc/the-secret-to-async-validation-on-flutter-forms-4b273c667c03) on Medium about async form validation

See the [example application](https://github.com/mmcc007/modal_progress_hud/tree/master/example) source
for a complete sample app using the modal progress HUD. Included in the
example is a method for using a form's validators while making async
calls (see [flutter/issues/9688](https://github.com/flutter/flutter/issues/9688) for details).


### Issues and feedback

Please file [issues](https://github.com/mmcc007/modal_progress_hud/issues/new)
to send feedback or report a bug. Thank you!

