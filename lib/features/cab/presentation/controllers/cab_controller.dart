import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/cab/data/model/address.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/direction.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_directions_use_case.dart';

class CabController with ChangeNotifier {
  Address? _startTripAddress;
  Address? _finishTripAddress;
  Direction? _direction;

  final GetDirectionsUseCase getDirectionsUseCase = sl();

  LatLng? get finishTripPoint {
    if (_finishTripAddress != null) {
      return LatLng(
          _finishTripAddress!.latitude, _finishTripAddress!.longitude);
    }
  }

  LatLng? get startTripPoint {
    if (_startTripAddress != null) {
      return LatLng(_startTripAddress!.latitude, _startTripAddress!.longitude);
    }
  }


  set startTripAddress(Address? address) {
    _startTripAddress = address;
    notifyListeners();
  }

  Address? get startTripAddress {
    return _startTripAddress?.copyWith();
  }

  set finishTripAddress(Address? address) {
    _finishTripAddress = address;
    notifyListeners();
  }

  Address? get finishTripAddress {
    return _finishTripAddress?.copyWith();
  }

  Direction? get direction{
    return _direction?.copyWith();
  }

  void cancel(){
    _finishTripAddress = null;
    _startTripAddress = null;
    _direction = null;
    notifyListeners();
  }

  Future<void> getDirectionForPoints() async {
    if (_startTripAddress == null || _finishTripAddress == null) {
      throw UnimplementedError();
    }
    try {
      final direction = await getDirectionsUseCase(
        LatLng(_startTripAddress!.latitude, _startTripAddress!.longitude),
        LatLng(_finishTripAddress!.latitude, _finishTripAddress!.longitude),
      );
      _direction = direction;
      notifyListeners();
      return ;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
