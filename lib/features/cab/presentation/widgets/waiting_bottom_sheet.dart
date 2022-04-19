import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lottie;

import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';

class WaitingBottomSheet extends StatelessWidget {
  final Trip trip;
  final TripController tripController = sl();

  WaitingBottomSheet({
    Key? key,
    required this.trip,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomSheet(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      constraints: BoxConstraints(minHeight: size.height, minWidth: size.width),
      enableDrag: false,
      onClosing: () {},
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lottie.LottieBuilder.asset(determineRandomAnimation(),
                height: 350, repeat: true),
            const Text('Our Drivers Are Coming To Get You ASAP'),
            CircleAvatar(
              child: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    tripController
                        .deleteTripRequestFromDataBase(trip.id!)
                        .then((value) => Navigator.of(context).pop());
                  }),
            ),
            const Text('Cancel'),
            ElevatedButton(
                onPressed: () {
                  tripController.updateTripInDataBase(trip,
                      price: trip.price + 3);
                },
                child: const Text('In A Hurry ? Add a 3\$ tip'))
          ],
        ),
      ),
    );
  }

  String determineRandomAnimation() {
    final randomNumber = Random().nextInt(3);
    switch (randomNumber) {
      case 0:
        return 'assets/animations/cab_booking.json';
      case 1:
        return 'assets/animations/man_waiting.json';
      case 2:
        return 'assets/animations/marker_map.json';
      default:
        return 'assets/animations/cab_booking.json';
    }
  }
}
