// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../providers/location_provider.dart';

// class LocationSelector extends ConsumerWidget {
//   const LocationSelector({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(locationProvider);
//     final notifier = ref.read(locationProvider.notifier);

//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: state.latLng,
//             zoom: 14,
//           ),
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//           onCameraMove: (position) {
//             notifier.updateLatLng(position.target);
//           },
//           onCameraIdle: () {
//             notifier.fetchAddress();
//           },
//         ),

//         /// Fixed center pin
//         const Center(
//           child: Icon(
//             Icons.location_pin,
//             color: Colors.red,
//             size: 45,
//           ),
//         ),
//       ],
//     );
//   }
// }

