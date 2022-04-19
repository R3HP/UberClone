import 'package:taxi_line/features/cab/data/model/direction.dart';
import 'package:taxi_line/features/cab/data/model/route.dart';
import 'package:taxi_line/features/cab/data/model/trip.dart';
import 'package:taxi_line/features/cab/data/model/waypoint.dart';
import 'package:taxi_line/features/cab/domain/usecase/delete_pending_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/delete_trip_request_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/finish_pending_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_pended_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/post_trip_request_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/update_trip_use_case.dart';

enum TripCategory { regualar, plus, van }

class TripController {
  final PostTripRequestUseCase _postTripRequestUseCase;
  final DeleteTripRequestUseCase _deleteTripRequestUseCase;
  final UpdateTripUseCase _updateTripUseCase;
  final GetPendedTripUseCase _getPendedTripUsecase;
  final FinishPendingTripUseCase _finishPendingTrip;
  final DeletePendingTripUseCase _deletePendingTripUseCase;

  TripController(
      {required FinishPendingTripUseCase finishPendingTripUseCase,
      required DeletePendingTripUseCase deletePendingTripUseCase,
      required PostTripRequestUseCase postTripRequestUseCase,
      required DeleteTripRequestUseCase deleteTripRequestUseCase,
      required UpdateTripUseCase updateTripUseCase,
      required GetPendedTripUseCase getPendedTripUseCase})
      : _postTripRequestUseCase = postTripRequestUseCase,
        _deleteTripRequestUseCase = deleteTripRequestUseCase,
        _updateTripUseCase = updateTripUseCase,
        _getPendedTripUsecase = getPendedTripUseCase,
        _finishPendingTrip = finishPendingTripUseCase,
        _deletePendingTripUseCase = deletePendingTripUseCase;

  Future<void> deleteTripRequestFromDataBase(String tripId) async {
      final response = await _deleteTripRequestUseCase(tripId);
      return response;
    
  }

  Future<Trip> postTripRequestToDataBase(
      Direction direction, int routeIndex, TripCategory tripCategory) async {
    final route = direction.routes[routeIndex];
    double price = direction.routes[routeIndex].calculateRegularPrice();
    switch (tripCategory) {
      case TripCategory.regualar:
        break;
      case TripCategory.plus:
        price = direction.routes[routeIndex].calculatePlusUerPrice();
        break;
      case TripCategory.van:
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
    final createdTrip =  await _postTripRequestUseCase(trip);
    return createdTrip;
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
    final updatedTrip = await _updateTripUseCase(newTrip);
    return updatedTrip;
  }

  Future<Trip> getPendedTrip(Trip trip) async {
      final pendedTrip = await _getPendedTripUsecase(trip);
      return pendedTrip;
  }

  Future<void> finishPendingTrip(Trip trip) async {
    final response = await _finishPendingTrip(trip);
    return response;
  }

  Future<void> deleePendingTrip(String tripId) async {
    final response = await _deletePendingTripUseCase(tripId);
    return response;
  }
}
