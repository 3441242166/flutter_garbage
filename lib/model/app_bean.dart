// http://www.mxnzp.com/api/rubbish/type?name=西瓜
import 'dart:convert';

import 'package:flutter/material.dart';

class HttpResult {
  int code;
  String msg;
  GarbageResultBean data;

  HttpResult(String json) {
    final map = jsonDecode(json);
    print(map['code']);
    print(map['msg']);
    print(map['data']);

    code = map['code'];
    msg = map['msg'];
    data = GarbageResultBean(map['data']);
  }
}

class GarbageResultBean {
  GarbageBean data;
  List<GarbageBean> otherData;

  GarbageResultBean(map) {
    data = GarbageBean(map['aim']);
    otherData = [];
    print("recommendList = ${map['recommendList']}");
    for (var data in map['recommendList']) {
      print(data);
      otherData.add(GarbageBean(data));
    }
  }
}

class GarbageBean {
  String goodsName;
  String goodsType;

  GarbageBean(data) {
    goodsName = data['goodsName'];
    goodsType = data['goodsType'];
  }
}

//所有BLoC的通用接口
abstract class BlocBase {
  void dispose();
}

//通用BLoC提供商
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override

  /// 便于资源的释放
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
