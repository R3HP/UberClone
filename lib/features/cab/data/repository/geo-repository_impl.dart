import 'package:latlong2/latlong.dart';

import 'package:taxi_line/features/cab/data/datasource/geo_coding_data_source.dart';
import 'package:taxi_line/features/cab/data/model/address.dart';
import 'package:taxi_line/features/cab/domain/repository/geo_coding_repository.dart';

class GeoCodingRepositoryImpl implements GeoCodingRepository {
  final GeoCodingDataSource dataSource;

  GeoCodingRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<Address>> addressToLatLng(String address) async {
    try{
      final response = await dataSource.geoCodeAddressToLatLng(address);
      return response;
    }catch(error){
      throw UnimplementedError();
    }
  }

  @override
  Future<Address> latLngToAddress(double latitude, double longitude) async {
    try {
      final response = await dataSource.geoCodeLatLngToAddress(latitude, longitude);
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }

}
