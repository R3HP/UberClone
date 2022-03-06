import 'package:latlong2/latlong.dart';
import 'package:taxi_line/features/cab/data/model/address.dart';

abstract class GeoCodingRepository {
  Future<Address> latLngToAddress(double latitude,double longitude);
  Future<List<Address>> addressToLatLng(String address);
}