
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line/features/accounting/data/model/user_model.dart';

abstract class UserDataSource {
  Future<MyUserModel> loginWithEmailAndPassword(String email,String password);
  Future<MyUserModel> createUserWithEmailAndPassword(String userName,String email,String password);
}

class UserDataSourceImpl implements UserDataSource{
  @override
  Future<MyUserModel> loginWithEmailAndPassword(String email, String password) async {
    try{
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final dbRef = FirebaseDatabase.instance.ref('users').child(credentials.user!.uid);
      final userDataSnapShot = await dbRef.get();
      final userMap =  Map<String,dynamic>.fromIterables(userDataSnapShot.children.map( (snap) => snap.key! ), userDataSnapShot.children.map((snap) => snap.value));
      final user = MyUserModel.fromMap(userMap);
      return user;
    }catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<MyUserModel> createUserWithEmailAndPassword(String userName, String email, String password) async {
    try {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final dbRef = FirebaseDatabase.instance.ref('users').child(credentials.user!.uid);
      final usermodel =  MyUserModel(id: credentials.user!.uid, userName: userName);
      await dbRef.set(usermodel.toMap());
      return usermodel;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}