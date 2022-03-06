import 'package:taxi_line/features/cab/data/model/address.dart';
import 'package:taxi_line/features/cab/domain/usecase/geo_coding_address_to_latlng_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/geo_coding_latlng_to_address_use_case.dart';

class GeoCodeController {
  final GeoCodingAddressToLatLngUseCase addressToLatLngUseCase;
  final GeoCodingLatLngToAddressUseCase latLngToAddressUseCase;

  GeoCodeController({
    required this.addressToLatLngUseCase,
    required this.latLngToAddressUseCase,
  });

  Future<List<Address>> geoCodeAddressToLatLng(String addressText) async {
    return await addressToLatLngUseCase(addressText);
  }


  Future<Address> geoCodeLatnLngToAddress(double latitude,double longitude) async {
    return await latLngToAddressUseCase(latitude,longitude);
  }

}
