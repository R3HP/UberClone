import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';
import 'package:taxi_line/features/cab/presentation/widgets/waiting_bottom_sheet.dart';

class BottomControllPad extends ConsumerStatefulWidget {
  const BottomControllPad({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomControllPad> createState() => _BottomControllPadState();
}

class _BottomControllPadState extends ConsumerState<BottomControllPad> {
  late final TripController tripController;
  TripCategory tripCategory = TripCategory.Regualar;

  @override
  void initState() {
    super.initState();
    tripController = sl();
  }

  @override
  Widget build(BuildContext context) {
    final cabController = ref.read(cabControllerProvider);
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeIn,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: Colors.blueGrey.shade200,
            // color: Colors.brown
          ),
          height: size.height * 0.37,
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  shape: tripCategory == TripCategory.Regualar
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.blue, width: 5),
                        )
                      : null,
                  leading: Image.asset('assets/images/uber.jpg'),
                  title: const Text('Uber'),
                  subtitle: Text(cabController
                          .direction!.routes.first.distanceAsKM
                          .toStringAsFixed(2) +
                      'KM' +
                      cabController.direction!.routes.first.durationAs
                          .toString()),
                  trailing: Text('\$' +
                      cabController.direction!.routes.first
                          .calculateRegularPrice()
                          .toStringAsFixed(2)),
                  onTap: () {
                    if (tripCategory != TripCategory.Regualar) {
                      setState(() {
                        tripCategory = TripCategory.Regualar;
                      });
                    }
                  }),
              ListTile(
                shape: tripCategory == TripCategory.Plus
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                      )
                    : null,
                leading: Image.asset('assets/images/uber_plus.jpg'),
                title: const Text('UberPlus'),
                subtitle: Text(cabController
                        .direction!.routes.first.distanceAsKM
                        .toStringAsFixed(2) +
                    'KM' +
                    cabController.direction!.routes.first.durationAs
                        .toString()),
                trailing: Text('\$' +
                    cabController.direction!.routes.first
                        .calculatePlusUerPrice()
                        .toStringAsFixed(2)),
                onTap: () {
                  if (tripCategory != TripCategory.Plus) {
                    setState(() {
                      tripCategory = TripCategory.Plus;
                    });
                  }
                },
              ),
              ListTile(
                shape: tripCategory == TripCategory.Van
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                      )
                    : null,
                leading: Image.asset('assets/images/van.jpg'),
                title: const Text('UberVan'),
                subtitle: Text(cabController
                        .direction!.routes.first.distanceAsKM
                        .toStringAsFixed(2) +
                    'KM' +
                    cabController.direction!.routes.first.durationAs
                        .toString()),
                trailing: Text('\$' +
                    cabController.direction!.routes.first
                        .calculateVanUberPirce()
                        .toStringAsFixed(2)),
                onTap: () {
                  if (tripCategory != TripCategory.Van) {
                    setState(() {
                      tripCategory = TripCategory.Van;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final newTrip =
                      await tripController.postTripRequestToDataBase(
                          cabController.direction!, 0, tripCategory);
                  showBottomSheet(
                      context: context,
                      builder: (ctx) => WaitingBottomSheet(
                            trip: newTrip,
                          ));
                },
                child: const Text('Get A Cab'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(size.width * 0.9, 50)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

