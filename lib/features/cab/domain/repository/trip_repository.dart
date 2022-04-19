import 'package:taxi_line/features/cab/data/model/trip.dart';

abstract class TripRepository {
  Future<Trip> postTripToDataBase(Trip trip);
  Future<void> deleteTripRequestFromDataBase(String tripId);
  Future<void> deletePendingTripFromDataBase(String tripId);
  Future<Trip> updateTripInDataBase(Trip trip);
  Future<Trip> getPendedTripFromDataBase(Trip trip);
  Future<void> createFinishedTripInTripsDataBase(Trip trip);
}