// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// import 'mapscreen.dart';

// class Geolocation extends StatefulWidget {
//   const Geolocation({super.key});

//   @override
//   State<Geolocation> createState() => _GeolocationState();
// }

// class _GeolocationState extends State<Geolocation> {
//   @override
//   Widget build(BuildContext context) {
//     Position? _currentLocation;
//     bool servicePermission = false;
//     LocationPermission permission;
//     String _currentAdress = "";
//     Future<Position> _getCurrentLocation() async {
//       servicePermission = await Geolocator.isLocationServiceEnabled();
//       if (!servicePermission) {
//         print("service disabled");
//       }
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       return await Geolocator.getCurrentPosition();
//     }

//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: Center(
//             child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 _currentLocation = await _getCurrentLocation();
//                 print("$_currentLocation");
//               },
//               child: Text("get location"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (BuildContext context) => MapScreen(),
//                       ));
//                 } catch (e) {
//                   print("$e 55555555555555");
//                 }
//               },
//               child: Text("get map"),
//             )
//           ],
//         )),
//       ),
//     );
//   }
// }
