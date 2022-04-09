import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';
import 'package:taxi_line/features/cab/presentation/widgets/bottom_controll_pad.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line/features/cab/presentation/widgets/cancel_button.dart';
import 'package:taxi_line/features/cab/presentation/widgets/finish_address_text_field.dart';
import 'package:taxi_line/features/cab/presentation/widgets/gps_icon.dart';
import 'package:taxi_line/features/cab/presentation/widgets/search_bar.dart';
import 'package:taxi_line/features/cab/presentation/widgets/start_address_text_field.dart';
import 'package:taxi_line/features/cab/presentation/widgets/submit_button.dart';

class SelectableMap extends ConsumerStatefulWidget {
  SelectableMap({
    Key? key,
    required MapController mapController,
    required this.startPosition,
    // required this.cabController,
  }) : _mapController = mapController, super(key: key);

  final MapController _mapController;
  final latlong.LatLng startPosition;
  // final CabController cabController;

  @override
  ConsumerState<SelectableMap> createState() => _SelectableMapState();
}

class _SelectableMapState extends ConsumerState<SelectableMap> {
  final searchTextFieldFocusNode = FocusNode();
  bool _isFirst = true;

  late final CabController cabController ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchTextFieldFocusNode.addListener(() {
      setState(() {
        
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      cabController = ref.watch(cabControllerProvider);
      _isFirst =false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._mapController.mapEventStream,
        initialData: MapEventMove(
            targetCenter: widget.startPosition,
            targetZoom: 18.4,
            source: MapEventSource.initialization,
            center: widget.startPosition,
            zoom: 18.4),
        builder: (context, AsyncSnapshot<MapEvent> mapEventSnapshot) {
          print('map event snapshot ' +
              mapEventSnapshot.data!.center.toString());
          print('startTripPoint');
          print(cabController.startTripPoint);
          return Stack(
            children: [
              FlutterMap(
                  mapController: widget._mapController,
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
                    MarkerLayerWidget(
                      options: MarkerLayerOptions(markers: [
                        Marker(
                          point: widget.startPosition,
                          builder: (ctx) => Container(
                            padding: const EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 0.8,
                              backgroundColor:
                                  Colors.blue.withOpacity(0.5),
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
                        if (cabController.finishTripAddress == null)
                          Marker(
                            anchorPos:
                                AnchorPos.align(AnchorAlign.top),
                            point: mapEventSnapshot.data!.center,
                            builder: (ctx) => Icon(
                                cabController.startTripAddress == null
                                    ? Icons.location_on
                                    : Icons.edit_location),
                          )
                      ]),
                    ),
                    if (cabController.direction != null)
                      PolylineLayerWidget(
                        options: PolylineLayerOptions(
                            polylineCulling: true,
                            polylines: cabController.direction!.routes
                                .map((route) => Polyline(
                                    color: cabController.direction!
                                                .routes.first ==
                                            route
                                        ? Colors.deepOrangeAccent
                                        : Colors.cyan,
                                    borderColor: cabController
                                                .direction!
                                                .routes
                                                .first ==
                                            route
                                        ? Colors.deepOrange
                                        : Colors.cyanAccent,
                                    strokeWidth: 5,
                                    colorsStop: [
                                      Colors.greenAccent.value
                                          .toDouble(),
                                      Colors.amber.value.toDouble()
                                    ],
                                    points: route.geometryCordinates))
                                .toList()),
                      ),
                  ],
                  options: MapOptions(
                    controller: widget._mapController,
                    maxZoom: 18.4,
                    zoom: 18.4,
                    center: widget.startPosition,
                  )),
              GpsIcon(
                userLocation: widget.startPosition,
                  // userLocation: latlong.LatLng(
                  //     locationSnapShot.data!.latitude!,
                  //     locationSnapShot.data!.longitude!),
                  shouldGoUp: cabController.startTripAddress != null,
                  mapController: widget._mapController),
              if (cabController.finishTripAddress == null)
                SearchBar(
                    searchTextFieldFocusNode:
                        searchTextFieldFocusNode
                        ),
              if (cabController.startTripPoint != null)
                const CancelButton(),
              const StartTextField(),
              if (cabController.startTripAddress != null)
                FinishTextField(
                    text: cabController
                        .finishTripAddress?.placeAddress),
              // const FinishTextField(),
              if (!searchTextFieldFocusNode.hasFocus)
                SubmitButton(
                  mapController: widget._mapController,
                  mapCurrrentPoint: mapEventSnapshot.data!.center,
                ),
              if (cabController.direction != null)
                const BottomControllPad(),
            ],
          );
        });
  }
}

