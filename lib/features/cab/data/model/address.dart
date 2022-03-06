import 'dart:convert';

class Address {
  final String placeAddress;
  final String placeText;
  final double latitude;
  final double longitude;
  final String? landmarkCategory;
  
  Address({
    required this.placeAddress,
    required this.placeText,
    required this.latitude,
    required this.longitude,
    required this.landmarkCategory
  });

  Address copyWith({
    String? placeAddress,
    String? placeText,
    double? latitude,
    double? longitude,
    String? landmarkCategory
  }) {
    return Address(
      placeAddress: placeAddress ?? this.placeAddress,
      placeText: placeText ?? this.placeText,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      landmarkCategory: landmarkCategory
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeAddress': placeAddress,
      'placeText': placeText,
      'latitude': latitude,
      'longitude': longitude,
      'landmarkCategory' : landmarkCategory
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      placeAddress: map['place_name'] ?? '',
      placeText: map['text'] ?? '',
      latitude: map['center'][1]?.toDouble() ?? 0.0,
      longitude: map['center'][0]?.toDouble() ?? 0.0,
      landmarkCategory: map['properties']['category']
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Address(placeAddress: $placeAddress, placeText: $placeText, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Address &&
      other.placeAddress == placeAddress &&
      other.placeText == placeText &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return placeAddress.hashCode ^
      placeText.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
}
