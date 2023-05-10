import 'package:firebase_example/screens/home/chat_app/conversationscreen.dart';
import 'package:firebase_example/screens/home/chat_app/search.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/helperFunctions.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/google_maps.dart' as gMap;
import 'package:js/js.dart';
import 'dart:ui' as ui;
import 'dart:html';
import 'dart:math';
import 'locationJS.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:neo4driver/neo4driver.dart';




class Bubbles extends StatefulWidget {
  @override
  _BubblesState createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> {

  AuthService authMethods = new AuthService();
  DatabaseService databaseMethods = new DatabaseService();
  Position position;

  @override
  void initState(){
    // TODO: implement initState
    getUserInfo();
  //  _getCurrentLocation();
    // getCurrentPositionUsingGeolocator();

    NeoClient.withAuthorization(
      username: 'neo4j',
      password: 'Gi2DPWjcEnB3TjRqzpi1EZD9wAgVTlpr353fqas1JdY',
      databaseAddress: 'neo4j+s://08e5fd14.databases.neo4j.io',
      databaseName: 'Neo4j',
    );

    super.initState();
  }


   Future<Position> getCurrentPositionUsingGeolocator() async {
     position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
     return position;
   }

  // success(pos) {
  //   try {
  //     print(pos.coords.latitude);
  //     print(pos.coords.longitude);
  //   } catch (ex) {
  //     print("Exception thrown : " + ex.toString());
  //   }
  // }

  // _getCurrentLocation() {
  //   if (kIsWeb) {
  //     getCurrentPosition(allowInterop((pos) => success(pos)));
  //   }
  // }


  Widget _map() {

    final String htmlId = "map";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = gMap.MapOptions()
        ..zoom = 15.0
        ..center = gMap.LatLng(position.latitude, position.longitude);

      final elem = DivElement()..id = htmlId;
      final map = gMap.GMap(elem, mapOptions);

      final _icon = gMap.Icon()
        ..scaledSize = gMap.Size(40, 40)
        ..url =
            "https://lh3.googleusercontent.com/ogw/ADGmqu_RzXtbUv4nHU9XjdbNtDNQ5XAIlOh_1jJNci48=s64-c-mo";

      gMap.Marker(gMap.MarkerOptions()
        ..anchorPoint = gMap.Point(0.5, 0.5)
        ..icon = _icon
        ..position = gMap.LatLng(position.latitude, position.longitude)
        ..map = map
        ..title = htmlId);


      // final polyline = gMap.Polyline(gMap.PolylineOptions()
      //   ..path = [
      //     gMap.LatLng(position.latitude, position.longitude),
      //     gMap.LatLng(position.latitude+0.001110, position.longitude+0.001110)
      //   ]
      //   ..strokeColor = "#75A9FF"
      //   ..strokeOpacity = 1.0
      //   ..strokeWeight = 3);
      // polyline.map = map;

      final areaCircle = gMap.CircleOptions()
        ..map = map
        ..center = gMap.LatLng(position.latitude, position.longitude)
        ..radius = 400;
      gMap.Circle(areaCircle);

      map.onCenterChanged.listen((event) {
        print(map.center.lat);
        print(map.center.lng);
        print(map.zoom);
      });

      map.onDragstart.listen((event) {});

      map.onDragend.listen((event) {});

      // final svgMarker = gMap.GSymbol()
      //   ..rotation = 45
      //   ..path = 'M 10 10 H 90 V 90 H 10 L 10 10'
      //   ..fillColor = 'blue'
      //   ..fillOpacity = 0.8
      //   ..scale = 1
      //   ..strokeColor = 'blue'
      //   ..strokeWeight = 14;
      //
      // gMap.Marker(gMap.MarkerOptions()
      //   ..position = map.center
      //   ..icon = svgMarker
      //   ..map = map);

      return elem;
    });
    return HtmlElementView(viewType: htmlId);
  }




  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: FloatingActionButton(
            heroTag: "Find bubbles Btn",
            child: Icon(Icons.bubble_chart),
            onPressed: (){
              print("find bubbles");

               NeoClient().createRelationship(
                startNodeId: 1,
                endNodeId: 2,
                relationshipLabel: "rel_label",
                properties: {
                  "Property1": "value1",
                  "Property2": 2,
                },
              );

            },
          ),
        ),
        body:FutureBuilder(
        future: getCurrentPositionUsingGeolocator(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
     return Center(
      child: CircularProgressIndicator(),
    );
    } else if (snapshot.hasError) {
    return Text("Error ");
    }
    else if(snapshot.data == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else if(snapshot.hasData){
    return Stack(children: [
    _map()
    ]);
    }
    })
    );
  }
}
