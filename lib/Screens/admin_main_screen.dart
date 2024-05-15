import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swaysafeguardapp/Screens/change_password_screen.dart';
import 'package:swaysafeguardapp/Screens/login_screen.dart';
import 'package:swaysafeguardapp/Screens/edit_profile_details_screen.dart';
import 'package:swaysafeguardapp/Screens/my_profile_details_screen.dart';
import 'package:swaysafeguardapp/Screens/utilils.dart';

import 'consts.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:http/http.dart' as http;

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {


  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ////////////////////////////////////



  static LatLng _destinationPosition= LatLng(33.724165079392364, 73.0385514382392);

  //Location _locationController= new Location();

  LatLng _initialCameraPosition = LatLng(33.09188702412846, 72.24164574110249);



  //////////////////////////////////////////


  final Completer<GoogleMapController> _mapController =Completer<GoogleMapController>();


  Map<PolylineId, Polyline> polylines = {};

  /////////////////////////////////

  final fireStore= FirebaseFirestore.instance.collection('Users');

  ///////////////////////////////////////////////

  //Near by Users

  List<Marker> _markers = [];





  ////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////

  double? _distance;

  Future<void> getRouteDistance(double startLat, double startLng, double endLat, double endLng) async {
    final apiKey = 'AIzaSyDaWT_X1Bz0R4T-2LkN3Ay5DHyJVLs-YGI';


    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final route = data['routes'][0];
      final legs = route['legs'][0];
      final distance = legs['distance']['value']; // Distance in meters
      setState(() {
        _distance=distance;
      });

    }
    else {
      throw Exception('Failed to fetch route data');
    }
  }


///////////////////////////////////////////////////////////////////////////////

double? distance;



  ////////////////////////////////////////////////////////////

  Position? _adminPosition;

  String? _name;
  String? _email;
  String? _role;

  void _fetchUsersLocations() async {
    // Fetch user locations from Firestore
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

    // Iterate through each user and add a marker for their location
    for (var userSnapshot in usersSnapshot.docs) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      double latitude = double.parse(userData['latitude']);
      double longitude = double.parse(userData['longitude']);
       _name = userData['fullName'];
       _email = userData['email'];
       _role = userData['role'];

      _adminPosition= await Geolocator.getCurrentPosition();




       distance=  Geolocator.distanceBetween(_adminPosition!.latitude, _adminPosition!.longitude, latitude, longitude);


         // LatLng _userPosition= LatLng(latitude, longitude);
         //
         //  getRouteDistance(_adminPosition!.latitude, _adminPosition!.longitude, _userPosition.latitude, _userPosition.longitude);


      _markers.add(
        Marker(
          markerId: MarkerId(_name!),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: _name,
            snippet: _role=='admin'? '': '${(distance!/1000)?.toInt()} KM Away',

          ),
          visible: true,
        ),
      );

    }

    setState(() {

    });

  }




  /////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _getUserLocation();

    _fetchUsersLocations();









  }

  FirebaseAuth _auth= FirebaseAuth.instance;

  ////////////////////////////

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







//////////////////////////////////
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
              // ListTile(
              //   leading: const Icon(Icons.delete),
              //   title: const Text('Delete Account'),
              //   onTap: () {
              //     showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             title: const Text('Confirmation !'),
              //             content: const Text(
              //                 'Are you sure you want to delete your account?'),
              //             actions: [
              //               TextButton(
              //                 onPressed: () {
              //                   _deleteAccount();
              //                   Navigator.pop(context);
              //                 },
              //                 child: const Text('DELETE'),
              //               ),
              //               TextButton(
              //                 onPressed: () {
              //                   Navigator.pop(context);
              //                 },
              //                 child: const Text('NO'),
              //               ),
              //             ],
              //           );
              //         }
              //     );
              //   },
              // ),
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
        body: Container(
          child:   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              const SizedBox(height: 35,),

      
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Welcome, Admin',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
              ),


      
               const SizedBox(height: 10,),
      
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Nearby Users',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 15),),
              ),
      
              const SizedBox(height: 5,),
      
      
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GoogleMap(
                      zoomControlsEnabled: false,
                      onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                      initialCameraPosition: CameraPosition(
                        target: _initialCameraPosition,
                        zoom: 8,
                      ),

                    markers: Set<Marker>.of(_markers),
                    //polylines: Set<Polyline>.of(polylines.values),
                    circles: {

                      Circle(
                        circleId: const CircleId('circleId'),
                        center:  _initialCameraPosition,
                        fillColor: Colors.blue.withOpacity(0.4),
                        radius: 2000,
                        strokeWidth: 1,
                        strokeColor: Colors.blue,
                      ),

                    },






                  ),
                ),
              ),

              const SizedBox(height: 25,),

              Center(
                child: InkWell(
                  child: Container(
                    height: 58,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  const Center(child:  Text('General Emergency',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                  ),

                ),
              ),

              const SizedBox(height: 5,),

              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Recent Notifications',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 15),),
              ),

              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),

              Expanded(
                child: FutureBuilder(
                  // Fetch data from Firestore collection 'Users'
                  future: FirebaseFirestore.instance.collection('Users').get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    // Check if the connection is in waiting state
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }
                    // Check if there's an error
                     if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    // If data is available
                    else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // Get user data from each document
                          DocumentSnapshot user = snapshot.data!.docs[index];
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.blue,radius: 25,child: Center(child: Text('${user['fullName'][0]}',style: TextStyle(color: Colors.white),),),),
                            title: Text(user['fullName']),
                            subtitle: Text(user['address']),
                            trailing: Text('Today \n ${DateTime.now().hour}:${DateTime.now().minute}'),
                          );
                        }, // itemBuilder
                      ); // ListView.builder
                    }
                  }, // builder
                ),
              ),
      

            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items:  <BottomNavigationBarItem>[

            const BottomNavigationBarItem(
              icon: Icon(Icons.add_location_alt_outlined),
              label: 'Location',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  child: const Icon(Icons.power_settings_new),
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation !'),
                            content: const Text(
                                'Are you sure you want to logout to your account?'),
                            actions: [
                              TextButton(
                                onPressed: () {

                                  _auth.signOut().then((value){

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogInScreen()));
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Logged out successfully!!'),
                                        backgroundColor: Colors.green,
                                        showCloseIcon: true,
                                        duration: Duration(seconds: 3),
                                        behavior: SnackBarBehavior.floating,
                                        dismissDirection: DismissDirection.horizontal,
                                      ),
                                    );
                                  });

                                  Navigator.pop(context);
                                },
                                child: const Text('Logout'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        }
                    );
                  },
              ),
              label: 'Logout',
            ),
            
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.shifting,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////
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


    });


    LocationController().getLocationController().onLocationChanged
        .listen((LocationData currentLocation) {

      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _initialCameraPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_initialCameraPosition!);


          fireStore.doc(_auth.currentUser?.email).update({
            'latitude':_initialCameraPosition.latitude.toString(),
            'longitude': _initialCameraPosition.longitude.toString(),
          });



        });
      }

    });





  }
///////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_initialCameraPosition.latitude, _initialCameraPosition.longitude),
      PointLatLng(_destinationPosition.latitude, _destinationPosition.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }
///////////////////////////////////////////////////////


  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.deepPurple,
        points: polylineCoordinates,
        width: 4,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  ///////////////////////////////////////



///////////////////////////////////////////////////////
}
////////////////////////////

class LocationController {
  static final LocationController _instance = LocationController._internal();
  final Location _locationController = Location();

  factory LocationController() {
    return _instance;
  }

  LocationController._internal();

  Location getLocationController() {
    return _locationController;
  }
}






