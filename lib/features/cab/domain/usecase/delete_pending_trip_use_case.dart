import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class DeletePendingTripUseCase {
  final TripRepository tripRepository;

  DeletePendingTripUseCase({
    required this.tripRepository,
  });

  Future<void> call(String tripId)async{
    try {
      final response = await tripRepository.deletePendingTripFromDataBase(tripId);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
