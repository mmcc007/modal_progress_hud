# modal_progress_hud

A simple widget wrapper to enable modal progress HUD(progress indicator)

[![pub package](https://img.shields.io/pub/v/modal_progress_hud.svg)](https://pub.dartlang.org/packages/modal_progress_hud)


Inspired by [this](https://codingwithjoe.com/flutter-how-to-build-a-modal-progress-indicator/) article.

## Usage

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
      body: ModalProgressHUD(child: _buildWidget(), saving: _saving),
    );
  }
}

```

## Example

See the [example application](https://github.com/mmcc007/modal_progress_hud/tree/master/example) source
for a complete sample app using the modal progress HUD.

## Demo
![Demo](https://github.com/mmcc007/modal_progress_hud/tree/master/modal_progress_hud.gif)*See example for details*

## Issues and feedback

Please file [issues](https://github.com/mmcc007/modal_progress_hud/issues/new)
to send feedback or report a bug. Thank you!

