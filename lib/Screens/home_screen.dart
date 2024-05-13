import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swaysafeguardapp/Screens/signup_screen.dart';
import 'package:swaysafeguardapp/Screens/user_main_screen.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  // @override
  // void initState(){
  //   super.initState();
  //
  //   final _auth= FirebaseAuth.instance;
  //   final user= _auth.currentUser;
  //
  //   if(user!=null) {
  //     Timer(const Duration(microseconds: 1), () {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (_) => const UserProfileScreen()),
  //       );
  //     });
  //   }
  // }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

           const SizedBox(height: 90,),

            const Center(child: Text('EasySafe',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold, fontSize: 35),)),

            const SizedBox(height: 220,),

            const Center(child: Text('Explore the app',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 30),)),

            const SizedBox(height: 10,),

            const Center(child: Text('For the safety of your loved ones.',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.normal, fontSize: 18),)),

            const SizedBox(height: 20,),
            
            
            

            InkWell(
              child: Container(
                height: 58,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('Sign In',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogInScreen()));
              },
            ),
            
            
            
            
            
            
            const SizedBox(height: 15,),

            InkWell(
              child: Container(
                height: 58,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5
                  ),
                ),
                child: const Center(child: Text('Create account',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccountScreen()));
              },
            ),
            
            
            
            const SizedBox(height: 10,),

            Container(
              height: 58,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.black,
                    width: 0.5
                ),
              ),
              child: const Center(child: Text('Create account as user',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),),
            ),
            const SizedBox(height: 10,),
        

        
        
        
        
        
        
        
        
        
        
          ],
        ),
      ),
    );
  }
}
