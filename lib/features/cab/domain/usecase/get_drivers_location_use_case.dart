import 'package:taxi_line/features/cab/domain/repository/driver_repository.dart';
import 'package:latlong2/latlong.dart';

class GetAvailableDriversLocationUseCase {
  final DriverRepository driverRepository;

  GetAvailableDriversLocationUseCase({
    required this.driverRepository,
  });

  Stream<List<LatLng>> getAvailableDriversLocationStream() {
    try {
      final stream = driverRepository.getAvailableDriversLocationStream();
      return stream;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<LatLng>> getDriversLocation() async {

    try {
      final response = await driverRepository.getAvailableDriversLocation();
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
