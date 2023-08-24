import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../constant/constants.dart';
// import 'package:latlng/latlng.dart';

class MapScreen extends StatelessWidget {
  MapScreen({required this.targetLatitude, required this.targetLongitude});
  double targetLatitude = 33.5138;
  double targetLongitude = 36.2765;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Site'),
        backgroundColor: secondColor,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(targetLatitude, targetLongitude),
          zoom: 13.0, // Initial zoom level
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'], // OSM tile servers
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40,
                height: 40,
                point: LatLng(targetLatitude, targetLongitude),
                builder: (ctx) => Container(
                  child: Icon(Icons.location_pin, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
