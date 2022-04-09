import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';

class DeleteTripRequestUseCase {
  final TripRepository tripRepository;

  DeleteTripRequestUseCase({
    required this.tripRepository,
  });

  call(String tripId) async {
    return await tripRepository.deleteTripFromDataBase(tripId);

  }
}
