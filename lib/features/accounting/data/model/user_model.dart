import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:taxi_line/features/accounting/domain/entity/user_entity.dart';

class MyUserModel extends MyUser {
  MyUserModel(
      {required String id,
      required String userName,
      int credit = 0,
      List<String> favAddress = const [],
      String profilePictureUrl = ''})
      : super(
            id: id,
            userName: userName,
            credit: credit,
            favAddress: favAddress,
            profilePictureUrl: profilePictureUrl);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'credit': credit,
      'favAddress': favAddress,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory MyUserModel.fromMap(Map<String, dynamic> map) {
    return MyUserModel(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      credit: map['credit']?.toInt() ?? 0,
      favAddress: map['favAddress'] == null ? List<String>.from(map['favAddress']) : [],
      profilePictureUrl: map['profilePictureUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUserModel.fromJson(String source) => MyUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyUserModel(id: $id, userName: $userName, credit: $credit, favAddress: $favAddress, profilePictureUrl: $profilePictureUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyUser &&
        other.id == id &&
        other.userName == userName &&
        other.credit == credit &&
        listEquals(other.favAddress, favAddress) &&
        other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        credit.hashCode ^
        favAddress.hashCode ^
        profilePictureUrl.hashCode;
  }
}
