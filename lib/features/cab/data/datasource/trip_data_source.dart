import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';

abstract class TripDataSource{
  Future<Trip> postTripToDB(Trip trip);
  Future<void> deleteTripFromDB(String tripId);
  Future<Trip> updateTripInDB(Trip trip);
  Future<Trip> getPendingTrip(Trip trip);

}

class TripDataSourceImpl implements TripDataSource{

  @override
  Future<Trip> postTripToDB(Trip trip) async {
    try{
    final refrence = FirebaseDatabase.instance.ref().child('tripRequests').push();
    final response = await refrence.set(trip.toMap());
    return trip.copyWith(id: refrence.key);
    }catch(error){
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteTripFromDB(String tripId) async {
    try {
      final refrence = FirebaseDatabase.instance.ref().child('tripRequests').child(tripId);
      final response = await refrence.remove();
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<Trip> updateTripInDB(Trip trip) async {
    try {
      if (trip.id == null) {
        throw UnimplementedError();
      }
      final refrence = FirebaseDatabase.instance.ref().child('tripRequests').child(trip.id!);
      await refrence.update(trip.toMap());
      return trip;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<Trip> getPendingTrip(Trip trip) async {
    try {
      if (trip.id == null) {
        throw UnimplementedError();
      }
      final dbRef = FirebaseDatabase.instance.ref().child('pendingTrips');
      final event = await dbRef.onChildAdded.firstWhere((databaseEvent) => databaseEvent.snapshot.key == trip.id);
      final pendedTrip = Trip.fromFirebaseMap(event.snapshot.value);
      return pendedTrip;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}