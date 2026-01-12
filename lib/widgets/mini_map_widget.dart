import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniMap extends StatefulWidget {
  final LatLng latLng;

  const MiniMap({super.key, required this.latLng});

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  final Completer<GoogleMapController> _miniMapController = Completer();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 120,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.latLng,
            zoom: 16,
          ),
          markers: {
            Marker(markerId: const MarkerId('mini'), position: widget.latLng),
          },
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          liteModeEnabled: true,
          onMapCreated: (controller) {
            _miniMapController.complete(controller);
          },
        ),
      ),
    );
  }
}
