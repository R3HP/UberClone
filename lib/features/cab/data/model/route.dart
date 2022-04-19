import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/route_instruction.dart';

class Route {
  double duration;
  double distance;
  List<LatLng> geometryCordinates;
  List<RouteInstruction> instructions;

  Route({
    required this.duration,
    required this.distance,
    required this.geometryCordinates,
    required this.instructions,
  });

  Route copyWith({
    double? duration,
    double? distance,
    List<LatLng>? geometryCordinates,
    List<RouteInstruction>? instructions,
  }) {
    return Route(
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      geometryCordinates: geometryCordinates ?? this.geometryCordinates,
      instructions: instructions ?? this.instructions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'duration': duration,
      'distance': distance,
      'geometryCordinates': geometryCordinates.map((x) => [x.latitude,x.longitude]).toList(),
      'instructions': instructions.map((x) => x.toMap()).toList(),
    };
  }

  factory Route.fromMap(dynamic map) {
    return Route(
      duration: map['duration']?.toDouble() ?? 0.0,
      distance: map['distance']?.toDouble() ?? 0.0,
      geometryCordinates: List<LatLng>.from(
          map['geometry']['coordinates']?.map((x) => LatLng(x[1], x[0]))),
      instructions: List<RouteInstruction>.from(
          map['legs'][0]['steps']?.map((x) => RouteInstruction.fromMap(x))),
    );
  }

  factory Route.fromFirebaseMap(dynamic map) {
    return Route(
      duration: map['duration']?.toDouble() ?? 0.0,
      distance: map['distance']?.toDouble() ?? 0.0,
      geometryCordinates: List<LatLng>.from(
          map['geometryCordinates']?.map((x) => LatLng(x[0], x[1]))),
      instructions: List<RouteInstruction>.from(
          map['instructions']?.map((x) => RouteInstruction.fromFirebaseMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Route.fromJson(String source) => Route.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Route(duration: $duration, distance: $distance, geometryCordinates: $geometryCordinates, instructions: $instructions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Route &&
        other.duration == duration &&
        other.distance == distance &&
        listEquals(other.geometryCordinates, geometryCordinates) &&
        listEquals(other.instructions, instructions);
  }

  @override
  int get hashCode {
    return duration.hashCode ^
        distance.hashCode ^
        geometryCordinates.hashCode ^
        instructions.hashCode;
  }

  double get distanceAsKM{
    return distance / 1000;
  }

  Duration get durationAs{
    return Duration(seconds: duration.ceil());
  }

  double calculateRegularPrice(){
    // base price = 3 $
    // price per km = 1$
    // price per minute = 0.2$
    final regularUberPrice = 3 + (distance / 1000) * 1 + (duration / 60) * 0.2 ;

    return regularUberPrice;
  }

  double calculatePlusUerPrice(){
    // base price = 5 ; 
    // price per km = 1.5$
    // price per minute = .3 $
    final plusUberPrice = 5 + (distance / 1000) * 1.5 + (duration / 60) * 0.3 ;

    return plusUberPrice;
  }

  double calculateVanUberPirce(){
    // base price = 5;
    // price per km = 2 $
    // price per minute = 0.5$
    final vanUberPrice = 5 + (distance / 1000) * 2 + (duration / 60) * 0.5 ;
    return vanUberPrice;
  }

}