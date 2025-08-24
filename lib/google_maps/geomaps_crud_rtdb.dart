import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class GeoMapsListCrud extends StatefulWidget {
  const GeoMapsListCrud({super.key});

  @override
  State<GeoMapsListCrud> createState() => _GeoMapsListCrudState();
}

class _GeoMapsListCrudState extends State<GeoMapsListCrud> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng? _currentLatLng;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("mapLocations");

  Map<String, dynamic> savedLocations = {};

  @override
  void initState() {
    super.initState();
    _getLocation();

    dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          savedLocations = Map<String, dynamic>.from(
            event.snapshot.value as Map,
          );
        });
      } else {
        setState(() {
          savedLocations.clear();
        });
      }
    });
  }

  void _getLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied forever");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _saveLocation() async {
    if (_currentLatLng == null) return;

    TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save Location"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter place name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, nameController.text.trim());
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    ).then((enteredName) async {
      if (enteredName != null && enteredName.isNotEmpty) {
        final newRef = dbRef.push();
        await newRef.set({
          "title": enteredName,
          "lat": _currentLatLng!.latitude,
          "lng": _currentLatLng!.longitude,
        });
      }
    });
  }

  void _editLocation(String key, String oldTitle) {
    TextEditingController titleC = TextEditingController(text: oldTitle);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Place Name"),
            content: TextField(
              controller: titleC,
              decoration: const InputDecoration(hintText: "Enter new title"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  dbRef.child(key).update({"title": titleC.text});
                  setState(() {
                    savedLocations[key]["title"] = titleC.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  Future<void> _goToLocation(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    if (_currentLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("me"),
          position: _currentLatLng!,
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    }
    savedLocations.forEach((key, value) {
      markers.add(
        Marker(
          markerId: MarkerId(key),
          position: LatLng(value["lat"], value["lng"]),
          infoWindow: InfoWindow(title: value["title"] ?? "Place"),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Geo Maps with DB (CRUD)")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child:
                _currentLatLng == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: CameraPosition(
                        target: _currentLatLng!,
                        zoom: 14,
                      ),
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
          ),

          Expanded(
            flex: 1,
            child:
                savedLocations.isEmpty
                    ? const Center(child: Text("No saved places"))
                    : ListView(
                      children:
                          savedLocations.entries.map((entry) {
                            final key = entry.key;
                            final value = Map<String, dynamic>.from(
                              entry.value,
                            );
                            return ListTile(
                              title: Text(value["title"] ?? "Place"),
                              subtitle: Text(
                                "Lat: ${value["lat"]}, Lng: ${value["lng"]}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      _editLocation(
                                        key,
                                        value["title"] ?? "Saved Place",
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      _goToLocation(
                                        LatLng(value["lat"], value["lng"]),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      dbRef.child(key).remove();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveLocation,
        label: const Text("Save my location"),
        icon: const Icon(Icons.add_location),
      ),
    );
  }
}
