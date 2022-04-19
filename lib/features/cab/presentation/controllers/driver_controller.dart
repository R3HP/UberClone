import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_driver_detail_use_case.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_drivers_location_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_trip_driver_location_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/update_driver_credit_usecase.dart';

class DriverController {
  final GetDriverDetailUseCase _getDriverDetailUseCase;
  final GetAvailableDriversLocationUseCase _getAvailableDriversLocationUseCase;
  final GetTripDriverLocationUseCase _getTripDriverLocationUseCase;
  final UpdateDriverCreditUseCase _updateDriverCreditUseCAse;
  DriverController({
    required UpdateDriverCreditUseCase updateDriverCreditUseCase,
    required GetAvailableDriversLocationUseCase getAvailableDriversLocationUseCase,
    required GetDriverDetailUseCase getDriverDetailUseCase,
    required GetTripDriverLocationUseCase getTripDriverLocationUseCase
  }) : _getDriverDetailUseCase = getDriverDetailUseCase , _getAvailableDriversLocationUseCase = getAvailableDriversLocationUseCase , _getTripDriverLocationUseCase = getTripDriverLocationUseCase , _updateDriverCreditUseCAse = updateDriverCreditUseCase;

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

  Stream<LatLng> getTripDriverLocationStream(String driverId){
    final stream =  _getTripDriverLocationUseCase.getTripDriverLocationStream(driverId);
    return stream;
  }

  Future<LatLng> getTripDriverLocation(String driverId) async {
    final response = await  _getTripDriverLocationUseCase.getTripDriverLocaton(driverId);
    return response;
  }

  Future<void> updateDriverCredit(String driverId,double credit) async {
    final response = await _updateDriverCreditUseCAse(driverId,credit);
    return response;
  }
}
