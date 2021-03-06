import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:taxi_line/features/accounting/data/datasource/user_data_source.dart';
import 'package:taxi_line/features/accounting/data/repository/user_repositor_impl.dart';
import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';
import 'package:taxi_line/features/accounting/domain/usecase/create_user_usecase.dart';
import 'package:taxi_line/features/accounting/domain/usecase/login_user_usecase.dart';
import 'package:taxi_line/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line/features/cab/data/datasource/direction_data_source.dart';
import 'package:taxi_line/features/cab/data/datasource/driver_data_source.dart';
import 'package:taxi_line/features/cab/data/datasource/geo_coding_data_source.dart';
import 'package:taxi_line/features/cab/data/datasource/trip_data_source.dart';
import 'package:taxi_line/features/cab/data/repository/directions_repository_impl.dart';
import 'package:taxi_line/features/cab/data/repository/driver_repository_impl.dart';
import 'package:taxi_line/features/cab/data/repository/geo_repository_impl.dart';
import 'package:taxi_line/features/cab/data/repository/trip_repository_impl.dart';
import 'package:taxi_line/features/cab/domain/repository/direction_repository.dart';
import 'package:taxi_line/features/cab/domain/repository/driver_repository.dart';
import 'package:taxi_line/features/cab/domain/repository/geo_coding_repository.dart';
import 'package:taxi_line/features/cab/domain/repository/trip_repository.dart';
import 'package:taxi_line/features/cab/domain/usecase/delete_pending_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/delete_trip_request_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/finish_pending_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/geo_coding_address_to_latlng_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/geo_coding_latlng_to_address_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_directions_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_driver_detail_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_drivers_location_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_pended_trip_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/get_trip_driver_location_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/post_trip_request_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/update_driver_credit_usecase.dart';
import 'package:taxi_line/features/cab/domain/usecase/update_trip_use_case.dart';
import 'package:taxi_line/features/cab/presentation/controllers/driver_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/geo_code_controller.dart';
import 'package:taxi_line/features/cab/presentation/controllers/trip_controller.dart';

final sl = GetIt.instance;

setUp() {
  
  // accounting
  injectAccounting();

  //cab
  injectCabbing();

  // Directions
  injectDirecting();

  // Trip
  injecrTripping();

  // Driver
  injectDrivering();

  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());
}

void injectDrivering() {
  // Controller
  sl.registerLazySingleton<DriverController>(() => DriverController(
      getDriverDetailUseCase: sl(),
      getAvailableDriversLocationUseCase: sl(),
      getTripDriverLocationUseCase: sl(),
      updateDriverCreditUseCase: sl()));

  // UseCase
  sl.registerLazySingleton<GetDriverDetailUseCase>(
      () => GetDriverDetailUseCase(driverRepository: sl()));
  sl.registerLazySingleton<GetAvailableDriversLocationUseCase>(
      () => GetAvailableDriversLocationUseCase(driverRepository: sl()));
  sl.registerLazySingleton<GetTripDriverLocationUseCase>(
      () => GetTripDriverLocationUseCase(driverRepository: sl()));
  sl.registerLazySingleton<UpdateDriverCreditUseCase>(
      () => UpdateDriverCreditUseCase(driverRepository: sl()));

  // Repository
  sl.registerLazySingleton<DriverRepository>(
      () => DriverRepositoryImpl(dataSource: sl()));

  // dataSource
  sl.registerLazySingleton<DriverDataSource>(() => DriverDataSourceImpl());
}

void injecrTripping() {
  // controller
  sl.registerLazySingleton<TripController>(() => TripController(
      postTripRequestUseCase: sl(),
      deleteTripRequestUseCase: sl(),
      updateTripUseCase: sl(),
      getPendedTripUseCase: sl(),
      finishPendingTripUseCase: sl(),
      deletePendingTripUseCase: sl()));

  // usecase
  sl.registerLazySingleton<PostTripRequestUseCase>(
      () => PostTripRequestUseCase(tripRepository: sl()));
  sl.registerLazySingleton<DeleteTripRequestUseCase>(
      () => DeleteTripRequestUseCase(tripRepository: sl()));
  sl.registerLazySingleton<UpdateTripUseCase>(
      () => UpdateTripUseCase(tripRepository: sl()));
  sl.registerLazySingleton<GetPendedTripUseCase>(
      () => GetPendedTripUseCase(tripRepository: sl()));
  sl.registerLazySingleton<FinishPendingTripUseCase>(
      () => FinishPendingTripUseCase(tripRepository: sl()));
  sl.registerLazySingleton<DeletePendingTripUseCase>(
      () => DeletePendingTripUseCase(tripRepository: sl()));

  // repository
  sl.registerLazySingleton<TripRepository>(
      () => TripRepositoryImpl(tripDataSource: sl()));

  // data source
  sl.registerLazySingleton<TripDataSource>(() => TripDataSourceImpl());
}

void injectDirecting() {
  // usecase
  sl.registerLazySingleton<GetDirectionsUseCase>(
      () => GetDirectionsUseCase(directionsRepository: sl()));
  // repository
  sl.registerLazySingleton<DirectionsRepository>(
      () => DirectionsRepositoryImpl(directionDataSource: sl()));
  // dataSouce
  sl.registerLazySingleton<DirectionsDataSource>(
      () => DirectionsDataSourceImpl(dio: sl()));
}

void injectCabbing() {
  // controller
  sl.registerLazySingleton<GeoCodeController>(() => GeoCodeController(
      addressToLatLngUseCase: sl(), latLngToAddressUseCase: sl()));
  // usecases
  sl.registerLazySingleton<GeoCodingAddressToLatLngUseCase>(
      () => GeoCodingAddressToLatLngUseCase(geoCodingRepostory: sl()));
  sl.registerLazySingleton<GeoCodingLatLngToAddressUseCase>(
      () => GeoCodingLatLngToAddressUseCase(geoCodingRepository: sl()));

  // repository
  sl.registerLazySingleton<GeoCodingRepository>(
      () => GeoCodingRepositoryImpl(dataSource: sl()));

  // datasource
  sl.registerLazySingleton<GeoCodingDataSource>(
      () => GeoCodingDataSourceImpl(dio: sl()));
}

void injectAccounting() {
  sl.registerLazySingleton<AuthController>(
      () => AuthController(loginUserUseCase: sl(), createUserUseCase: sl()));

  // usecases
  sl.registerLazySingleton<LoginUserUseCase>(
      () => LoginUserUseCase(userRepository: sl()));
  sl.registerLazySingleton<CreateUserUseCase>(
      () => CreateUserUseCase(userRepository: sl()));

  // repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userDataSource: sl()));

  // datasource
  sl.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl());
}
