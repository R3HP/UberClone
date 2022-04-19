import 'package:flutter/cupertino.dart';
import 'package:taxi_line/features/cab/domain/repository/driver_repository.dart';

class UpdateDriverCreditUseCase {
  final DriverRepository driverRepository;

  UpdateDriverCreditUseCase({
    required this.driverRepository,
  });

  Future<void> call(String driverId,double credit) async {
    try {
      final response = await driverRepository.updateDriverCredit(driverId, credit);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
