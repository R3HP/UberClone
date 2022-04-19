import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';

abstract class TripDataSource{
  Future<Trip> postTripToDB(Trip trip);
  Future<void> deleteTripRequestFromDB(String tripId);
  Future<void> deletePendingTripFromDB(String tripId);
  Future<void> createTripInFinishedTripDB(Trip trip);
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
    }catch(exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<void> deleteTripRequestFromDB(String tripId) async {
    try {
      final refrence = FirebaseDatabase.instance.ref().child('tripRequests').child(tripId);
      final response = await refrence.remove();
      return response;
    } catch(exception) {
      throw Exception(exception.toString());
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
    }catch(exception) {
      throw Exception(exception.toString());
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
    }catch(exception) {
      throw Exception(exception.toString());
    }
  }

  

  @override
  Future<void> createTripInFinishedTripDB(Trip trip) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('trips').child(trip.id!);
      final response = await dbRef.set(trip.toMap());
      return ;
    }catch(exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<void> deletePendingTripFromDB(String tripId) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('pendingTrips').child(tripId);
      final response = await dbRef.remove();
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}