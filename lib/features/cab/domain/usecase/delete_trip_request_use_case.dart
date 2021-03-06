import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class DeleteTripRequestUseCase {
  final TripRepository tripRepository;

  DeleteTripRequestUseCase({
    required this.tripRepository,
  });

  Future<void> call(String tripId) async {
    try {
      final response =
          await tripRepository.deleteTripRequestFromDataBase(tripId);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
