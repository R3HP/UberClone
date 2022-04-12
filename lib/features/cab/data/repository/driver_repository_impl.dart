import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
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
    } catch (exception) {
      throw ErrorDescription(exception.toString());
    }
    
  }

  @override
  Stream<List<LatLng>> getAvailableDriversLocationStream() {
    try {
      final response = dataSource.getDriversLocationStreamFromDB();
      return response;
    } catch (exception) {
      throw ErrorDescription(exception.toString());
    }
  }

  @override
  Future<List<LatLng>> getAvailableDriversLocation() async {
    try {
      final response = await dataSource.getDriversLocationFromDB();
      return response;
    } catch (exception) {
      throw ErrorDescription(exception.toString());
    }
  }
}
