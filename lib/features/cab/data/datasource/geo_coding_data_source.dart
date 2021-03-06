import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taxi_line/core/constants.dart';
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
    try {
      final forwardGeoCodeUrl =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$addressText.json?access_token=$Your_Primary_Key';
      final url = Uri.parse(forwardGeoCodeUrl);
      final response = await dio.getUri(url);
      final responseMap = json.decode(response.data) as Map<String, dynamic>;
      final features = responseMap['features'] as List<dynamic>;
      return features.map((feature) => Address.fromMap(feature)).toList();
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<Address> geoCodeLatLngToAddress(
      double addressLatitude, double addressLongitude) async {
    try {
      final backwardGeoCodeUrl =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$addressLongitude,$addressLatitude.json?access_token=$Your_Primary_Key';
      final url = Uri.parse(backwardGeoCodeUrl);
      final response = await dio.getUri(url);
      if (response.statusCode! > 300) {
        throw Exception('status Code ${response.statusCode}');
      }
      final responseMap = json.decode(response.data) as Map<String, dynamic>;
      final features = responseMap['features'] as List<dynamic>;
      // using copy with we raturn an address with exact latLon as requested other wise a latLng that is returned by GeoCoding Api is returned
      return Address.fromMap(features[0])
          .copyWith(latitude: addressLatitude, longitude: addressLongitude);
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
