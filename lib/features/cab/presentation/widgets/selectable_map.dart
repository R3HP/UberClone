import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/widgets/bottom_controll_pad.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line/features/cab/presentation/widgets/cancel_button.dart';
import 'package:taxi_line/features/cab/presentation/widgets/configured_flutter_map.dart';
import 'package:taxi_line/features/cab/presentation/widgets/finish_address_text_field.dart';
import 'package:taxi_line/features/cab/presentation/widgets/gps_icon.dart';
import 'package:taxi_line/features/cab/presentation/widgets/search_bar.dart';
import 'package:taxi_line/features/cab/presentation/widgets/start_address_text_field.dart';
import 'package:taxi_line/features/cab/presentation/widgets/submit_button.dart';

class SelectableMap extends StatefulWidget {
  const SelectableMap({
    Key? key,
    required this.userLocation,
  }) : super(key: key);

  final latlong.LatLng userLocation;

  @override
  State<SelectableMap> createState() => _SelectableMapState();
}

class _SelectableMapState extends State<SelectableMap> {
  final searchTextFieldFocusNode = FocusNode();
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    searchTextFieldFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mapController.mapEventStream,
        initialData: MapEventMove(
            targetCenter: widget.userLocation,
            targetZoom: 18.4,
            source: MapEventSource.initialization,
            center: widget.userLocation,
            zoom: 18.4),
        builder: (context, AsyncSnapshot<MapEvent> mapEventSnapshot) {
          return Consumer(
            builder: (context, ref, child) {
              final cabController = ref.watch(cabControllerProvider);
              return Stack(
                children: [
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    padding: EdgeInsets.only(
                        bottom: cabController.direction == null
                            ? 0
                            : MediaQuery.of(context).size.height * 0.40),
                    child: FlutterMapConfigured(
                        mapController: mapController,
                        startPosition: widget.userLocation,
                        currentPosition: mapEventSnapshot.data!.center),
                  ),
                  GpsIcon(
                      userLocation: widget.userLocation,
                      shouldGoUp: cabController.startTripAddress != null,
                      mapController: mapController),
                  if (cabController.finishTripAddress == null)
                    SearchBar(
                        searchTextFieldFocusNode: searchTextFieldFocusNode),
                  if (cabController.startTripPoint != null)
                    const CancelButton(),
                  const StartTextField(),
                  if (cabController.startTripAddress != null)
                    FinishTextField(
                        text: cabController.finishTripAddress?.placeAddress),
                  // const FinishTextField(),
                  if (!searchTextFieldFocusNode.hasFocus)
                    SubmitButton(
                      mapController: mapController,
                      mapCurrrentPoint: mapEventSnapshot.data!.center,
                    ),
                  if (cabController.direction != null)
                    const BottomControllPad(),
                ],
              );
            },
          );
        });
  }
}
