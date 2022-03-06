import 'package:taxi_line/features/accounting/data/datasource/user_data_source.dart';
import 'package:taxi_line/features/accounting/domain/entity/user_entity.dart';
import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImpl({
    required this.userDataSource,
  });

  @override
  Future<MyUser> loginUserWithEmailAndPassword(String email, String password) async {
    try{
      final user = await userDataSource.loginWithEmailAndPassword(email, password);
      return user;
    }catch (error){
      throw UnimplementedError();
    }
  }

  @override
  Future<MyUser> createUserWithEmailAndPassword(String userName, String email, String password) async {
    try{
      final user = await userDataSource.createUserWithEmailAndPassword(userName, email, password);
      return user;
    }catch(error){
      throw UnimplementedError();
    }
  }
}
