import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Screens/user_main_screen.dart';

class LoginCubit extends Cubit<bool>{

  LoginCubit(bool initialState): super(initialState);

  FirebaseAuth _auth= FirebaseAuth.instance;

  bool _loggedIn=false;


  void loginToAccount(String _email, String _password){

    _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
    ).then((value){
      _loggedIn=true;
    }).onError((error, stackTrace){
      _loggedIn=false;
    });
    
    emit(_loggedIn);

  }






}