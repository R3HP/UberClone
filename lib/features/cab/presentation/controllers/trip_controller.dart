import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line/features/cab/data/model/direction.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/domain/usecase/delete_trip_request_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_pended_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/post_trip_request_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/update_trip_use_case.dart';

enum TripCategory { Regualar, Plus, Van }

class TripController {
  PostTripRequestUseCase _postTripRequestUseCase;
  DeleteTripRequestUseCase _deleteTripRequestUseCase;
  UpdateTripUseCase _updateTripUseCase;
  GetPendedTripUseCase _getPendedTripUsecase;

  // Trip? _trip;
  TripController({
    required PostTripRequestUseCase postTripRequestUseCase,
    required DeleteTripRequestUseCase deleteTripRequestUseCase,
    required UpdateTripUseCase updateTripUseCase,
    required GetPendedTripUseCase getPendedTripUseCase
  }) : _postTripRequestUseCase = postTripRequestUseCase , _deleteTripRequestUseCase = deleteTripRequestUseCase, _updateTripUseCase = updateTripUseCase, _getPendedTripUsecase = getPendedTripUseCase;

  Future<void> deleteTripRequestFromDataBase(String tripId) async {
    try {
      final response = await _deleteTripRequestUseCase(tripId);
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  Future<Trip> postTripRequestToDataBase(
      Direction direction, int routeIndex, TripCategory tripCategory) async {
    final route = direction.routes[routeIndex];
    double price = direction.routes[routeIndex].calculateRegularPrice();
    switch (tripCategory) {
      case TripCategory.Regualar:
        break;
      case TripCategory.Plus:
        price = direction.routes[routeIndex].calculatePlusUerPrice();
        break;
      case TripCategory.Van:
        price = direction.routes[routeIndex].calculateVanUberPirce();
        break;
      default:
        break;
    }
    final trip = Trip(
        route: route,
        distance: route.distance,
        duration: route.duration,
        wayPoints: direction.waypoints,
        price: price,
        createdAt: DateTime.now());
    return await _postTripRequestUseCase(trip);
  }

  Future<Trip> updateTripInDataBase(Trip trip,
      {double? price,
      Route? route,
      DateTime? createdAt,
      double? distance,
      double? duration,
      List<WayPoint>? wayPoints}) async {
    final newTrip = trip.copyWith(
        createdAt: createdAt,
        distance: distance,
        duration: duration,
        price: price,
        route: route,
        wayPoints: wayPoints);
        final response = await _updateTripUseCase(newTrip);
        return response;
  }

  Future<Trip> getPendedTrip(Trip trip)async{
    try {
      final response = await _getPendedTripUsecase(trip);
      return response;
    } catch (errro) {
      throw UnimplementedError();
    }
  }
}
