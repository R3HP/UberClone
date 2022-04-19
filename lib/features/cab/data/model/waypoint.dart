import 'dart:convert';

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