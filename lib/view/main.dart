import 'package:flutter/material.dart';
import 'package:flutter_garbage/model/main_page_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'main_page.dart';

void main() {
  final store =
      Store<MainPageState>(getReduce, initialState: MainPageState.initState());

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<MainPageState> store;

  MyApp(this.store);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          initialRoute: "/",
          routes: {
            "/": (context) => MainPage(),
            "/b": (context) => MainPage(),
            "/c": (context) => MainPage(),
            "/d": (context) => MainPage(),
            "/e": (context) => MainPage()
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ));
  }
}
