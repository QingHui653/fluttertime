import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

///
///1. 路由  MaterialPageRoute
///2. 点击 列表 进入 喜欢 列表
///
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Zhi Hu Main',
      home: new MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  @override
  createState() => new MainList();
}

class MainList extends State<MainView> {
  final newsUrl = "http://news-at.zhihu.com/api/4/news/";
  final lastUrl = "http://news-at.zhihu.com/api/4/news/latest";
  final beforeUrl = "http://news.at.zhihu.com/api/4/news/before/";

  String date = "";
  List<Map> stories;
  List<Map> lastStory;
  List<Map> beforeStory;
  ScrollController scrollController = new ScrollController();

  MainList() {
    scrollController.addListener((){
        var maxScroll = scrollController.position.maxScrollExtent;
        var pixels = scrollController.position.pixels;

        if (maxScroll == pixels){
          loadData();
        }
    });
  }

  Future<String> getStoryListJson() async {
    print("httpList------");
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(lastUrl));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<String> getStoryJson(var id) async {
    print("httpStory------");
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(newsUrl+id.toString()));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    print("loadData------");
    await getStoryListJson(); //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {}); //什么都不做，只为触发RefreshIndicator的子控件刷新
  }

  clickStory(var id ){
    print("clickStory");
    print(id);
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          return new FutureBuilder(
            future: getStoryJson(id),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(
                    child: new Card(
                      child: new Text('loading...'), //在页面中央显示正在加载
                    ),
                  );
                default:
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text(jsonDecode(snapshot.data)['title']),
                  ),
                  body: new SingleChildScrollView(
                    child: new Center(
                      child: new HtmlView(
                        data: jsonDecode(snapshot.data)['body'],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
        appBar: new AppBar(
          title: new Text(''),
        ),
        body: bodyList(context),
      );
  }

  Widget bodyList(BuildContext context){
    return new RefreshIndicator(
      child: new FutureBuilder(
        //用于懒加载的FutureBuilder对象
        future: getStoryListJson(), //HTTP请求获取数据，将被AsyncSnapshot对象监视
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: //get未执行时
            case ConnectionState.waiting: //get正在执行时
              return new Center(
                child: new Card(
                  child: new Text(''), //在页面中央显示正在加载
                ),
              );
            default:
              if (snapshot.hasError) //get执行完成但出现异常
                return new Text('Error: ${snapshot.error}');
              else //get正常执行完成
                // 创建列表，列表数据来源于snapshot的返回值，而snapshot就是get(widget.newsType)执行完毕时的快照
                // get(widget.newsType)执行完毕时的快照即函数最后的返回值。
                return storyList(context, snapshot);
          }
        },
      ),
      onRefresh: loadData,
    );
  }


  Widget storyList(BuildContext context, AsyncSnapshot snapshot) {
    print(snapshot.data);
    List values;
    values = jsonDecode(snapshot.data)['stories'] != null? jsonDecode(snapshot.data)['stories'] : [''];
    switch (values.length) {
      case 1: //没有获取到数据，则返回请求失败的原因
        return new Center(
          child: new Card(
            child: new Text(jsonDecode(snapshot.data)['message']),
          ),
        );
      default:
        return new ListView.builder(
          padding: const EdgeInsets.all(4.0),
          itemCount: values == null ? 0 : values.length,
          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            return getStoryList(values[i]);
          },
          controller: scrollController,
          
        );
    }
  }

  Widget getStoryList(story) {
    print(story['title']);
    return new GestureDetector(
      onTap: () { clickStory(story['id']); },
      child: new Container(
        constraints: new BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 100.0,
        ),
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey[100],
        alignment: Alignment.centerLeft,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Image.network(
                story['images'][0],
              ),
            ),
            new Expanded(
              child: new Text(story['title'], textAlign: TextAlign.center),
            ),
          ],
        ),
      )
    );
  }
}
