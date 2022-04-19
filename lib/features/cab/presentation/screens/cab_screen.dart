import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:location/location.dart';

import 'package:taxi_line/features/cab/presentation/widgets/selectable_map.dart';


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
      changeCurrentLocationDataIfItsNotNull(event);
    });
  }

  void changeCurrentLocationDataIfItsNotNull(LocationData event) {
    if (currentLocationData != null) {
      changeLocationDataIfEventDataIsDiffrentFromLocationData(event);
    }
  }

  void changeLocationDataIfEventDataIsDiffrentFromLocationData(LocationData event) {
     if (currentLocationData!.latitude != event.latitude &&
        currentLocationData!.longitude != event.longitude) {
      setState(() {
        currentLocationData = event;
      });
      _mapController.move(latlong.LatLng(currentLocationData!.latitude!,currentLocationData!.longitude!), 18.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: currentLocationData == null
              ? Location.instance.getLocation()
              : Future.value(currentLocationData),
        builder: (ctx, AsyncSnapshot<LocationData?> locationSnapShot) {
          if (locationSnapShot.hasData) {
            final userLocation = latlong.LatLng(
                  locationSnapShot.data!.latitude!,
                  locationSnapShot.data!.longitude!);
              return SelectableMap(userLocation: userLocation,);
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

