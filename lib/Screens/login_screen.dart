import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swaysafeguardapp/Cubit/login_cubit.dart';
import 'package:swaysafeguardapp/Screens/admin_main_screen.dart';
import 'package:swaysafeguardapp/Screens/signup_screen.dart';
import 'package:swaysafeguardapp/Screens/user_main_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../firebase_services.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {


  bool _hidePassword=true;

  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isValidEmail(String value) {
    // Regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  bool isValidPassword(String value) {
    return value.length >= 8;
  }

  bool _validEmail=false;


  bool _isLoading=false;



  //////////////////////////////////////

  FirebaseAuth _auth= FirebaseAuth.instance;

/////////////////////////////////////////////////////

  void _signinwithGoogle(){

    try{
      GoogleAuthProvider _googleAuthProvider= GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);

      _auth.authStateChanges().listen((event) {
        setState(() {
          _user=event;
        });
      });
    }
    catch(error){
      print(error);
    }

  }

  ////////////////////////////////


  String _userName='';
  String _name='';
  String _email='';
  String _role="";

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();

    setState(() {
      _userName= _userData.get('userName').toString();
      _name= _userData.get('fullName').toString();
      _email= _userData.get('email').toString();
      _role= _userData.get('role').toString();
    });

  }





  ///////////////////////////////

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



  }


//////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    final _height= MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 150,),

                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Log in',style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 28),),
                ),

                const SizedBox(height: 25,),

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

                      });},) :InkWell(child: const Icon(Icons.visibility_off),onTap: (){_hidePassword=true;setState(() {

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





                    },
                  ),
                ),

                const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(left: 270.0),
                  child: InkWell(
                      child: const Text('Forgot password?'),
                      onTap: (){

                      },
                  ),
                ),

                const SizedBox(height: 40,),

                Center(
                  child: InkWell(
                    child: Container(
                      height: 58,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:  Center(child: _isLoading==true? const CircularProgressIndicator(color: Colors.white,) : const Text('Log In',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                    ),
                    onTap: (){



                      // if(_formKey.currentState!.validate()){
                      //   BlocProvider.of<LoginCubit>(context).loginToAccount(_emailController.text.toString(), _passwordController.text.toString());
                      //
                      //   bool _state = BlocProvider.of<LoginCubit>(context).state;
                      //
                      //   if(_state){
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserProfileScreen()));
                      //   }
                      // }









                      if(_formKey.currentState!.validate()){

                        setState(() {
                          _isLoading=true;
                        });

                        _auth.signInWithEmailAndPassword(
                            email: _emailController.text.toString(),
                            password: _passwordController.text.toString()).then((value){

                              String? email= _user?.email;

                          if(email=="mjn7439@gmail.com"){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminMainScreen()));
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserMainScreen()));
                          }

                          setState(() {
                            _isLoading=false;
                          });


                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged In Successfully!'),
                              backgroundColor: Colors.green,
                              showCloseIcon: true,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                            ),
                          );






                        }).onError((error, stackTrace){

                          setState(() {
                            _isLoading=false;
                          });

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
                      else if(!_formKey.currentState!.validate()){
                        setState(() {
                          _isLoading=false;
                        });
                      }








                    },
                  ),
                ),

                const SizedBox(height: 40,),

                const Padding(
                  padding: EdgeInsets.only(left: 22.0),
                  child: Text('---------------------------------------- Or Login with ----------------------------------------'),
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    InkWell(
                      child: Container(
                        height: 60,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.facebook,color: Colors.blue,),
                        )
                      ),
                      onTap: (){
                        signInWithFacebook();
                      },
                    ),

                    const SizedBox(width: 10,),


                    InkWell(
                      child: Container(
                          height: 60,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 0.5,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              height: 28,
                              width: 28,
                              //fit:BoxFit.cover,
                            ),
                          ),
                      ),
                      onTap: (){

                              _signinwithGoogle();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserMainScreen()));



                      },
                    ),

                    const SizedBox(width: 10,),


                    Container(
                        height: 60,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.apple),
                        )
                    ),


                  ],
                ),








                const SizedBox(height: 50,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Text('Don\'t have an account?'),

                    const SizedBox(width: 5,),

                    InkWell(
                      child: const Text('Sign up',style: TextStyle(fontWeight: FontWeight.bold,),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccountScreen()));
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
