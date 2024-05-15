import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swaysafeguardapp/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swaysafeguardapp/Screens/edit_profile_details_screen.dart';
import 'package:swaysafeguardapp/Screens/utilils.dart';

import 'admin_main_screen.dart';
import 'change_password_screen.dart';
import 'my_profile_details_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {


  FirebaseAuth _auth= FirebaseAuth.instance;



///////////////////////////////////////////////////
  final Completer<GoogleMapController> _mapController =Completer<GoogleMapController>();

  LatLng _initialCameraPosition = LatLng(33.09188702412846, 72.24164574110249);








///////////////////////////////

  String _userName='';
  String _name='';
  String _email='';

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();

    setState(() {
      _userName= _userData.get('userName').toString();
      _name= _userData.get('fullName').toString();
      _email= _userData.get('email').toString();

    });

  }

  /////////////////////////////////

  //GoogleAuthProvider _googleAuthProvider= GoogleAuthProvider();

  User? _user;

  @override
  void initState() {
    super.initState();

    _getUserData();



    _auth.authStateChanges().listen((event) {
      setState(() {
        _user=event;
      });
    });

    _getUserLocation();



  }

  ////////////////////////////////////

  final fireStore= FirebaseFirestore.instance.collection('Users');



  ///////////////////////////

  Future<void> _deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      //Utilis().toastMessage('Your account has been deleted successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account has been deleted successfully!'),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LogInScreen()));
    } catch (e) {
      Utilis().toastMessage(e.toString());
    }
  }



  //////////////////////


 bool _detectionEnabled=true;
  bool _locationEnabled=true;


  //////////////////////



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Center(child: Text('${_name?[0]}'),),
                ),
                accountName: Text('$_name'),
                accountEmail: Text('$_email'),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyProfileDetailsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileDetailsScreen()));

                },
              ),

              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Account'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmation !'),
                          content: const Text(
                              'Are you sure you want to delete your account?'),
                          actions: [
                            TextButton(
                              onPressed: () {

                                //_deleteAccount();

                                FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).delete();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Your account and all its data have deleted!'),
                                  ),
                                );

                                Navigator.pop(context);
                              },
                              child: const Text('DELETE'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('NO'),
                            ),
                          ],
                        );
                      }
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () {
                  _auth.signOut();

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogInScreen()));


                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account Logged out successfully!'),
                      backgroundColor: Colors.green,
                      showCloseIcon: true,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      dismissDirection: DismissDirection.horizontal,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body:SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                const SizedBox(height: 10,),
          
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Welcome, $_userName',style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 28),),
                    ),
          

                  ],
                ),
          
                const SizedBox(height: 40,),
          
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Nearby Users',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 15),),
                ),
          
                const SizedBox(height: 5,),
          
          
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    height: 500,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown,
                    ),
                    child:  GoogleMap(
                      zoomControlsEnabled: false,
                      onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                        initialCameraPosition: CameraPosition(
                          target: _initialCameraPosition,
                          zoom: 10,
                        ),
          
                      markers: {
          
                        Marker(
                          markerId: const MarkerId('_userCurrentPosition',),
                          icon: BitmapDescriptor.defaultMarker,
                          position: _initialCameraPosition,
                          infoWindow: const InfoWindow(title: 'User Current Location'),
                        ),
          
          
                      },
          
                    ),
          
                  ),
                ),
          
                const SizedBox(height: 15,),
          
          
                 Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
          
                      Text('Fall Detection Sensor',style: TextStyle(fontWeight: FontWeight.bold),),
          
                      const SizedBox(width: 180,),
          
                      Switch(
                        value: _detectionEnabled,
                        onChanged: (value) {
                          setState(() {
                            _detectionEnabled = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
          
          
          
                    ],
                  ),
                ),
          
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
          
                      const Text('Live Location',style: TextStyle(fontWeight: FontWeight.bold),),
          
                      const SizedBox(width: 222,),
          
                      Switch(
                        value: _locationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _locationEnabled = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
          
          
          
                    ],
                  ),
                ),
          
                const SizedBox(height: 5,),
          
                Center(
                  child: InkWell(
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:  const Center(child:  Text('Share Location Now',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                    ),
          
                  ),
                ),
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
              ],
            ),
          ),
        ),
      
      ),
    );
  }
  /////////////////////////////////////////////////////

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied'),
        ),
      );
      openAppSettings();
      return;
    }
    else if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied'),
        ),
      );
      openAppSettings();
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _initialCameraPosition = LatLng(position.latitude, position.longitude);
      _cameraToPosition(_initialCameraPosition);
    });


    LocationController().getLocationController().onLocationChanged
        .listen((LocationData currentLocation) {

      if (currentLocation.latitude != null && currentLocation.longitude != null) {

        if(_locationEnabled==true){
          setState(() {
            _initialCameraPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(_initialCameraPosition!);

            fireStore.doc(_auth.currentUser?.email).update({
              'latitude':_initialCameraPosition.latitude.toString(),
              'longitude': _initialCameraPosition.longitude.toString(),
            });

          }
          );
        }

      }

    });





  }
  ////////////////////////////////////////////

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 10,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }




////////////////////////////////////////////////////////
}
