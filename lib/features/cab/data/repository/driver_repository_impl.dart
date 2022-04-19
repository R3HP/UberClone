import 'package:latlong2/latlong.dart';
import 'package:taxi_line/core/error.dart';
import 'package:taxi_line/features/cab/data/datasource/driver_data_source.dart';
import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/domain/repository/driver_repository.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverDataSource dataSource ;

  DriverRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Driver> getDriverDetails(String driverId) async {
    try {
      final response = await dataSource.getDriverDetails(driverId);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
    
  }

  @override
  Stream<List<LatLng>> getAvailableDriversLocationStream() {
    try {
      final response = dataSource.getDriversLocationStreamFromDB();
      return response;
    }catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<List<LatLng>> getAvailableDriversLocation() async {
    try {
      final response = await dataSource.getDriversLocationFromDB();
      return response;
    }catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<LatLng> getTripDriversLocation(String driverId) async {
    try {
      final location = await dataSource.getTripDriversLocationFromDB(driverId);
      return location;
    }catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Stream<LatLng> getTripDriversLocationStream(String driverId) {
    try {
      final stream = dataSource.getTripDriverLocationStreamFromDB(driverId);
      return stream;
    }catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> updateDriverCredit(String driverId, double credit) async {
    try {
      final response = await dataSource.updateDriverCreditInDB(driverId, credit);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }
}
