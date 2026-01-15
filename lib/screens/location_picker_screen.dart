import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng _currentLatLng = const LatLng(11.6693, 105.0670);

  // ---------------- CURRENT LOCATION ----------------
  Future<void> moveToCurrentLocation() async {
    await Geolocator.requestPermission();
    final position = await Geolocator.getCurrentPosition();

    _currentLatLng = LatLng(position.latitude, position.longitude);

    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng, 16));

    setState(() {});
  }

  // ---------------- MAP MOVE ----------------
  void _onCameraMove(CameraPosition position) {
    _currentLatLng = position.target;
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text('Select Location'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              'CONFIRM',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🗺️ MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLatLng,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            onCameraMove: _onCameraMove,
          ),

          // 📍 CENTER PIN
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Icon(Icons.location_pin, size: 50, color: Colors.red),
            ),
          ),

          // 🔍 SEARCH BAR
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search for an address...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ),

          // ⬇️ BOTTOM CARD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_currentLatLng.latitude.toStringAsFixed(5)}, '
                          '${_currentLatLng.longitude.toStringAsFixed(5)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: moveToCurrentLocation,
                          icon: const Icon(Icons.my_location),
                          label: const Text('Current Location'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // CONFIRM LOCATION
                            // ignore: avoid_print
                            print(_currentLatLng);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Confirm Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
