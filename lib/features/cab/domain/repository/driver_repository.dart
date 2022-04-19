import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:latlong2/latlong.dart';

abstract class DriverRepository{
  Future<Driver> getDriverDetails(String driverId);
  Stream<List<LatLng>> getAvailableDriversLocationStream();
  Future<List<LatLng>> getAvailableDriversLocation();
  Stream<LatLng> getTripDriversLocationStream(String driverId);
  Future<LatLng> getTripDriversLocation(String driverId);
  Future<void> updateDriverCredit(String driverId,double credit);
}