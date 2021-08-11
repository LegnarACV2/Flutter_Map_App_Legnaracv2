// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapApp(),
    );
  }
}

class MapApp extends StatefulWidget {
  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  LatLng point = LatLng(18.7357, -69.929611);
  LatLng newPoint = LatLng(0, 0);
  var location = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
            options: MapOptions(
                onTap: (p) async {
                  p = newPoint;
                  location = await Geocoder.local.findAddressesFromCoordinates(
                    Coordinates(p.latitude, p.longitude));
                  print("${location.first.countryName}");
                  setState(() {
                    point = p;
                  });
              },
              center: LatLng(point.latitude, point.longitude),
              zoom: 8.0
            ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a','b','c'],
            ),
            MarkerLayerOptions(markers: [
              Marker(
                width: 100.0,
                height: 100.0,
                point:
                  point,
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                )
              )
            ]

            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 34.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined),
                          hintText: "Escibir Latitud",
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        onChanged: (lat){
                          setState(() {
                            newPoint.latitude = double.parse(lat);
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined),
                          hintText: "Escibir Longitud",
                          contentPadding: EdgeInsets.all(6.0),
                        ),
                        onChanged: (lng){
                          setState(() {
                            newPoint.longitude = double.parse(lng);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "${location.first.countryName}, ${location.first.locality}, ${location.first.featureName}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }
}

