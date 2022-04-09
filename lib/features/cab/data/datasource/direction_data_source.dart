import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/direction.dart';

abstract class DirectionsDataSource{
  Future<Direction> fetchDirections(LatLng firstPoint,LatLng secondPoint);
}

class DirectionsDataSourceImpl implements DirectionsDataSource {
  final Dio dio ;
  DirectionsDataSourceImpl({
    required this.dio,
  });
  @override
  Future<Direction> fetchDirections(LatLng firstPoint, LatLng secondPoint) async {
    try{
    Uri url = Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving-traffic/${firstPoint.longitude},${firstPoint.latitude};${secondPoint.longitude},${secondPoint.latitude}?geometries=geojson&steps=true&access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg');
    final response = await dio.getUri(url);
    // final responseMap = json.decode(response.data) as Map<String,dynamic>;
    final direction = Direction.fromMap(response.data);
    return direction;
    }catch(error){
      throw UnimplementedError();
    }

  }

}
