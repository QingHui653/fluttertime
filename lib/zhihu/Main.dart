import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;
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
