import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:taxi_line/features/accounting/data/datasource/user_data_source.dart';
import 'package:taxi_line/features/accounting/data/repository/user_repositor_impl.dart';
import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';
import 'package:taxi_line/features/accounting/domain/usecase/create_user_usecase.dart';
import 'package:taxi_line/features/accounting/domain/usecase/login_user_usecase.dart';
import 'package:taxi_line/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line/features/accounting/presentation/screen/auth_screen.dart';
import 'package:taxi_line/features/cab/data/datasource/geo_coding_data_source.dart';
import 'package:taxi_line/features/cab/data/repository/geO-repository_impl.dart';
import 'package:taxi_line/features/cab/domain/repository/geo_coding_repository.dart';
import 'package:taxi_line/features/cab/domain/usecase/geo_coding_address_to_latlng_use_case.dart';
import 'package:taxi_line/features/cab/domain/usecase/geo_coding_latlng_to_address_use_case.dart';
import 'package:taxi_line/features/cab/presentation/controllers/geo_code_controller.dart';


final sl = GetIt.instance;


setUp(){
  // accounting

  // controller 

  sl.registerLazySingleton<AuthController>(() => AuthController(loginUserUseCase: sl(), createUserUseCase: sl()));

  // usecases
  sl.registerLazySingleton<LoginUserUseCase>(() => LoginUserUseCase(userRepository: sl()));
  sl.registerLazySingleton<CreateUserUseCase>(() => CreateUserUseCase(userRepository: sl()));

  // repository 
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(userDataSource: sl()));

  // datasource
  sl.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl());

  //cab

  // controller 
  sl.registerLazySingleton<GeoCodeController>(() => GeoCodeController(addressToLatLngUseCase: sl(), latLngToAddressUseCase: sl()));
  // usecases
  sl.registerLazySingleton<GeoCodingAddressToLatLngUseCase>(() => GeoCodingAddressToLatLngUseCase(geoCodingRepostory: sl()));
  sl.registerLazySingleton<GeoCodingLatLngToAddressUseCase>(() => GeoCodingLatLngToAddressUseCase(geoCodingRepository: sl()));

  // repository
  sl.registerLazySingleton<GeoCodingRepository>(() => GeoCodingRepositoryImpl(dataSource: sl()));

  // datasource
  sl.registerLazySingleton<GeoCodingDataSource>(() => GeoCodingDataSourceImpl(dio: Dio()));

}