import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/domain/repository/driver_repository.dart';

class GetDriverDetailUseCase {
  final DriverRepository driverRepository;

  GetDriverDetailUseCase({
    required this.driverRepository,
  });

  Future<Driver> call(String driverId) async {
    try {
      final response = await driverRepository.getDriverDetails(driverId);
      return response;
    } catch (error) {
      rethrow;
    }
  }
  
  
}
