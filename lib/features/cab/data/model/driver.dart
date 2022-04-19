import 'dart:convert';

class Driver {
  final String? id;
  final String userName;
  final String profilePictureUrl;
  final double credit;
  final String carModel;
  final String plateNumber;

  Driver({
    this.id,
    required this.userName,
    required this.profilePictureUrl,
    required this.credit,
    required this.carModel,
    required this.plateNumber,
  });

  Driver copyWith({
    String? id,
    String? userName,
    String? profilePictureUrl,
    double? credit,
    String? carModel,
    String? plateNumber,
  }) {
    return Driver(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      credit: credit ?? this.credit,
      carModel: carModel ?? this.carModel,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'profilePictureUrl': profilePictureUrl,
      'credit': credit,
      'carModel': carModel,
      'plateNumber': plateNumber,
    };
  }

  factory Driver.fromMap(dynamic map) {
    return Driver(
      id: map['id'],
      userName: map['userName'] ?? '',
      profilePictureUrl: map['profilePictureUrl'].isEmpty
          ? 'https://firebasestorage.googleapis.com/v0/b/uber-clone-15f3c.appspot.com/o/taxi_driver.jpg?alt=media&token=e82dc1f5-2385-4b88-b955-cd59db05bd81'
          : map['profilePictureUrl'] ??
              'https://firebasestorage.googleapis.com/v0/b/uber-clone-15f3c.appspot.com/o/taxi_driver.jpg?alt=media&token=e82dc1f5-2385-4b88-b955-cd59db05bd81',
      credit: map['credit']?.toDouble() ?? 0.0,
      carModel: map['carModel'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Driver.fromJson(String source) => Driver.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Driver(id: $id, userName: $userName, profilePictureUrl: $profilePictureUrl, credit: $credit, carModel: $carModel, plateNumber: $plateNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;


    return other is Driver &&
        other.id == id &&
        other.userName == userName &&
        other.profilePictureUrl == profilePictureUrl &&
        other.credit == credit &&
        other.carModel == carModel &&
        other.plateNumber == plateNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        profilePictureUrl.hashCode ^
        credit.hashCode ^
        carModel.hashCode ^
        plateNumber.hashCode;
  }
}
