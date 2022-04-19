import 'package:latlong2/latlong.dart';
import 'package:taxi_line/core/error.dart';

import 'package:taxi_line/features/cab/data/datasource/direction_data_source.dart';
import 'package:taxi_line/features/cab/data/model/direction.dart';
import 'package:taxi_line/features/cab/domain/repository/direction_repository.dart';

class DirectionsRepositoryImpl implements DirectionsRepository {
  final DirectionsDataSource directionDataSource;

  DirectionsRepositoryImpl({
    required this.directionDataSource,
  });
  
  @override
  Future<Direction> getDirection(LatLng firstPoint, LatLng secondPoint) async {
    try {
      final response  = await directionDataSource.fetchDirections(firstPoint, secondPoint);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }

}
