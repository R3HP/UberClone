import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/direction.dart';

abstract class DirectionsRepository{
  Future<Direction> getDirection(LatLng firstPoint,LatLng secondPoint);
}