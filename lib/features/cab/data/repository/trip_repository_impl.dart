import 'package:taxi_line/core/error.dart';
import 'package:taxi_line/features/cab/data/datasource/trip_data_source.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {

  TripDataSource tripDataSource;

  TripRepositoryImpl({
    required this.tripDataSource,
  });

  @override
  Future<Trip> postTripToDataBase(Trip trip) async {
    try{
      final response = await tripDataSource.postTripToDB(trip);
      return response;
    }catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> deleteTripRequestFromDataBase(String tripId) async {
    try {
      final response = await tripDataSource.deleteTripRequestFromDB(tripId);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<Trip> updateTripInDataBase(Trip trip) async {
    try {
      final response = await tripDataSource.updateTripInDB(trip);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<Trip> getPendedTripFromDataBase(Trip trip) async {
    try {
      final response = await tripDataSource.getPendingTrip(trip);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> createFinishedTripInTripsDataBase(Trip trip) async {
    try {
      final response = await tripDataSource.createTripInFinishedTripDB(trip);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> deletePendingTripFromDataBase(String tripId) async {
    try {
      final response = await tripDataSource.deletePendingTripFromDB(tripId);
      return response;
    } catch(exception) {
      throw Error(message: exception.toString());
    }
  }
}
