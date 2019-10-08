// http://www.mxnzp.com/api/rubbish/type?name=西瓜
import 'dart:convert';

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

