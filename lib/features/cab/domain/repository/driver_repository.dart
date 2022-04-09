import 'package:taxi_line/features/cab/data/model/driver.dart';

abstract class DriverRepository{
  Future<Driver> getDriverDetails(String driverId);
}