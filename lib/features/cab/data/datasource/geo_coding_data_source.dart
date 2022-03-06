import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taxi_line/features/cab/data/model/address.dart';

abstract class GeoCodingDataSource {
  Future<Address> geoCodeLatLngToAddress(double latitude, double longitude);
  Future<List<Address>> geoCodeAddressToLatLng(String address);
}

class GeoCodingDataSourceImpl implements GeoCodingDataSource {
  final Dio dio;

  GeoCodingDataSourceImpl({
    required this.dio,
  });
  @override
  Future<List<Address>> geoCodeAddressToLatLng(String addressText) async {
    final forwardGeoCodeUrl =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$addressText.json?access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg';
    final url = Uri.parse(forwardGeoCodeUrl);
    final response = await dio.getUri(url);
    // if (response.statusCode > 300) {
    //   // Exception Should be thrown
    //   throw UnimplementedError();
    // }
    final responseMap = json.decode(response.data) as Map<String, dynamic>;
    final features = responseMap['features'] as List<dynamic>;
    return features.map((feature) => Address.fromMap(feature)).toList();
  }

  @override
  Future<Address> geoCodeLatLngToAddress(
      double addressLatitude, double addressLongitude) async {
    final backwardGeoCodeUrl =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$addressLongitude,$addressLatitude.json?access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg';
    final url = Uri.parse(backwardGeoCodeUrl);
    final response = await dio.getUri(url);
    if (response.statusCode! > 300) {
      throw UnimplementedError();
    }
    final responseMap = json.decode(response.data) as Map<String, dynamic>;
    final features = responseMap['features'] as List<dynamic>;
    return Address.fromMap(features[0]);
  }
}
