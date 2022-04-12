import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:latlong2/latlong.dart';


abstract class DriverDataSource {
  Future<Driver> getDriverDetails(String driverId);
  Stream<List<LatLng>> getDriversLocationStreamFromDB();
  Stream<LatLng> getTripDriverLocationStreamFromDB(String driverId);
  Future<List<LatLng>> getDriversLocationFromDB();
  Future<LatLng> getTripDriversLocationFromDB(String driverId);
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

  @override
  Stream<List<LatLng>> getDriversLocationStreamFromDB() {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('availableDrivers');
      final locationStream  = dbRef.onValue.asyncMap((event) => getDriversLocationFromDB());
      return locationStream;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<List<LatLng>> getDriversLocationFromDB() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('availableDrivers');
      final availableDriversMap = await dbRef.get();
      final locations = availableDriversMap.children.map((dataSnapshot) {
        final snapshot = dataSnapshot.value as dynamic;
        return LatLng(snapshot['location']['latitude'],snapshot['location']['longitude']);
      }).toList();
      return locations;

      
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Stream<LatLng> getTripDriverLocationStreamFromDB(String driverId) {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('availableDrivers').child(driverId);
      final stream = dbRef.onValue.map((event) {
        final locationData = event.snapshot.value as dynamic;
        return LatLng(locationData['location']['latitude'],locationData['location']['longitude']);
      });
      return stream;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<LatLng> getTripDriversLocationFromDB(String driverId) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('availableDrivers').child(driverId);
      final response = await dbRef.get();
      final locationData = response.value as dynamic;
      final location = LatLng(locationData['location']['latitude'],locationData['location']['longitude']);
      return location;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
