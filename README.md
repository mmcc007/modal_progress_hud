# modal_progress_hud

A simple widget wrapper to enable modal progress HUD (a modal progress indicator)

[![pub package](https://img.shields.io/pub/v/modal_progress_hud.svg)](https://pub.dartlang.org/packages/modal_progress_hud)
[![Build Status](https://travis-ci.org/mmcc007/modal_progress_hud.svg?branch=master)](https://travis-ci.org/mmcc007/modal_progress_hud)
[![Coverage Status](https://coveralls.io/repos/github/mmcc007/modal_progress_hud/badge.svg?branch=master)](https://coveralls.io/github/mmcc007/modal_progress_hud?branch=master)

Inspired by [this](https://codingwithjoe.com/flutter-how-to-build-a-modal-progress-indicator/) article.


## Demo
![Demo](https://github.com/mmcc007/modal_progress_hud/blob/master/modal_progress_hud.gif)

*See example for details*

## Usage
```
ModalProgressHUD(child: _buildWidget(), inAsyncCall: _saving)
```
Simply wrap the widget as a child of `ModalProgressHUD`, typically a form, together with a boolean
maintained in local state.
On first loading, the boolean is false, and the child is displayed.
After submitting, and before making the async call, set the local boolean to
true. The child will redraw and will show the modal progress HUD.
After
they async call completes, set the boolean to false. The child will
redraw without the modal progress indicator.

```
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

## Example

See the [example application](https://github.com/mmcc007/modal_progress_hud/tree/master/example) source
for a complete sample app using the modal progress HUD. Included in the
example is a method for using a form's validators while making async
calls (see [flutter/issues/9688](https://github.com/flutter/flutter/issues/9688) for details).

## Issues and feedback

Please file [issues](https://github.com/mmcc007/modal_progress_hud/issues/new)
to send feedback or report a bug. Thank you!

