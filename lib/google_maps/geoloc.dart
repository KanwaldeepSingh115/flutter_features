import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocApp extends StatefulWidget {
  const GeoLocApp({super.key});

  @override
  State<GeoLocApp> createState() => _GeoLocAppState();
}

class _GeoLocAppState extends State<GeoLocApp> {
  String _locationMessage = "Fetching location...";

  @override
  void initState() {
    super.initState();
    // Call _getLocation when the widget is initialized.
    _getLocation();
  }

  // Asynchronous function to get the current location.
  void _getLocation() async {
    try {
      // storing the result of _determinePosition in Position type variable

      Position position = await _determinePosition();
      if (mounted) {
        // Update the UI with the fetched location using setState.
        setState(() {
          _locationMessage =
              "Latitude: ${position.latitude}, Longitude: ${position.longitude} ";
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

  Future<Position> _determinePosition() async {
    // variables
    bool serviceEnabled;
    LocationPermission permission;

    // isLocationServiceEnabled gives us boolean value
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // To show future error if location service is not enabled
    if (!serviceEnabled) {
      // If services are disabled, return an error Future with an informative message.
      return Future.error(
        "Location services are disabled. Please enable them in your device settings.",
      );
    }

    // checkPermission is used to check whether the permission is enabled or not
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // requesting permission
      permission = await Geolocator.requestPermission();

      // this nested else check if the user denied the permission after requesting permission
      if (permission == LocationPermission.denied) {
        return Future.error(
          "Location permissions are denied. Please grant them for this app to function.",
        );
      }
    }

    // Handling the case where permissions are permanently denied.
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied. We cannot request permissions. You will need to enable them manually from the app settings.',
      );
    }

    // If all checks pass and permissions are granted, getting the current position
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.high, // Use high accuracy for better results.
      timeLimit: const Duration(
        seconds: 10,
      ), // Set a timeout for the location request.
    );

    // Return the fetched Position object.
    return currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the location message or error.
              Text(
                _locationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 30), // Add some spacing.
              // Button to allow the user to manually re-fetch location.
              ElevatedButton.icon(
                onPressed: () {
                  // Reset message and re-trigger location fetching.
                  setState(() {
                    _locationMessage = "Fetching location...";
                  });
                  _getLocation();
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                  "Refresh Location",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      Colors.blueAccent, // Button background color.
                  foregroundColor: Colors.white, // Text color.
                ),
              ),
              const SizedBox(height: 20),
              // Optional: Add some instructions for the user.
              const Text(
                "Make sure location services are enabled and permissions are granted for this app.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
