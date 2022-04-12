import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';

class GpsIcon extends ConsumerWidget {
  final LatLng userLocation;
  final bool shouldGoUp;
  final MapController mapController;
  const GpsIcon({
    Key? key,
    required this.userLocation,
    required this.shouldGoUp,
    required this.mapController,
  })  : super(key: key);


  @override
  Widget build(BuildContext context,WidgetRef ref) {
  final Size size = MediaQuery.of(context).size;
  final cabController = ref.read(cabControllerProvider);
    return Positioned(
      bottom: shouldGoUp == false
          ? size.height * 0.17 + 20
          : size.height * 0.27 + 20,
      right: 20,
      child: Card(
        elevation: 12,
        color: Colors.grey[350],
        shape: const CircleBorder(
            side: BorderSide(width: 1, color: Colors.transparent)),
        child: IconButton(
          onPressed: () {
            final x = mapController.move(userLocation, 18.4,id: 'gps');
            print('x : $x');
          },
          icon: const Icon(
            Icons.gps_fixed_sharp,
          ),
        ),
      ),
    );
  }
}
