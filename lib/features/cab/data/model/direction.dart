import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/route.dart';
import 'package:taxi_line/features/cab/data/model/waypoint.dart';

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






