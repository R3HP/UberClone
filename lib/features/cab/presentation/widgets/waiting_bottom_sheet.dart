import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:latlong2/latlong.dart' as latlong;

import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/presentation/controllers/driver_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';

class WaitingBottomSheet extends StatelessWidget {
  final Trip trip;
  final TripController tripController = sl();
  MapController? _mapController;

  WaitingBottomSheet({
    Key? key,
    required this.trip,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: tripController.getPendedTrip(trip),
        builder: (ctx, AsyncSnapshot<Trip> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              _mapController = MapController();
              final DriverController driverController = sl();

              return BottomSheet(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                constraints: BoxConstraints(
                    minHeight: size.height, minWidth: size.width),
                enableDrag: false,
                onClosing: () {},
                builder: (BuildContext context) => Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.15),
                      child: FutureBuilder(
                        future: driverController.getTripDriverLocation(trip.driverId!),
                        builder: (ctx,initial) =>
                         FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: latlong.LatLng(0, 0),
                            zoom: 18.4,
                            onMapCreated: (mapController) {
                              final centerZoom =
                                  mapController.centerZoomFitBounds(
                                      LatLngBounds.fromPoints(trip.wayPoints
                                          .map((wayPoint) => latlong.LatLng(
                                              wayPoint.latitude,
                                              wayPoint.longitude))
                                          .toList()));
                              mapController.onReady.then((value) => mapController
                                  .move(centerZoom.center, centerZoom.zoom));
                            },
                            controller: _mapController,
                          ),
                          children: [
                            TileLayerWidget(
                              options: TileLayerOptions(
                                  urlTemplate:
                                      'https://api.mapbox.com/styles/v1/r3zahp/cl04yaeqh000a15l2i8zdxib7/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg',
                                  additionalOptions: {
                                    'accessToken':
                                        'pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg',
                                    'id': 'mapbox.mapbox-streets-v8'
                                  }),
                            ),
                            StreamBuilder(
                              stream: driverController.getTripDriverLocationStream(trip.driverId!),
                              initialData: initial,
                              builder: (ctx,streamSnapShot) =>  MarkerLayerWidget(
                                options: MarkerLayerOptions(
                                    markers: snapshot.data!.wayPoints
                                        .map<Marker>((wayPoint) => Marker(
                                            point: latlong.LatLng(wayPoint.latitude,
                                                wayPoint.longitude),
                                            builder: (ctx) => const Icon(
                                                  Icons.location_on,
                                                  color: Colors.green,
                                                )))
                                        .toList()),
                              ),
                            ),
                            PolylineLayerWidget(
                              options: PolylineLayerOptions(polylines: [
                                Polyline(
                                    points: trip.route.geometryCordinates,
                                    color: Colors.blue,
                                    strokeWidth: 4)
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: size.height * 0.20,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: FutureBuilder(
                            future: driverController
                                .getDriverDetails(trip.driverId!),
                            builder:
                                (ctx, AsyncSnapshot<Driver> driverSnapshot) {
                              if (driverSnapshot.hasData) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Image.network(
                                        driverSnapshot.data!.profilePictureUrl),
                                  ),
                                  title: Text(driverSnapshot.data!.userName),
                                  subtitle: Text(driverSnapshot.data!.carModel +
                                      ': ' +
                                      driverSnapshot.data!.plateNumber),
                                );
                              }else{
                                if (driverSnapshot.hasError) {
                                  return Center(child: Text(driverSnapshot.error.toString()),);
                                } else {
                                  return Center(child: CircularProgressIndicator.adaptive(),);
                                }
                              }
                            }),
                      ),
                    )
                  ],
                ),
              );
            }
          } else {
            return BottomSheet(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                constraints: BoxConstraints(
                    minHeight: size.height, minWidth: size.width),
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
                              repeat: true),
                          const Text('Our Drivers Are Coming To Get You ASAP'),
                          CircleAvatar(
                            child: IconButton(
                                icon: const Icon(Icons.cancel_outlined),
                                onPressed: () {
                                  tripController
                                      .deleteTripRequestFromDataBase(trip.id!)
                                      .then((value) =>
                                          Navigator.of(context).pop());
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
                    ));
          }
        });
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
