import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swaysafeguardapp/Cubit/signup_cubit.dart';
import 'package:swaysafeguardapp/Screens/login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {


  bool _hidePassword=true;

  TextEditingController _usernameController= TextEditingController();
  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();

  bool _isSelected=false;

  final _formKey = GlobalKey<FormState>();

  bool isValidEmail(String value) {
    // Regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  bool isValidUsername(String value) {
    if (value.length < 5) {
      return false;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    return true;
  }

  bool isValidPassword(String value) {
    return value.length >= 8;
  }

  bool _validEmail=false;


  bool _isLoading=false;


  ///////////////////////////////

  FirebaseAuth _auth= FirebaseAuth.instance;

  final fireStore= FirebaseFirestore.instance.collection('Users');












  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        
        
                const SizedBox(height: 100,),
        
                const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Create account',style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 28),),
              ),
        
                const SizedBox(height: 20,),
        
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Username',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 25,),
                  child: TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: const Text('Your username'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value){

                      if(value==null || value.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter username'),
                          ),
                        );
                      }
                      else{
                        if(!isValidUsername(value!)){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter valid username'),
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
                  child: Text('Email',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 25,),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: const Text('Your email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _validEmail?Icon(Icons.check_circle): Text(''),
                    ),
                    validator: (value){

                      if(value==null || value.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter email'),
                          ),
                        );

                      }
                      else{
                        if(!isValidEmail(value!)){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter valid email'),
                            ),
                          );
                        }
                      }


                      setState(() {
                        _validEmail=isValidEmail(value!);
                      });


                    },
                  ),

                ),
        
        
                const SizedBox(height: 20,),
        
        
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Password',style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 25,),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    obscuringCharacter: '*',
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      label: const Text('Your password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _hidePassword==true? InkWell(child: Icon(Icons.visibility),onTap: (){_hidePassword=false;setState(() {
        
                      });},) :InkWell(child: Icon(Icons.visibility_off),onTap: (){_hidePassword=true;setState(() {
        
                      });},),
                    ),
                    validator: (value){

                      if(value==null || value.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter password'),
                          ),
                        );

                      }
                      else{
                        if(!isValidPassword(value!)){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter password of atleast 8 characters'),
                            ),
                          );

                        }
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
        
        
                const SizedBox(height: 20,),
        
                Center(
                  child: InkWell(
                    child: Container(
                      height: 58,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:  Center(child: _isLoading==true? const CircularProgressIndicator(color: Colors.white,) : const Text('Sign up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                    ),
                    onTap: (){




                      if(_formKey.currentState!.validate() && _isSelected==true){


                        // BlocProvider.of<SignupCubit>(context).createAccount(_emailController.text.toString(), _passwordController.text.toString(), _usernameController.text.toString());
                        //
                        // bool _state= BlocProvider.of<SignupCubit>(context).state;
                        //
                        // if(_state==true){
                        //
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Account created successfully!'),
                        //     ),
                        //   );
                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogInScreen()));
                        //
                        // }
                        // else if(!_formKey.currentState!.validate() || _isSelected==false){
                        //
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Please fill all the fields correctly!'),
                        //     ),
                        //   );
                        //
                        //
                        // }





                        setState(() {
                          _isLoading=true;
                        });


                        _auth.createUserWithEmailAndPassword(
                            email: _emailController.text.toString(),
                            password: _passwordController.text.toString()
                        ).then((value){

                          setState(() {
                            _isLoading=false;
                          });

                          fireStore.doc(_emailController.text.toString()).set({
                            'userName': _usernameController.text.toString(),
                            'email': _emailController.text.toString(),
                            'fullName': '',
                            'dob': '',
                            'contactNumber': '',
                            'emergencyContactNumber': '',
                            'bloodGroup':'',
                            'address': '',
                            'latitude':'',
                            'longitude':'',
                          }).then((value) {
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


                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account Created Successfully!'),
                              backgroundColor: Colors.green,
                              showCloseIcon: true,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                            ),
                          );

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LogInScreen()));

                        }).onError((error, stackTrace){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                              backgroundColor: Colors.red,
                              showCloseIcon: true,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                            ),
                          );
                        });



                      }


                    },
                  ),
                ),
        
        
                const SizedBox(height: 150,),
        
        
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
        
                    const Text('Already have an account?'),
        
                    const SizedBox(width: 5,),
        
                    InkWell(
                        child: const Text('Log in',style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline,),),
                        onTap: (){



                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LogInScreen()));





                        },
                    ),
        
        
        
        
                  ],
                ),
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
