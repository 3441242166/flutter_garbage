import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_garbage/model/app_bean.dart';
import 'package:flutter_garbage/model/main_page_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class MainBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainSearchBottom();
  }
}

class GarbageItem extends StatelessWidget {
  final String name;
  final String type;

  GarbageItem(this.name, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 6),
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[Text(name), Text(type)],
      )),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String str;

  HistoryItem(this.str);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MainPageState>(
      builder: (context, stroe) {
        return new ActionChip(
          avatar: new CircleAvatar(
              backgroundColor: Colors.blue, child: Text(str.substring(0, 1))),
          label: new Text(str),
          onPressed: () {
            stroe.state.bottomState.searchKey = str;
            stroe.dispatch(ReduxAction.CHIP_CLICK);
          },
        );
      },
    );
  }
}

//------------------------------------------------------------------------------

class MainSearchBottom extends StatefulWidget {
  @override
  _MainSearchBottomState createState() => _MainSearchBottomState();
}

class _MainSearchBottomState extends State<MainSearchBottom> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MainPageState>(
        builder: (BuildContext context, Store<MainPageState> store) {
      return Container(
        padding: EdgeInsets.only(left: 32.0, right: 32.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 48.0),
              TextField(
                controller: TextEditingController(
                    text: store.state.bottomState.searchKey),
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "输入垃圾名字"),
                onChanged: (content) {
                  store.state.bottomState.searchKey = content;
                },
              ),
              SizedBox(height: 32.0),
              CupertinoButton(
                color: Colors.blueAccent,
                child: Text(
                  "搜索 🔍",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _searchClick(store);
                },
              ),
              SizedBox(height: 28.0),
              //Text("最近搜索 🔍"),
              SizedBox(height: 20.0),
              Wrap(
                  spacing: 8.0, // 主轴(水平)方向间距
                  runSpacing: 4.0, // 纵轴（垂直）方向间距
                  alignment: WrapAlignment.center, //沿主轴方向居中
                  children: store.state.bottomState.historySearchKey.map((str) {
                    return HistoryItem(str);
                  }).toList()),
            ],
          ),
        ),
      );
    });
  }

  _searchClick(Store<MainPageState> store) {
    var text = store.state.bottomState.searchKey;
    if (text != null && text.length > 0) {
      getGarbageResponse(text, store);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("检查下你的输入哦")));
    }
  }

  // http://www.mxnzp.com/api/rubbish/type?name=西瓜
  getGarbageResponse(String searchKey, Store<MainPageState> store) async {
    try {
      final response = await http
          .get("http://www.mxnzp.com/api/rubbish/type?name=$searchKey");

      if (response.statusCode == 200) {
        final httpResult = HttpResult(response.body);
        store.state.bottomState.result = httpResult.data;
        _openResultDialog(httpResult.data);
        store.state.bottomState.searchKey = searchKey;
        store.dispatch(ReduxAction.SearchSuccess);
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("网络错误，请稍后再试")));
      }
    } catch (thr) {
      print(thr);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("网络错误，请稍后再试")));
    }
  }

  _openResultDialog(GarbageResultBean data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            height: 380,
            child: ListView.builder(
                itemCount: data.otherData.length + 1,
                itemExtent: 80,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GarbageItem(
                        data.data.goodsName, data.data.goodsType);
                  }
                  return GarbageItem(data.otherData[index - 1].goodsName,
                      data.otherData[index - 1].goodsType);
                }));
      },
    );
  }
}
