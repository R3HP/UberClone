import 'dart:convert';

import 'package:flutter/foundation.dart';

class MyUser {
  final String id;
  final String userName;
  final int credit;
  final List<String> favAddress;
  final String profilePictureUrl;

  MyUser({
    required this.id,
    required this.userName,
    this.credit = 0,
    this.favAddress = const [],
    this.profilePictureUrl = ''
  });


  MyUser copyWith({
    String? id,
    String? userName,
    int? credit,
    List<String>? favAddress,
    String? profilePictureUrl,
  }) {
    return MyUser(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      credit: credit ?? this.credit,
      favAddress: favAddress ?? this.favAddress,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  }
