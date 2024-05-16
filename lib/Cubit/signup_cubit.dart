import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swaysafeguardapp/Screens/utilils.dart';

class SignupCubit extends Cubit<bool>{

  SignupCubit(bool initialState): super(initialState);


  FirebaseAuth _auth= FirebaseAuth.instance;

  final fireStore= FirebaseFirestore.instance.collection('Users');

  bool _signedUp=false;


  Future<bool> checkUsernameExists(String _username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: _username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }





  Future<void> createAccount(String _email, String _password, String _username) async {

    bool _userExits= await checkUsernameExists(_username);

    if(_userExits==false){
      _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password
      ).then((value){


        fireStore.doc(_email).set({
          'username': _username,
          'email': _email,
        });


        _signedUp=true;
      }).onError((error, stackTrace){
        _signedUp=false;
      });
    }
    else{
        Utilis().toastMessage('Username already exists. Choose another username!');
    }



    emit(_signedUp);

  }








}