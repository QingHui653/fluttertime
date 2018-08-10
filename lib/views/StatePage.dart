import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

///
///1.使用 package 包 ,在 yaml 中 dependencies 引入
///2.使用 State 组件 保存状态 state
///
/* State */
class StatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new RandomWords(),
        ),
      ),
    );
  }
}


class RandomWords extends StatefulWidget{
  @override
  createState()=> new RandomWordsSate();
}

class RandomWordsSate extends State<RandomWords>{
  @override
  Widget build(BuildContext context){
    final wordPair = new WordPair.random();
    return new Text(wordPair.asPascalCase);
  }
}