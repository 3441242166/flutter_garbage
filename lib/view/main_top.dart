import 'package:flutter/material.dart';
import 'package:flutter_garbage/model/main_page_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MainTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MainPageState>(
        builder: (BuildContext context, Store<MainPageState> store) {
      return store.state.topState.type == TopType.IMAGE
          ? MainImageTop()
          : MainImageTop();
    });
  }
}

class MainImageTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueAccent,
      width: double.infinity,
      height: 300,
      child: Text.rich(TextSpan(
          children: [TextSpan(text: "垃圾", style: TextStyle(fontSize: 46, color: Colors.white)),
            TextSpan(text: " 分类助手", style: TextStyle(fontSize: 32, color: Colors.white70))])),
    );
  }
}
