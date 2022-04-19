import 'package:taxi_line/features/accounting/domain/entity/user_entity.dart';
import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';

class LoginUserUseCase {
  final UserRepository userRepository;

  LoginUserUseCase({
    required this.userRepository,
  });

  Future<MyUser> call(String email, String password) async {
    try {
      final user =
          await userRepository.loginUserWithEmailAndPassword(email, password);
      return user;
    } catch (error) {
      rethrow;
    }
  }
}
