import 'package:taxi_line/features/accounting/domain/usecase/create_user_usecase.dart';
import 'package:taxi_line/features/accounting/domain/usecase/login_user_usecase.dart';

class AuthController {
  final LoginUserUseCase loginUserUseCase;
  final CreateUserUseCase createUserUseCase;

  AuthController({
    required this.loginUserUseCase,
    required this.createUserUseCase,
  });


  loginWithEmailAndPassword(String email,String password){
    loginUserUseCase(email,password);
  }

  createUser(String userName,String email,String password){
    createUserUseCase(userName,email,password);
  }
  

}
