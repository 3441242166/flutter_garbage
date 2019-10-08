import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_bottom.dart';
import 'main_top.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: MainTop()),
          Expanded(flex: 2, child: MainBottom()),
        ],
      ),
    );
  }
}
