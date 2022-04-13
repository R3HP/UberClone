import 'package:taxi_line/features/cab/domain/repository/driver_repository.dart';
import 'package:latlong2/latlong.dart';

class GetTripDriverLocationUseCase {
  final DriverRepository _driverRepository;
  GetTripDriverLocationUseCase({
    required DriverRepository driverRepository,
  }) : _driverRepository = driverRepository;


  Stream<LatLng> getTripDriverLocationStream(String driverId){
    
      final stream = _driverRepository.getTripDriversLocationStream(driverId);
      return stream;
    
  }

  Future<LatLng> getTripDriverLocaton(String driverId) async {
    final response = await  _driverRepository.getTripDriversLocation(driverId);
    return response;
  }
}
