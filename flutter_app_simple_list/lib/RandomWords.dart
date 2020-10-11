import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {

  @override
  RandomWordsState createState() => RandomWordsState();

}

class RandomWordsState extends State<RandomWords> {
  var randomWordPairs = <WordPair>[];
  final savedWordPairs = Set<WordPair>();

  void pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final Iterable<ListTile> lt = savedWordPairs.map((e) {
        return ListTile(title: Text(e.toString(),),);
      });

      final List<Widget> divided = ListTile.divideTiles(tiles: lt, context: context).toList();

      return Scaffold(
        appBar: AppBar(title: Text('Saved word pairs'),),
        body: ListView(children: divided,),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    randomWordPairs.addAll(generateWordPairs().take(30));
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text('List'), actions: [
      IconButton(
        onPressed: (){
          pushSaved();
        },
       icon: Icon(Icons.list),
      ),

    ],), body: Center(child: buildList(),));
    throw UnimplementedError();
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: randomWordPairs.length,
      itemBuilder: (context, item) {
        final alreadySaved = savedWordPairs.contains(randomWordPairs[item]);

        return ListTile(
            title: Text(randomWordPairs[item].toString()),
            trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border, color: alreadySaved ? Colors.red : Colors.white,),
          onTap: () {
              setState(() {
                if (alreadySaved) {
                  savedWordPairs.remove(randomWordPairs[item]);
                } else {
                  savedWordPairs.add(randomWordPairs[item]);
                }
              });
          },
        );
        } ,
    );
  }

}