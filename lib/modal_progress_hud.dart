library modal_progress_hud;

import 'package:flutter/material.dart';

class ModalProgressHUD extends StatelessWidget {
  final Widget _child;
  final bool _inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset offset;
  final bool dismissible;

  ModalProgressHUD({
    Key key,
    @required child,
    @required inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        _child = child,
        _inAsyncCall = inAsyncCall,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(_child);
    if (_inAsyncCall) {
      Widget layOutProgressIndicator;
      if (offset == null)
        layOutProgressIndicator = new Center(child: progressIndicator);
      else {
        layOutProgressIndicator = new Positioned(
          child: progressIndicator,
          left: offset.dx,
          top: offset.dy,
        );
      }
      final modal = [
        new Opacity(
          child: new ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return new Stack(
      children: widgetList,
    );
  }
}
