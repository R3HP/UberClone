import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line/core/constants.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/driver_controller.dart';

class FlutterMapConfigured extends ConsumerStatefulWidget {
  const FlutterMapConfigured({
    Key? key,
    required this.mapController,
    required this.startPosition,
    required this.currentPosition,
    // required this.cabController,
  }) : super(key: key);

  final MapController mapController;
  final latlong.LatLng startPosition;
  final latlong.LatLng currentPosition;
  // final CabController cabController;

  @override
  ConsumerState<FlutterMapConfigured> createState() => _FlutterMapConfiguredState();
}

class _FlutterMapConfiguredState extends ConsumerState<FlutterMapConfigured> {
  final DriverController driverController = sl();
  List<latlong.LatLng>? availableDriverLocations;
  String? errorMessage;
  bool _isFirst = true;
  late CabController cabController;

  @override
  void initState() {
    super.initState();
    driverController.getDriversLocation()
    .then((locations) {
      setState(() {
        availableDriverLocations = locations;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = error.toString();
      });
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      cabController = ref.watch(cabControllerProvider);
      _isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return errorMessage != null ?
    Center(child: Text(errorMessage!),) 
    : 
    FlutterMap(
        mapController: widget.mapController,
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/r3zahp/cl04yaeqh000a15l2i8zdxib7/tiles/256/{z}/{x}/{y}@2x?access_token=$Your_Primary_Key',
                additionalOptions: {
                  'accessToken':
                      Your_Primary_Key,
                  'id': 'mapbox.mapbox-streets-v8'
                }),
          ),
          StreamBuilder(
            stream: driverController.getDriversLocationStream(),
            initialData: availableDriverLocations ?? [],
            builder: (context, AsyncSnapshot<List<latlong.LatLng>> driversLocationSnapshot) {
              return MarkerLayerWidget(
                options: MarkerLayerOptions(markers: [
                  Marker(
                    point: widget.startPosition,
                    builder: (ctx) => Container(
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 0.8,
                        backgroundColor: Colors.blue.withOpacity(0.5),
                        child: const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  if (cabController.startTripPoint != null)
                    Marker(
                        point: cabController.startTripPoint!,
                        builder: (ctx) => const Icon(
                              Icons.start,
                              color: Colors.green,
                            )),
                  if (cabController.finishTripPoint != null)
                    Marker(
                      point: cabController.finishTripPoint!,
                      builder: (ctx) => const Icon(
                        Icons.flag,
                        color: Colors.green,
                      ),
                    ),
                  if (cabController.finishTripPoint == null)
                    Marker(
                      anchorPos: AnchorPos.align(AnchorAlign.top),
                      point: widget.currentPosition,
                      builder: (ctx) => Icon(cabController.startTripAddress == null
                          ? Icons.location_on
                          : Icons.edit_location),
                    ),
                    ...driversLocationSnapshot.data!.map((location) => Marker(point: location, builder: (ctx) => Image.asset('assets/images/car_android.png' , ))).toList()
                ]),
              );
            }
          ),
          if (cabController.direction != null)
            PolylineLayerWidget(
              options: PolylineLayerOptions(
                  polylineCulling: true,
                  polylines: cabController.direction!.routes
                      .map((route) => Polyline(
                          color: cabController.direction!.routes.first == route
                              ? Colors.deepOrangeAccent
                              : Colors.cyan,
                          borderColor:
                              cabController.direction!.routes.first == route
                                  ? Colors.deepOrange
                                  : Colors.cyanAccent,
                          strokeWidth: 5,
                          colorsStop: [
                            Colors.greenAccent.value.toDouble(),
                            Colors.amber.value.toDouble()
                          ],
                          points: route.geometryCordinates))
                      .toList()),
            ),
        ],
        options: MapOptions(
          onTap: (tapPosition, point) =>
              FocusManager.instance.primaryFocus!.unfocus(),
          controller: widget.mapController,
          maxZoom: 18.4,
          zoom: 18.4,
          center: widget.startPosition,
        ));
  }
}