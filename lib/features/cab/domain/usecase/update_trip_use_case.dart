import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class UpdateTripUseCase {
  final TripRepository tripRepository;

  UpdateTripUseCase({
    required this.tripRepository,
  });

  Future<Trip> call(Trip trip) async {
    try {
      return await tripRepository.updateTripInDataBase(trip); 
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
