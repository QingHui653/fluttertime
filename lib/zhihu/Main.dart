import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:io';
import 'dart:convert';
// import 'package:dio/dio.dart';

///
///1. 路由  MaterialPageRoute 
///2. 点击 列表 进入 喜欢 列表
///
class Main extends StatelessWidget {
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
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
    Widget build(BuildContext context) {
      return new Scaffold (
        appBar: new AppBar(
          title: new Text(''),
        ),
        body: storyList(),
      );
    }

  Widget storyList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context,i){
        if (i.isOdd) return new Divider();
        // 分割线 也 占一格
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return getStoryList(_suggestions[index]);
      },
    );
  }

  Widget getStoryList(WordPair pair){
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 100.0,
      ),
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[100],
      alignment: Alignment.centerLeft,
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Image.network('https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',),
          ),
          new Expanded(
            child: new Text('Craft beautiful UIs', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
 
}


class HttpUtil {
   getList () {
      var httpClient = new HttpClient();
      // var uri = new Uri.http("news-at.zhihu.com","/api/4/news/latest");
      // var request = await httpClient.getUrl(uri);
      // var response = await request.close();
      // var responseBody = await response.transform(Utf8Decoder()).join();
      // print(responseBody);
      var body;
      httpClient.getUrl(Uri.parse("http://news-at.zhihu.com/api/4/news/latest"))
         .then((HttpClientRequest request) {
            return request.close();
          })
        .then((HttpClientResponse response) {
          var responseBody = response.transform(Utf8Decoder()).join();
          print("2-------------sync");
          print(responseBody);
          body = responseBody;
        });

      return body;  
   }
}