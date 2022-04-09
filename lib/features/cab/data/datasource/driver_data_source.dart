import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line/features/cab/data/model/driver.dart';

abstract class DriverDataSource {
  Future<Driver> getDriverDetails(String driverId);
}

class DriverDataSourceImpl implements DriverDataSource {
  @override
  Future<Driver> getDriverDetails(String driverId) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('drivers').child(driverId);
      final driverData = await dbRef.get();
      final driver = Driver.fromMap(driverData.value);
      return driver;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
