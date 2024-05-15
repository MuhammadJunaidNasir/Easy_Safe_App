import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {


  //////////////////////////////////////////////////////////////////
  TextEditingController _emailController= TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _validEmail=false;

  bool isValidEmail(String value) {
    // Regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }



  //////////////////////////////////////

  FirebaseAuth _auth= FirebaseAuth.instance;




  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 250,),

            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Your Email',style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            const SizedBox(height: 5,),
        
        
            Form(
              key: _formKey,
              child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 25,),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Your Email',
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
                    else if(isValidEmail(value!)){
                      setState(() {
                        _validEmail=isValidEmail(value!);
                      });
                    }
                  }
        
        

        
        
                },
              ),
        
            ),
            ),

            const SizedBox(height: 50,),

            Center(
              child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate() && _validEmail==true){
                      
                      _auth.sendPasswordResetEmail(email: _emailController.text.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password reset link has been sent to your provided email address!'),
                        ),
                      );

                      Navigator.pop(context);
                      Navigator.pop(context);

                    }

                  },
                  child: const Text('Send Password Recovery Email',style: TextStyle(fontWeight: FontWeight.bold),)
              ),
            ),
        
        
        
        
          ],
        ),
      ),
    );
  }
}
