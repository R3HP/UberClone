import 'package:taxi_line/features/accounting/domain/repository/user_repositor.dart';

class CreateUserUseCase {
  final UserRepository userRepository;

  CreateUserUseCase({
    required this.userRepository,
  });

  call(String userName,String email,String password) async {
    try {
      await userRepository.createUserWithEmailAndPassword(userName, email, password);
      
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
