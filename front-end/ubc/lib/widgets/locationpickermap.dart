import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerMap extends StatefulWidget {
  LocationPickerMap({
required this.email ,
required this.password ,
required this.firstName ,
required this.lastName ,
required this.phoneNumber ,
  });
  String email, password, firstName, lastName, phoneNumber;

  @override
  _LocationPickerMapState createState() => _LocationPickerMapState(
    email: email,
    password: password,
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phoneNumber
  );
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  _LocationPickerMapState({
required this.email ,
required this.password ,
required this.firstName ,
required this.lastName ,
required this.phoneNumber ,
  });
  LatLng _selectedLocation = LatLng(0, 0); // Default initial location
  String email, password, firstName, lastName, phoneNumber;
double targetLatitude = 33.5138;
  double targetLongitude = 36.2765;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Picker'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(targetLatitude, targetLongitude),
          zoom: 13.0,
          onTap: (tapPosition, latLng) {
            setState(() {
              _selectedLocation = latLng;
            });
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'], 
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
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
