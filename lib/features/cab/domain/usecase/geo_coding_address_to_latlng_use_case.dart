import 'package:taxi_line/features/cab/data/model/address.dart';
import 'package:taxi_line/features/cab/domain/repository/geo_coding_repository.dart';

class GeoCodingAddressToLatLngUseCase {
  final GeoCodingRepository geoCodingRepostory;

  GeoCodingAddressToLatLngUseCase({
    required this.geoCodingRepostory,
  });

  Future<List<Address>> call(String address) async {
    try{
      final latLngList = await geoCodingRepostory.addressToLatLng(address);
      return latLngList;
    }catch(error){
      rethrow;
    }
  }

}
