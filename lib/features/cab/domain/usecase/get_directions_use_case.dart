import 'package:latlong2/latlong.dart';


import 'package:taxi_line/features/cab/domain/repository/direction_repository.dart';

class GetDirectionsUseCase {
  final DirectionsRepository directionsRepository;

  GetDirectionsUseCase({
    required this.directionsRepository,
  });

  call(LatLng firstPoint,LatLng secondPoint) async {
    try{
      return await directionsRepository.getDirection(firstPoint, secondPoint);

    }catch(error){
      throw UnimplementedError();
    }
  }
}
