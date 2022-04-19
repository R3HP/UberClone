import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/direction.dart';


import 'package:taxi_line/features/cab/domain/repository/direction_repository.dart';

class GetDirectionsUseCase {
  final DirectionsRepository directionsRepository;

  GetDirectionsUseCase({
    required this.directionsRepository,
  });

  Future<Direction> call(LatLng firstPoint,LatLng secondPoint) async {
    try{
      final direction = await directionsRepository.getDirection(firstPoint, secondPoint);
      return direction;
    }catch(error){
      rethrow;
    }
  }
}
