import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_screen.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});



  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {




  bool _hidePassword=true;

  TextEditingController _nameController= TextEditingController();
  TextEditingController _dobController= TextEditingController();
  TextEditingController _contactController= TextEditingController();
  TextEditingController _emergencycontactController= TextEditingController();
  TextEditingController _bloodgroupController= TextEditingController();
  TextEditingController _addressController= TextEditingController();

  bool _isSelected=false;

  final _formKey = GlobalKey<FormState>();

   String _selectedBloodGroup='A+';

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  bool _isLoading=false;



  ///////////////////////////////////////

  FirebaseAuth _auth= FirebaseAuth.instance;

  final fireStore= FirebaseFirestore.instance.collection('Users');

  String _email='';

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();

    setState(() {
      _email= _userData.get('email').toString();
    });

  }

  //////////////////////////////////////////

   DateTime _selectedDate= DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      });
    }
  }

  ////////////////////////////////////////////////

  final _contactNumberRegExp = RegExp(r'^0[0-9]{10}$');




  ////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _getUserData();


  }



/////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Form(
                  key: _formKey,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
      
                      const SizedBox(height: 25,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Create account',style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 28),),
                      ),
      
                      const SizedBox(height: 20,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Full Name',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 25,),
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Your Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value){
      
                            if(value==null || value.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your full name'),
                                ),
                              );
                            }
      
      
      
                          },
                        ),
                      ),
      
                      const SizedBox(height: 20,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Date of Birth',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 25,),
                        child: TextFormField(
                          controller: _dobController,
                          keyboardType: TextInputType.datetime,
                          onTap: (){
                            _selectDate(context);
                          },
                          decoration: InputDecoration(
                            hintText: 'DD/MM/YYYY',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value){
      
                            if(value==null || value.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your date of birth'),
                                ),
                              );
                            }
      
      
      
                          },
                        ),
                      ),
      
                      const SizedBox(height: 20,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Contact Number',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 25,),
                        child: TextFormField(
                          controller: _contactController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '03170691864',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value){
      
                            if(value==null || value.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your contact number'),
                                ),
                              );
                            }
                            else{
                              if(!_contactNumberRegExp.hasMatch(_contactController.text)){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your contact number in correct format'),
                                  ),
                                );
                              }
                            }
      
      
      
                          },
                        ),
                      ),
      
                      const SizedBox(height: 20,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Emergency Contact',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 25,),
                        child: TextFormField(
                          controller: _emergencycontactController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '03081469859',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value){
      
                            if(value==null || value.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your emergency contact number'),
                                ),
                              );
                            }
                            else{
                              if(!_contactNumberRegExp.hasMatch(_emergencycontactController.text)){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your emergency contact number in correct format'),
                                  ),
                                );
                              }
                            }
      
      
      
                          },
                        ),
                      ),
      
                      const SizedBox(height: 20,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Blood Group',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 25),
                        child: DropdownButtonFormField(
                          value: _selectedBloodGroup,
                          onChanged: (value) {
                            setState(() {
                              _selectedBloodGroup = value!;
                            });
                          },
                          items: _bloodGroups.map((String bloodGroup) {
                            return DropdownMenuItem(
                              value: bloodGroup,
                              child: Text(bloodGroup),
                            );
                          }).toList(),
                          decoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Select blood group',
                          ),
                        ),
                      ),
      
                      const SizedBox(height: 20,),
      
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Address',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 25,),
                        child: TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'H#1, St#,10, H-8/4, Islamabad',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value){
      
                            if(value==null || value.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your complete address'),
                                ),
                              );
                            }
      
      
      
                          },
                        ),
                      ),
      
                      const SizedBox(height: 10,),
      
                      Row(
                        children: [
      
                          Checkbox(
                            value: _isSelected,
                            onChanged: (value){
                              setState(() {
                                _isSelected=value!;
                              });
                            },
                            shape: const CircleBorder(),
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.black;
                              }
                              return Colors.transparent;
                            }),
      
                          ),
      
                          const SizedBox(width: 1,),
      
                          const Text('I accept the terms and privacy policy'),
                        ],
                      ),
      
                      const SizedBox(height: 10,),
      
                      Center(
                        child: InkWell(
                          child: Container(
                            height: 58,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:  Center(child: _isLoading==true? const CircularProgressIndicator(color: Colors.white,) : const Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                          ),
                          onTap: (){
      
      
      
      
                             if(_formKey.currentState!.validate() && _isSelected==true){
      
                               setState(() {
                                 _isLoading=true;
                               });
      
      
                               fireStore.doc(_email.toString()).update({
                                 'fullName': _nameController.text.toString(),
                                 'dob': _dobController.text.toString(),
                                 'contactNumber': _contactController.text.toString(),
                                 'emergencyContactNumber': _emergencycontactController.text.toString(),
                                 'bloodGroup':_selectedBloodGroup,
                                 'address': _addressController.text.toString(),
      
                               }).then((value) {
      
                                 setState(() {
                                   _isLoading=false;
                                 });
      
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content: Text('Data saved successfully!'),
                                   ),
                                 );
      
                               }).onError((error, stackTrace){
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content: Text('Error occured!'),
                                   ),
                                 );
                               });
      
                             }
                             else if(_isSelected==false){
      
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                   content: Text('Please accept terms and privacy policy first!'),
                                 ),
                               );
      
                             }
      
      
      
                            }
      
      
                          )
                        ),
      
      
      
      
      
      
      
      
      
      
      
      
                    ],
                  )
              ),
          ),
        )
      ),
    );
  }
}
