import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swaysafeguardapp/Cubit/login_cubit.dart';
import 'package:swaysafeguardapp/Screens/home_screen.dart';
import 'package:swaysafeguardapp/Screens/login_screen.dart';
import 'package:swaysafeguardapp/Screens/profile_details_screen.dart';
import 'package:swaysafeguardapp/Screens/splash_screen.dart';
import 'package:swaysafeguardapp/Screens/user_main_screen.dart';

import 'Cubit/signup_cubit.dart';
import 'Screens/admin_main_screen.dart';


void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});




  @override
  Widget build(BuildContext context) {
/////////////////////////////////////////////

    final _auth= FirebaseAuth.instance;
    final user= _auth.currentUser;

    String _email='';


    Future <void> _getUserData()async{

      final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();


        _email= _userData.get('role').toString();

    }




    /////////////////////////////////////////

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit(false)),
        BlocProvider(create: (context) => SignupCubit(false)),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: user==null? const SplashScreen(): _auth.currentUser?.email=="mjn7439@gmail.com"? const AdminMainScreen(): const UserMainScreen(),
      ),
    );
  }
}



//https://swaysafeguard.firebaseapp.com/__/auth/handler

