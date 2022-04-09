import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:location/location.dart';

import 'package:taxi_line/features/cab/presentation/controllers/cab_controller.dart';
import 'package:taxi_line/features/cab/presentation/widgets/bottom_controll_pad.dart';
import 'package:taxi_line/features/cab/presentation/widgets/cancel_button.dart';
import 'package:taxi_line/features/cab/presentation/widgets/finish_address_text_field.dart';
import 'package:taxi_line/features/cab/presentation/widgets/gps_icon.dart';
import 'package:taxi_line/features/cab/presentation/widgets/search_bar.dart';
import 'package:taxi_line/features/cab/presentation/widgets/selectable_map.dart';
import 'package:taxi_line/features/cab/presentation/widgets/start_address_text_field.dart';
import 'package:taxi_line/features/cab/presentation/widgets/submit_button.dart';

final cabControllerProvider = ChangeNotifierProvider.autoDispose<CabController>(
    ((ref) => CabController()));

class CabScreen extends StatefulWidget {
  static const routeName = '/cab_screen';

  const CabScreen({Key? key}) : super(key: key);

  @override
  State<CabScreen> createState() => _CabScreenState();
}

class _CabScreenState extends State<CabScreen> {
  final MapController _mapController = MapController();

  
  LocationData? currentLocationData;

  @override
  void initState() {
    super.initState();
    Location.instance.onLocationChanged.listen((event) {
      print(currentLocationData == null);
      if (currentLocationData != null) {
        if (currentLocationData!.latitude != event.latitude &&
            currentLocationData!.longitude != event.longitude) {
          setState(() {
            // authController.currentLocationData = event;
            currentLocationData = event;
          });
          _mapController.move(latlong.LatLng(currentLocationData!.latitude!,currentLocationData!.longitude!), 18.4);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final cabController = ref.watch(cabControllerProvider);
    return Scaffold(
      body: FutureBuilder(
        future: currentLocationData == null
              ? Location.instance.getLocation()
              : Future.value(currentLocationData),
        builder: (ctx, AsyncSnapshot<LocationData?> locationSnapShot) {
          if (locationSnapShot.hasData) {
            final startPosition = latlong.LatLng(
                  locationSnapShot.data!.latitude!,
                  locationSnapShot.data!.longitude!);
              return SelectableMap(mapController: _mapController, startPosition: startPosition,);
          } else {
            if (locationSnapShot.hasError) {
              return Center(
                child: Text(locationSnapShot.error.toString()),
              );              
            } else {
              return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
            }
          }
        },
      ),
    );
  }
}

