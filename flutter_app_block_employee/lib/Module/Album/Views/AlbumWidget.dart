import 'package:flutter/material.dart';
import 'package:flutter_app_block_employee/Module/Album/BLoC/AlbumBLoC.dart';
import 'package:flutter_app_block_employee/Module/Album/Events/AlbumEvents.dart';
import 'package:flutter_app_block_employee/Module/Album/Models/Album.dart';

class AlbumWidget extends StatefulWidget {
  @override
  _AlbumWidgetState createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  AlbumBLoC albumBlock;
  @override
  void initState() {
    super.initState();
    albumBlock = AlbumBLoC();
  }

  @override
  void dispose() {
    albumBlock.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAlbumWithApiCallUsingBlocWithStreamController(context);
  }

  Container buildAlbumWithApiCallUsingBlocWithStreamController(
      BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: Column(
        children: [
          StreamBuilder(
            stream: albumBlock.albumStreamControllerStream,
            builder: (context, AsyncSnapshot<Album> snapshot) {
              if (snapshot != null &&
                  snapshot.data != null &&
                  snapshot.data.title.length > 0 &&
                  snapshot.data.title != null) {
                return RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'title',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '='),
                      TextSpan(text: '${snapshot.data.title}'),
                      TextSpan(text: ' || '),
                      TextSpan(
                          text: 'id',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '='),
                      TextSpan(text: '${snapshot.data.id}'),
                      TextSpan(text: ' || '),
                      TextSpan(
                          text: 'userId',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '='),
                      TextSpan(text: '${snapshot.data.userId}'),
                    ],
                  ),
                );
              } else {
                return Text('click on below button');
              }
            },
          ),
          FlatButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              albumBlock.callApiStreamControllerSink.add(CallAlbumAPIEvent());
            },
            child: Text(
              "click me to call typicode api",
            ),
          ),
        ],
      ),
    );
  }
}
