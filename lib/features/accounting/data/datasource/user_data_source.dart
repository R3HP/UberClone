import 'dart:convert';

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
      print(userDataSnapShot.value);
      print(userDataSnapShot);
      print(userDataSnapShot.children);
      for(final snap in userDataSnapShot.children){
        print(snap.value);
      }
      print(userDataSnapShot.value.runtimeType);
      print(userDataSnapShot.toString());
      // final userMap = json.decode(userDataSnapShot.value.toString());
      final userMap =  Map<String,dynamic>.fromIterables(userDataSnapShot.children.map( (snap) => snap.key! ), userDataSnapShot.children.map((snap) => snap.value));
      print(userMap);
      final user = MyUserModel.fromMap(userMap);
      return user;
    }catch(error){
      print(error);
      throw UnimplementedError();
    }
  }

  @override
  Future<MyUserModel> createUserWithEmailAndPassword(String userName, String email, String password) async {
    try {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final dbRef = FirebaseDatabase.instance.ref('users').child(credentials.user!.uid);
      final usermodel =  MyUserModel(id: credentials.user!.uid, userName: userName,favAddress: ['kose nanat','kose ammat']);
      print(usermodel.toMap());
      await dbRef.set(usermodel.toMap());
      return usermodel;
    } catch (error) {
      print(error.toString());
      throw UnimplementedError();
    }
  }
}