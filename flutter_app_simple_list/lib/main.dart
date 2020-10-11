import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'RandomWords.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: RandomWords()
    );
    throw UnimplementedError();
  }
}

