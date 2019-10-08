import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_bean.dart';

enum TopType {
  IMAGE,
}

enum BottomType { SEARCH, RESULT }

class MainPageState {
  TopState topState;
  BottomState bottomState;

  MainPageState.initState()
      : topState = TopState(),
        bottomState = BottomState();
}

class BottomState {
  BottomType type;
  String searchKey;
  GarbageResultBean result;
  List<String> historySearchKey;

  BottomState()
      : type = BottomType.SEARCH,
        searchKey = "",
        historySearchKey = List<String>();
}

class TopState {
  TopType type;

  TopState() : type = TopType.IMAGE;
}

enum ReduxAction {
  INIT_FINISH,
  SearchSuccess,
  SearchError,
  CHIP_CLICK,
}

MainPageState getReduce(MainPageState state, action) {
  if (action == ReduxAction.SearchSuccess) {
    if (!state.bottomState.historySearchKey
        .contains(state.bottomState.searchKey)) {
      if (state.bottomState.historySearchKey.length > 8) {
        state.bottomState.historySearchKey.removeAt(0);
      }
      state.bottomState.historySearchKey.add(state.bottomState.searchKey);
      save(state.bottomState.historySearchKey);
    }
  }
  return state;
}

save(List<String> historySearchKey) async {
  String history = "";

  for (var item in historySearchKey) {
    if (history.length == 0) {
      history = history + item;
    } else {
      history = history + ',' + item;
    }
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString("history", history);
}

Future<List<String>> get() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var history = prefs.getString("history");

  var list = List<String>();

  if (history == null) {
    return list;
  }

  for (var data in history.split(',')) {
    list.add(data);
  }
  return list;
}
