import 'package:taxi_line/features/cab/data/model/address.dart';
import 'package:taxi_line/features/cab/domain/repository/geo_coding_repository.dart';

class GeoCodingLatLngToAddressUseCase {
  final GeoCodingRepository geoCodingRepository;

  GeoCodingLatLngToAddressUseCase({
    required this.geoCodingRepository,
  });


  Future<Address> call(double latitude,double longitude) async {
    try{
      final address = await geoCodingRepository.latLngToAddress(latitude, longitude);
      return address;
    }catch (error){
      rethrow;
    }
  }
}
