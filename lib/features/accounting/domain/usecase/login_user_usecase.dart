import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';

class LoginUserUseCase {
  final UserRepository userRepository;

  LoginUserUseCase({
    required this.userRepository,
  });

  call(String email, String password) async {
    try {
      final user =
          await userRepository.loginUserWithEmailAndPassword(email, password);  
    } catch (error) {
      print(error);
      throw UnimplementedError();
    }
  }
}
