import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoMaps extends StatefulWidget {
  const GeoMaps({super.key});

  @override
  State<GeoMaps> createState() => _GeoMapsState();
}

class _GeoMapsState extends State<GeoMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String _locationMessage = 'Fetching location..';

  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    try {
      Position position = await determinePosition();

      if (mounted) {
        setState(() {
          _locationMessage =
              "Latitude:${position.latitude},Longitude:${position.longitude}";
          _currentLatLng = LatLng(position.latitude, position.longitude);
        });
      }
      print("Current Position: $position");
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationMessage = "Error: $e";
        });
      }
      print("Error during location fetching: $e");
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error(
        "Location services are disabled. Please enable them in your device settings.",
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error(
          "Location permissions are denied. Please grant them for this app to function.",
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied. We cannot request permissions. You will need to enable them manually from the app settings.',
      );
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );
    return currentPosition;
  }

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition kLake = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    bearing: 192.8334901395799,
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentLatLng == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: _currentLatLng!,
                  zoom: 14.4746,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('my_marker'),
                    position: _currentLatLng!,
                    infoWindow: InfoWindow(
                      title: 'My Marker',
                      snippet: 'O7 Services',
                    ),
                  ),
                  Marker(
                    markerId: MarkerId('my_marker2'),
                    position: LatLng(31.316033413710446, 75.59380360306046),
                    infoWindow: InfoWindow(
                      title: 'My Marker 2',
                      snippet: 'Jalandhar Bus Stand',
                    ),
                  ),
                  Marker(
                    markerId: MarkerId('my_marker3'),
                    position: LatLng(31.3549, 75.5906),
                    infoWindow: InfoWindow(
                      title: 'My Marker 3',
                      snippet: 'Jalandhar Railway Station',
                    ),
                  ),
                  Marker(
                    markerId: MarkerId('my_marker4'),
                    position: LatLng(31.631733008826675, 74.86041443599917),
                    infoWindow: InfoWindow(
                      title: 'My Marker 4',
                      snippet: 'Amritsar Railway Station',
                    ),
                  ),
                  Marker(
                    markerId: MarkerId('my_marker5'),
                    position: LatLng(31.6339973, 74.8722462),
                    infoWindow: InfoWindow(
                      title: 'My Marker 5',
                      snippet: 'Amritsar Bus Stand',
                    ),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }
}
