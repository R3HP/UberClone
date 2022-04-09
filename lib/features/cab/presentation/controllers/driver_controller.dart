import 'package:taxi_line/features/cab/data/model/driver.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_driver_detail_use_case.dart';

class DriverController {
  final GetDriverDetailUseCase _getDriverDetailUseCase;
  DriverController({
    required GetDriverDetailUseCase getDriverDetailUseCase,
  }) : _getDriverDetailUseCase = getDriverDetailUseCase;

  Future<Driver> getDriverDetails(String driverId) async {
    final driver = await _getDriverDetailUseCase(driverId);
    return driver;
  }
}
