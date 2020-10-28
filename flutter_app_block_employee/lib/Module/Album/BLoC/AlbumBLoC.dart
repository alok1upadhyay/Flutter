import 'dart:async';
import 'dart:convert';

import 'package:flutter_app_block_employee/Module/Album/Events/AlbumEvents.dart';
import 'package:flutter_app_block_employee/Module/Album/Models/Album.dart';
import 'package:http/http.dart' as http;

class AlbumBLoC {
  final albumStreamController = StreamController<Album>();
  Stream<Album> get albumStreamControllerStream => albumStreamController.stream;
  StreamSink<Album> get albumStreamControllerSink => albumStreamController.sink;

  final callApiStreamController = StreamController<CallAlbumAPIEvent>();
  Stream<CallAlbumAPIEvent> get callApiStreamControllerStream =>
      callApiStreamController.stream;
  StreamSink<CallAlbumAPIEvent> get callApiStreamControllerSink =>
      callApiStreamController.sink;

  Album album;

  AlbumBLoC() {
    callApiStreamControllerStream.listen(callAPI);
  }

  void dispose() {
    albumStreamController.close();
    callApiStreamController.close();
  }

  void callAPI(CallAlbumAPIEvent callAlbumAPIEvent) {
    Future<Album> futureAlbum = fetchAlbum();
    futureAlbum.then((value) {
      album = value;
      albumStreamControllerSink.add(album);
    });
  }

  Future<Album> fetchAlbum() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
