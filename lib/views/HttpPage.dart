import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ipAddress = "未知";

  _getIPAddress() async {
    String url = 'https://httpbin.org/ip';
    var response = await http.read(url);
    Map data = json.decode(response);
    String ip = data['origin'];

    /*
    bool mounted
    这个状态对象当前是否在树中。
    用于此处，如果控件在数据正在请求时从树中删除，则我们要丢弃该数据，而不是调用setState来更新实际不存在的内容。
     */
    if(!mounted) return;

    setState((){
      _ipAddress = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      body: new Center(
        child: new Column(
          children: <Widget> [
            spacer,
            new Text('您当前的IP地址是：'),
            new Text('$_ipAddress'),
            spacer,
            new RaisedButton(
              onPressed: _getIPAddress,
              child: new Text('获取IP地址'),
            )
          ]
        )
      )
    );
  }
}