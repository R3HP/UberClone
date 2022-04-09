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
    }catch (error){
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteTripFromDataBase(String tripId) async {
    try {
      final response = await tripDataSource.deleteTripFromDB(tripId);
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<Trip> updateTripInDataBase(Trip trip) async {
    try {
      final response = await tripDataSource.updateTripInDB(trip);
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<Trip> getPendedTripFromDataBase(Trip trip) async {
    try {
      final response = await tripDataSource.getPendingTrip(trip);
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
