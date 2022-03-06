import 'package:taxi_line/features/accounting/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<MyUser> loginUserWithEmailAndPassword(String email,String password);
  Future<MyUser> createUserWithEmailAndPassword(String userName,String email,String password);
}