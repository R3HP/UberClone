import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';


class StartTextField extends ConsumerWidget {
  const StartTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabController = ref.watch(cabControllerProvider);
    final _startAddressTextFielController = TextEditingController(
        text: cabController.startTripAddress?.placeAddress);
    final LatLng? tripStartPoint = cabController.startTripPoint;
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      bottom: tripStartPoint == null ? size.height * 0.12 : size.height * 0.22,
      right: 2,
      left: 2,
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              offset: Offset(2, 2),
              color: Colors.black38,
              blurRadius: 10.0,
              blurStyle: BlurStyle.outer),
        ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        padding: const EdgeInsets.all(1.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: _startAddressTextFielController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(5.0),
            hintText: 'Start Address',
          ),
        ),
      ),
    );
  }
}
