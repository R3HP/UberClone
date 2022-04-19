import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line/core/constants.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/driver_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';
import 'package:taxi_line/features/cab/presentation/widgets/driver_info_container.dart';

class TripAcceptedBottomSheet extends StatelessWidget {
  const TripAcceptedBottomSheet({Key? key, required this.trip})
      : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final DriverController driverController = sl();
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.16),
          child: FutureBuilder(
            future: driverController.getTripDriverLocation(trip.driverId!),
            builder: (ctx, AsyncSnapshot<latlong.LatLng> initialLatLng) {
              if (initialLatLng.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                print(trip.route.geometryCordinates);
                return FlutterMap(
                  options: MapOptions(
                    center: latlong.LatLng(trip.wayPoints.first.latitude,
                        trip.wayPoints.first.longitude),
                    maxZoom: 18.4,
                    zoom: 18.4,
                    onMapCreated: (mapController) {
                      final centerZoom = mapController.centerZoomFitBounds(
                          LatLngBounds.fromPoints(trip.wayPoints
                              .map((wayPoint) => latlong.LatLng(
                                  wayPoint.latitude, wayPoint.longitude))
                              .toList()));
                      mapController.onReady.then((value) =>
                          mapController.move(centerZoom.center, 17));
                    },
                  ),
                  children: [
                    TileLayerWidget(
                      options: TileLayerOptions(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/r3zahp/cl04yaeqh000a15l2i8zdxib7/tiles/256/{z}/{x}/{y}@2x?access_token=$Your_Primary_Key',
                          additionalOptions: {
                            'accessToken': Your_Primary_Key,
                            'id': 'mapbox.mapbox-streets-v8'
                          }),
                    ),
                    StreamBuilder(
                      stream: driverController
                          .getTripDriverLocationStream(trip.driverId!),
                      initialData: initialLatLng.data,
                      builder: (ctx,
                              AsyncSnapshot<latlong.LatLng> streamSnapShot) =>
                          streamSnapShot.connectionState ==
                                  ConnectionState.waiting
                              ? Container()
                              : MarkerLayerWidget(
                                  options: MarkerLayerOptions(markers: [
                                    Marker(
                                        point: streamSnapShot.data!,
                                        builder: (ctx) => Image.asset(
                                            'assets/images/car_android.png')),
                                    ...trip.wayPoints.map<Marker>(
                                        (wayPoint) => Marker(
                                            point: latlong.LatLng(
                                                wayPoint.latitude,
                                                wayPoint.longitude),
                                            builder: (ctx) => const Icon(
                                                  Icons.location_on,
                                                  color: Colors.green,
                                                )))
                                  ]),
                                ),
                    ),
                    PolylineLayerWidget(
                      options: PolylineLayerOptions(
                          polylineCulling: true,
                          polylines: [
                            Polyline(
                                borderStrokeWidth: 2,
                                borderColor: Colors.blue,
                                colorsStop: [
                                  Colors.deepOrange.value.toDouble(),
                                  Colors.deepOrangeAccent.value.toDouble(),
                                ],
                                points: trip.route.geometryCordinates,
                                color: Colors.red,
                                strokeWidth: 5)
                          ]),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        DriverInfoContainer(trip: trip)
      ],
    );
  }
}
