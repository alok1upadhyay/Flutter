import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Current Location And Map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position position;
  Set<Marker> markerList;

  @override
  void initState() {
    // TODO: implement initState
    updatePosition();
  }

  void updatePosition() async {

    //get user current location
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position == null) {
      return;
    }

    //write place to initialise marker list as we have at least one marker now
    this.markerList = Set<Marker>();
    //finally update state
    setState(() {
      this.position = position;
      this.markerList.add(Marker(position: LatLng(position.latitude, position.longitude), markerId: MarkerId("1")));
    });
  }

  @override
  Widget build(BuildContext context) {
//draw map only when you have position and markers set
    if (this.markerList != null && this.position != null) {

      return Scaffold(

        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(

          child: Column(
            children: [
              Expanded(
                child:buildGoogleMap(),
              ),

              FlatButton(
                child: Text("Continue"),
                onPressed: () {

                },
              ),
            ],
          ),
        ),
      );
//otherwise show loading text...
    }else {
      getLoader(context);
    }

  }

//return google map
  GoogleMap buildGoogleMap() {
    return GoogleMap(
                markers: markerList,
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 10),
              );
  }

  //return loader
  Widget getLoader(BuildContext context) {
    return Text("Loading...");
  }
}
