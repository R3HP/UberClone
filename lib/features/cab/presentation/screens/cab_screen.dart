import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:location/location.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/presentation/controllers/geo_code_controller.dart';

class CabScreen extends StatefulWidget {
  static const routeName = '/cab_screen';

  const CabScreen({Key? key}) : super(key: key);

  @override
  State<CabScreen> createState() => _CabScreenState();
}

class _CabScreenState extends State<CabScreen> {
  late final MapController _mapController;
  latlong.LatLng? tripStartPoint;
  latlong.LatLng? tripFinishPoint;
  final _startAddressTextFielController = TextEditingController();
  final _finishAddressTextFielController = TextEditingController();
  final _searchTextFieldController = TextEditingController();
  final _searchTextFieldFocusNode = FocusNode();
  final GeoCodeController geoController = sl();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapController.mapEventStream.listen((event) {
      print('map event');
      print(event.center);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: Location.instance.onLocationChanged,
        builder: (ctx, AsyncSnapshot<LocationData> locationSnapShot) {
          if (locationSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (locationSnapShot.hasError) {
              return Center(
                child: Text(locationSnapShot.error.toString()),
              );
            } else {
              final startPosition = latlong.LatLng(
                  locationSnapShot.data!.latitude!,
                  locationSnapShot.data!.longitude!);
              return StreamBuilder(
                  stream: _mapController.mapEventStream,
                  initialData: MapEventMove(
                      targetCenter: startPosition,
                      targetZoom: 18.4,
                      source: MapEventSource.initialization,
                      center: startPosition,
                      zoom: 18.4),
                  builder: (context, AsyncSnapshot<MapEvent> mapEventSnapshot) {
                    return Stack(
                      children: [
                        FlutterMap(
                            mapController: _mapController,
                            layers: [
                              TileLayerOptions(
                                  urlTemplate:
                                      'https://api.mapbox.com/styles/v1/r3zahp/cl04yaeqh000a15l2i8zdxib7/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg',
                                  additionalOptions: {
                                    'accessToken':
                                        'pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg',
                                    'id': 'mapbox.mapbox-streets-v8'
                                  }),
                              MarkerLayerOptions(markers: [
                                Marker(
                                  point: startPosition,
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
                                if (tripStartPoint != null)
                                  Marker(
                                      point: tripStartPoint!,
                                      builder: (ctx) => const Icon(
                                            Icons.flag,
                                            color: Colors.green,
                                          )),
                                if (tripFinishPoint != null)
                                  Marker(
                                      point: tripFinishPoint!,
                                      builder: (ctx) => const Icon(
                                            Icons.flag,
                                            color: Colors.green,
                                          )),
                                if (mapEventSnapshot.hasData &&
                                    tripFinishPoint == null)
                                  Marker(
                                      point: mapEventSnapshot.data!.center,
                                      builder: (ctx) => Container(
                                            child: Icon(tripStartPoint == null
                                                ? Icons.location_on
                                                : Icons.edit_location),
                                          ))
                              ]),
                            ],
                            options: MapOptions(
                              controller: _mapController,
                              // onPositionChanged: (position, hasGesture) {
                              //   // print(position.center);
                              //   // startPosition = position.center!;
                              //   // print(position.hasGesture);
                              //   // setState(() {});
                              //   // print(hasGesture);
                              // },
                              maxZoom: 18.4,
                              zoom: 18.4,
                              center: startPosition,
                            )),
                        Positioned(
                          bottom: tripStartPoint == null
                              ? size.height * 0.17 + 20
                              : size.height * 0.27 + 20,
                          right: 20,
                          child: Card(
                            elevation: 12,
                            color: Colors.grey[350],
                            shape: const CircleBorder(
                                side: BorderSide(
                                    width: 1, color: Colors.transparent)),
                            child: IconButton(
                              onPressed: () {
                                _mapController.move(
                                    latlong.LatLng(
                                        locationSnapShot.data!.latitude!,
                                        locationSnapShot.data!.longitude!),
                                    18.4);
                              },
                              icon: const Icon(
                                Icons.gps_fixed_sharp,
                              ),
                            ),
                          ),
                        ),
                        if (tripFinishPoint == null)
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 20),
                            curve: Curves.ease,
                            padding: EdgeInsets.only(
                                top: 35.0,
                                left: _searchTextFieldFocusNode.hasFocus
                                    ? size.width / 12
                                    : size.width / 6.8,
                                right: _searchTextFieldFocusNode.hasFocus
                                    ? size.width / 13
                                    : 0),
                            child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    focusNode: _searchTextFieldFocusNode,
                                    controller: _searchTextFieldController,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (value) async {
                                      final addresses = await geoController
                                          .geoCodeAddressToLatLng(value);
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                                alignment: Alignment.center,
                                                elevation: 16,
                                                child: ListView.builder(
                                                  itemCount: addresses.length,
                                                  itemBuilder: (ctx, index) =>
                                                      ListTile(
                                                    title: Text(
                                                      addresses[index]
                                                          .placeAddress,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    onTap: () {
                                                      if (tripStartPoint ==
                                                          null) {
                                                        tripStartPoint =
                                                            latlong.LatLng(
                                                                addresses[index]
                                                                    .latitude,
                                                                addresses[index]
                                                                    .latitude);
                                                        _startAddressTextFielController
                                                                .text =
                                                            addresses[index]
                                                                .placeText;
                                                      } else {
                                                        tripFinishPoint =
                                                            latlong.LatLng(
                                                                addresses[index]
                                                                    .latitude,
                                                                addresses[index]
                                                                    .latitude);
                                                        _finishAddressTextFielController
                                                                .text =
                                                            addresses[index]
                                                                .placeText;
                                                      }
                                                      // location and text controller should be set Here
                                                      // a way of finding if its starting poin or finishing point
                                                    },
                                                  ),
                                                ),
                                              ));
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      label: Row(children: const [
                                        Icon(Icons.search),
                                        Text('Search')
                                      ]),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      constraints: BoxConstraints(
                                          maxHeight: 50,
                                          maxWidth: size.width * 0.7),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  if (_searchTextFieldFocusNode.hasFocus)
                                    IconButton(
                                      onPressed: () async {
                                        final addresses = await geoController
                                            .geoCodeAddressToLatLng(
                                                _searchTextFieldController
                                                    .text);
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => Dialog(
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  child: ListView.builder(
                                                    itemCount: addresses.length,
                                                    itemBuilder: (ctx, index) =>
                                                        ListTile(
                                                      title: Text(
                                                        addresses[index]
                                                            .placeAddress,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        if (tripStartPoint ==
                                                            null) {
                                                          tripStartPoint =
                                                              latlong.LatLng(
                                                                  addresses[
                                                                          index]
                                                                      .latitude,
                                                                  addresses[
                                                                          index]
                                                                      .latitude);
                                                          _startAddressTextFielController
                                                                  .text =
                                                              addresses[index]
                                                                  .placeText;
                                                        } else {
                                                          tripFinishPoint =
                                                              latlong.LatLng(
                                                                  addresses[
                                                                          index]
                                                                      .latitude,
                                                                  addresses[
                                                                          index]
                                                                      .latitude);
                                                          _finishAddressTextFielController
                                                                  .text =
                                                              addresses[index]
                                                                  .placeText;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ));
                                      },
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: tripStartPoint == null
                              ? size.height * 0.12
                              : size.height * 0.22,
                          right: 2,
                          left: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      color: Colors.black38,
                                      blurRadius: 10.0,
                                      blurStyle: BlurStyle.outer),
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white),
                            padding: const EdgeInsets.all(1.0),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              controller: _startAddressTextFielController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(5.0),
                                hintText: 'Start Address',
                              ),
                            ),
                          ),
                        ),
                        if (tripStartPoint != null)
                          Positioned(
                            bottom: size.height * 0.12,
                            right: 2,
                            left: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(2, 2),
                                        color: Colors.black38,
                                        blurRadius: 10.0,
                                        blurStyle: BlurStyle.outer),
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.white),
                              padding: const EdgeInsets.all(1.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: _finishAddressTextFielController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText: 'Finish Address',
                                ),
                              ),
                            ),
                          ),
                        if (!_searchTextFieldFocusNode.hasFocus)
                          Positioned(
                            bottom: size.height * 0.02,
                            left: 2,
                            right: 2,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(size.width * 0.75, 60),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  onPressed: () async {
                                    if (tripStartPoint == null) {
                                      
                                        tripStartPoint =
                                            mapEventSnapshot.data!.center;
                                      final address = await geoController
                                          .geoCodeLatnLngToAddress(
                                              tripStartPoint!.latitude,
                                              tripStartPoint!.longitude);
                                        _startAddressTextFielController.text =
                                            address.placeAddress;
                                      setState(() {});
                                    } else {
                                      
                                        tripFinishPoint =
                                            mapEventSnapshot.data!.center;
                                      final address = await geoController
                                          .geoCodeLatnLngToAddress(
                                              tripStartPoint!.latitude,
                                              tripStartPoint!.longitude);
                                        _finishAddressTextFielController.text =
                                            address.placeAddress;
                                      setState(() {});
                                      
                                      final centerZoom = _mapController.centerZoomFitBounds(
                                          LatLngBounds(
                                              tripStartPoint, tripFinishPoint));
                                              _mapController.move(centerZoom.center, centerZoom.zoom);
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (ctx) =>
                                              BottomControllPad(size: size));
                                    }
                                  },
                                  child: const Text('Submit')),
                            ),
                          )
                        // BottomControllPad(size: size),
                      ],
                    );
                  });
            }
          }
        },
      ),
    );
  }
}

class BottomControllPad extends StatelessWidget {
  const BottomControllPad({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            color: Colors.brown),
        height: size.height * 0.3,
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      borderOnForeground: true,
                      elevation: 12,
                      color: Colors.grey.shade200.withOpacity(0.6),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/uber.jpg',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const Text('standard')
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                      borderOnForeground: true,
                      elevation: 12,
                      color: Colors.grey.shade200.withOpacity(0.6),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/uber_plus.jpg',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const Text('standard')
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                      borderOnForeground: true,
                      elevation: 12,
                      color: Colors.grey.shade200.withOpacity(0.6),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/van.jpg',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const Text('standard')
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('CAB'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size(size.width * 0.8, 60),
              ),
            )
          ],
        ),
      ),
    );
  }
}
