//
//current location - noida 28.4970, 77.4325
//destination - 28.5118, 77.4124
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

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
const String kGoogleApiKey = "";

class _MyHomePageState extends State<MyHomePage> {

// to get places detail (lat/lng)
  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  List<Marker> globalMarkerList  = List<Marker>();
  final Set<Polyline>_polyline = {};
  MapType mapType = MapType.none;

  @override
  void initState() {
    // TODO: implement initState
    Future<Position> currentDefaultPosition = getCurrentPosition();
    currentDefaultPosition.then((value) {
    updateMap(value, true);
    });
  }

  //for any change in marker like pick or  drop just call this method
  void updateMap(Position value, bool isPickUp) {
    //update marker Set
    MarkerPickDrop mpd = getMarkerWithMarkerValueAndpickDropState(value, isPickUp);
    updateGlobalMarkerListState(mpd);
    //update polyline
    Polyline polyline = getPolyLine(value);
    updatePolylineState(polyline);
    //update map style
    updateMapStyle();
  }
/*
* I have foundle map have some problems in rendering. I tried with hybrid, 
* satellite & terrain they all take a lot of time in updating UI. So you will 
* notice that i am rendering mapType after a deleay of 1 sec.
* */
  void updateMapStyle() {
    Future.delayed(const Duration(milliseconds: 1000), ()
    {
      //update map style
      setState(() {
        mapType = MapType.normal;
      });
    });
  }

  /*
* 
* By default when youlaunch ther will be on pick up point which is your default current location on index 0.
* when you set drop at, it is either added or update on index 1.
* I will use   s class model/tuple/dictiry later fix
* */
  void updateGlobalMarkerListState(MarkerPickDrop mpd) {

    var l = globalMarkerList;
    if (mpd.isPick == true) {
      if (l.length == 0){
        l.insert(0, mpd.marker);
      }else {
        l.removeAt(0);
        l.insert(0, mpd.marker);
      }
    } else {
      if (l.length == 1) {
        l.add(mpd.marker);
      } else {
        l.removeLast();
        l.add(mpd.marker);
      }
    }

    setState(() {
      this.globalMarkerList = l;
    });
  }

  void updatePolylineState(Polyline polyline) {
    Future.delayed(const Duration(milliseconds: 1000), ()
    {
      setState(() {
        _polyline.clear();
      });
      setState(() {
        _polyline.add(polyline);
      });
    });
  }

  Polyline getPolyLine(Position value) {

    List<LatLng> l = List<LatLng>();

    for (var i = 0; i < globalMarkerList.length; i++) {
      Marker m = globalMarkerList.elementAt(i);
      LatLng ll = LatLng(m.position.latitude, m.position.longitude);
      l.add(ll);
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId(value.toString()),
      visible: true,
      points: l,
      color: Colors.red,
    );
    return polyline;
  }

  MarkerPickDrop getMarkerWithMarkerValueAndpickDropState(Position value, bool isPick) {
    MarkerPickDrop mpd = MarkerPickDrop();
    mpd.isPick = isPick;
    mpd.marker = Marker(position: LatLng(value.latitude, value.longitude), markerId: MarkerId(value.toString()));
    return mpd;
  }

  Future<Position> getCurrentPosition() async {
    Position p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return p;
  }

  @override
  Widget build(BuildContext context) {
//draw map only when you have position and markers set
    if (this.globalMarkerList.length > 0) {

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
                child: Text("Pick From"),
                onPressed: ()  {
                  buttonPressed(context, true);
                },
              ),
              FlatButton(
                child: Text("Drop At"),
                onPressed: ()  {
                  buttonPressed(context, false);
                  },
              ),
            ],
          ),
        ),
      );
//otherwise show loading text...
    }else {
      return getLoader(context);
    }

  }

  void buttonPressed(BuildContext context, bool isPick) async {
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: kGoogleApiKey);
    Future<PlacesDetailsResponse> placesDetailsResponse = getPredictedLatLng(p, isPick);
    placesDetailsResponse.then((detail) {
      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      Position position = Position(latitude: lat, longitude: lng);
      updateMap(position, isPick);
    }).catchError((error) {
      //default position
      Position position = Position(latitude: globalMarkerList.elementAt(0).position.latitude, longitude: globalMarkerList.elementAt(0).position.longitude);
      updateMap(position, isPick);
      print(error);
    }).whenComplete(() {

    });
  }
//return google map
  GoogleMap buildGoogleMap() {

    return GoogleMap(
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
      polylines: _polyline,
      markers: Set.from(globalMarkerList),
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(globalMarkerList.elementAt(0).position.latitude, globalMarkerList.elementAt(0).position.longitude),
          zoom: 15),
    );
  }

  //return loader
  Widget getLoader(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<PlacesDetailsResponse> getPredictedLatLng(Prediction p, bool isPickUp) async {
      PlacesDetailsResponse detail =
      await places.getDetailsByPlaceId(p.placeId);
      return detail;
  }
}

class MarkerPickDrop {
  bool isPick;
  Marker marker;
}