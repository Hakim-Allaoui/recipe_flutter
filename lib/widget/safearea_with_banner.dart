import 'package:flutter/material.dart';

class SafeareaWithBanner extends StatelessWidget {
  final Widget child;
  final bool top;

  SafeareaWithBanner({required this.child, this.top = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      child: Column(
        children: <Widget>[
          Expanded(flex: 10, child: child),
          // Flexible(
          //   fit: FlexFit.tight,
          //   child: Container(
          //     height: 0,
          //   ),
          // ),
        ],
      ),
    );
  }
}

