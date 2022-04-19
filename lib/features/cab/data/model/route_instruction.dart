import 'dart:convert';

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