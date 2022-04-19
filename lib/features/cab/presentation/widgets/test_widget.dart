import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line/core/constants.dart';

import 'package:taxi_line/features/cab/data/model/trip.dart';

class TestWidget extends StatelessWidget {
  final Trip trip;

  const TestWidget({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: latlong.LatLng(
                trip.wayPoints.first.latitude, trip.wayPoints.first.longitude),
            maxZoom: 18.4,
            zoom: 18.0,
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
            MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: trip.wayPoints.map((waypoint) => Marker(point: latlong.LatLng(waypoint.latitude,waypoint.longitude), builder: (ctx) => Icon(Icons.location_on))).toList(),
              ),
            ),
            PolylineLayerWidget(
              options: PolylineLayerOptions(
                polylines: [
                  Polyline(points: trip.route.geometryCordinates,color: Colors.yellow)
                ]
              ),
            ),
          ],
        )
      ],
    );
  }
}
