library modal_progress_hud;

import 'package:flutter/material.dart';

class ModalProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final ProgressIndicator progressIndicator;

  ModalProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            child: progressIndicator,
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
