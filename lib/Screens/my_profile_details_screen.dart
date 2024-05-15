import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileDetailsScreen extends StatefulWidget {
  const MyProfileDetailsScreen({super.key});

  @override
  State<MyProfileDetailsScreen> createState() => _MyProfileDetailsScreenState();
}

class _MyProfileDetailsScreenState extends State<MyProfileDetailsScreen> {


  final _auth= FirebaseAuth.instance;

  /////////////////////////////////////////

  String _userName='';
  String _fullName='';
  String _email='';
  String _role="";
  String _dob='';
  String _contactNumber='';
  String _emergencyContactNumber='';
  String _address='';
  String _bloodGroup='';

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();

    setState(() {
      _userName= _userData.get('userName').toString();
      _fullName= _userData.get('fullName').toString();
      _email= _userData.get('email').toString();
      _role= _userData.get('role').toString();
      _dob= _userData.get('dob').toString();
      _contactNumber= _userData.get('contactNumber').toString();
      _emergencyContactNumber= _userData.get('emergencyContactNumber').toString();
      _address= _userData.get('address').toString();
      _bloodGroup= _userData.get('bloodGroup').toString();
    });

  }





  ///////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _getUserData();
  }



  ///////////////////////////////////

  

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const SizedBox(height: 50,),

            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQq6gaTf6N93kzolH98ominWZELW881HqCgw&s'),
              ),
            ),


            SizedBox(height: 10,),

            Center(child: Text(_fullName,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),

            const Divider(),

            SizedBox(height: 10,),
















          ],
        ),
      ),
    );
  }
}
