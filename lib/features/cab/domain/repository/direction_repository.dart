import 'package:latlong2/latlong.dart';

abstract class DirectionsRepository{
  Future<dynamic> getDirection(LatLng firstPoint,LatLng secondPoint);
}