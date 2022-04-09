import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class Direction {
  List<Route> routes;
  List<WayPoint> waypoints;
  String code;

  Direction({
    required this.routes,
    required this.waypoints,
    required this.code,
  });

  Direction copyWith({
    List<Route>? routes,
    List<WayPoint>? waypoints,
    String? code,
  }) {
    return Direction(
      routes: routes ?? this.routes,
      waypoints: waypoints ?? this.waypoints,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routes': routes.map((x) => x.toMap()).toList(),
      'waypoints': waypoints.map((x) => x.toMap()).toList(),
      'code': code,
    };
  }

  factory Direction.fromMap(Map<String, dynamic> map) {
    return Direction(
      routes: List<Route>.from(map['routes']?.map((x) => Route.fromMap(x))),
      waypoints: List<WayPoint>.from(map['waypoints']?.map((x) => WayPoint.fromMap(x))),
      code: map['code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Direction.fromJson(String source) => Direction.fromMap(json.decode(source));

  @override
  String toString() => 'Direction(routes: $routes, waypoints: $waypoints, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Direction &&
      listEquals(other.routes, routes) &&
      listEquals(other.waypoints, waypoints) &&
      other.code == code;
  }

  @override
  int get hashCode => routes.hashCode ^ waypoints.hashCode ^ code.hashCode;
}

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
          map['geometryCordinates']?.map((x) => LatLng(x[1], x[0]))),
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

class RouteInstruction {
  final String instruction;
  final String? name;
  final double distance;
  final String type;

  RouteInstruction({
    required this.instruction,
    this.name,
    required this.distance,
    required this.type,
  });

  RouteInstruction copyWith({
    String? instruction,
    String? name,
    double? distance,
    String? type,
  }) {
    return RouteInstruction(
      instruction: instruction ?? this.instruction,
      name: name ?? this.name,
      distance: distance ?? this.distance,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instruction': instruction,
      'name': name,
      'distance': distance,
      'type': type,
    };
  }

  factory RouteInstruction.fromMap(Map<String, dynamic> map) {
    return RouteInstruction(
      instruction: map['maneuver']['instruction'] ?? '',
      name: map['name'],
      distance: map['distance']?.toDouble() ?? 0.0,
      type: map['maneuver']['type'] ?? '',
    );
  }

  factory RouteInstruction.fromFirebaseMap(dynamic map) {
    return RouteInstruction(
      instruction: map['instruction'] ?? '',
      name: map['name'],
      distance: map['distance']?.toDouble() ?? 0.0,
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteInstruction.fromJson(String source) =>
      RouteInstruction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RouteInstruction(instruction: $instruction, name: $name, distance: $distance, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteInstruction &&
        other.instruction == instruction &&
        other.name == name &&
        other.distance == distance &&
        other.type == type;
  }

  @override
  int get hashCode {
    return instruction.hashCode ^
        name.hashCode ^
        distance.hashCode ^
        type.hashCode;
  }
}

class WayPoint {
  final double distance;
  final String? name;
  final double longitude;
  final double latitude;

  WayPoint({
    required this.distance,
    this.name,
    required this.longitude,
    required this.latitude,
  });

  WayPoint copyWith({
    double? distance,
    String? name,
    double? longitude,
    double? latitude,
  }) {
    return WayPoint(
      distance: distance ?? this.distance,
      name: name ?? this.name,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory WayPoint.fromMap(dynamic map) {
    return WayPoint(
      distance: map['distance']?.toDouble() ?? 0.0,
      name: map['name'],
      longitude: map['location'][0]?.toDouble() ?? 0.0,
      latitude: map['location'][1]?.toDouble() ?? 0.0,
    );
  }

  factory WayPoint.fromFirebaseMap(dynamic map) {
    return WayPoint(
      distance: map['distance']?.toDouble() ?? 0.0,
      name: map['name'],
      longitude: map['longitude']?.toDouble() ?? 0.0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WayPoint.fromJson(String source) =>
      WayPoint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WayPoint(distance: $distance, name: $name, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WayPoint &&
        other.distance == distance &&
        other.name == name &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }

  @override
  int get hashCode {
    return distance.hashCode ^
        name.hashCode ^
        longitude.hashCode ^
        latitude.hashCode;
  }
}
