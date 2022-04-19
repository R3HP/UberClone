import 'package:taxi_line/features/accounting/domain/entity/user_entity.dart';
import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';

class CreateUserUseCase {
  final UserRepository userRepository;

  CreateUserUseCase({
    required this.userRepository,
  });

  Future<MyUser> call(String userName,String email,String password) async {
    try {
      final user = await userRepository.createUserWithEmailAndPassword(userName, email, password);
      return user;
    } catch (error) {
      rethrow;
    }
  }
}
