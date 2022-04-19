import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class PostTripRequestUseCase {
  final TripRepository tripRepository;

  PostTripRequestUseCase({
    required this.tripRepository,
  });

  Future<Trip> call(Trip trip) async {
    try {
      final response = await tripRepository.postTripToDataBase(trip);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
