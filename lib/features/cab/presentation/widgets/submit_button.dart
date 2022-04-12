import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';
import 'package:taxi_line/features/cab/presentation/widgets/bottom_controll_pad.dart';

import '../controllers/geo_code_controller.dart';

// final cabControllerProvider = ChangeNotifierProvider(
//   (ref) => CabController(),
// );

class SubmitButton extends ConsumerWidget {
  // final Size size;
  final MapController mapController;
  final LatLng mapCurrrentPoint;
  // final VoidCallback onPressed;

  const SubmitButton({
    Key? key,
    required this.mapController,
    required this.mapCurrrentPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabController = ref.watch(cabControllerProvider);
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: size.height * 0.02,
      left: 2,
      right: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(size.width * 0.75, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            onPressed: () async {
              final GeoCodeController geoController = sl();
              final address = await geoController.geoCodeLatnLngToAddress(
                  mapCurrrentPoint.latitude, mapCurrrentPoint.longitude);
              if (cabController.startTripAddress == null) {
                print('address : $address');
                cabController.startTripAddress = address;

                print(cabController.startTripAddress);
              } else {
                cabController.finishTripAddress = address;
                final centerZoom = mapController.centerZoomFitBounds(
                  LatLngBounds(cabController.startTripPoint,
                      cabController.finishTripPoint),
                );
                cabController.getDirectionForPoints();
                mapController.move(mapCurrrentPoint, 18.4);
                mapController.move(centerZoom.center, centerZoom.zoom);
                // showModalBottomSheet(
                //     context: context,
                //     builder: (ctx) => const BottomControllPad());
              }
            },
            child: const Text('Submit')),
      ),
    );
  }

  // () async {
  //                             if (ref.read(cabController).startTripAddress ==
  //                                 null) {
  //                               final tripStartPoint =
  //                                   mapEventSnapshot.data!.center;
  //                               final address =
  //                                   await geoController.geoCodeLatnLngToAddress(
  //                                       tripStartPoint.latitude,
  //                                       tripStartPoint.longitude);
  //                               // _startAddressTextFielController.text =
  //                               //     address.placeAddress;
  //                               ref.read(cabController).startTripAddress =
  //                                   address;
  //                               // setState(() {});
  //                             } else {
  //                               final tripFinishPoint =
  //                                   mapEventSnapshot.data!.center;
  //                               final address =
  //                                   await geoController.geoCodeLatnLngToAddress(
  //                                       tripFinishPoint.latitude,
  //                                       tripFinishPoint.longitude);
  //                               // _finishAddressTextFielController.text =
  //                               //     address.placeAddress;
  //                               // setState(() {});
  //                               ref.read(cabController).finishTripAddress =
  //                                   address;
  //                               final centerZoom = _mapController
  //                                   .centerZoomFitBounds(LatLngBounds(
  //                                       ref.read(cabController).startTripPoint,
  //                                       ref
  //                                           .read(cabController)
  //                                           .finishTripPoint));
  //                               _mapController.move(
  //                                   centerZoom.center, centerZoom.zoom);
  //                               showModalBottomSheet(
  //                                   context: context,
  //                                   builder: (ctx) =>
  //                                       const BottomControllPad());
  //                             }
  //                           },
}
