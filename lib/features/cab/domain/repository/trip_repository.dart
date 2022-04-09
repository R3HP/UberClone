import 'package:taxi_line/features/cab/data/model/trip.dart';

abstract class TripRepository {
  Future<Trip> postTripToDataBase(Trip trip);
  Future<void> deleteTripFromDataBase(String tripId);
  Future<Trip> updateTripInDataBase(Trip trip);
  Future<Trip> getPendedTripFromDataBase(Trip trip);
}