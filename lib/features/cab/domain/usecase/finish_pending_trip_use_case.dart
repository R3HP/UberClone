import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class FinishPendingTripUseCase {
  final TripRepository tripRepository;

  FinishPendingTripUseCase({
    required this.tripRepository,
  });


  Future<void> call(Trip trip) async {
    try {
      await tripRepository.deletePendingTripFromDataBase(trip.id!);
      await tripRepository.createFinishedTripInTripsDataBase(trip);
      return;
    } catch (error) {
      rethrow;
    }
  }
  
}
