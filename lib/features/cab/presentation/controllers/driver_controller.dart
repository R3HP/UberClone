import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_driver_detail_use_case.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_drivers_location_use_case.dart';

class DriverController {
  final GetDriverDetailUseCase _getDriverDetailUseCase;
  final GetAvailableDriversLocationUseCase _getAvailableDriversLocationUseCase;
  DriverController({
    required GetAvailableDriversLocationUseCase getAvailableDriversLocationUseCase,
    required GetDriverDetailUseCase getDriverDetailUseCase,
  }) : _getDriverDetailUseCase = getDriverDetailUseCase , _getAvailableDriversLocationUseCase = getAvailableDriversLocationUseCase;

  Future<Driver> getDriverDetails(String driverId) async {
    final driver = await _getDriverDetailUseCase(driverId);
    return driver;
  }

  Stream<List<LatLng>> getDriversLocationStream(){
    final stream = _getAvailableDriversLocationUseCase.getAvailableDriversLocationStream();
    return stream;
  }

  Future<List<LatLng>> getDriversLocation() async {
    final locations = await _getAvailableDriversLocationUseCase.getDriversLocation();
    return locations;
  }


}
