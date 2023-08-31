import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myjobsfind2/registeraion.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'mainscreen.dart';

const kMyColor = Color(0x00000000dff);


class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
  
}

class _LoginState extends State<Login> {
  bool _isChecked= false;  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();





  

  void login(String email , password) async {
    
    try{
      
      Response response = await post(
        Uri.parse('https://www.myjobsfind.com/api/login'),
        body: {
          'email' : email,
          'password' : password
        }
      );

      if(response.statusCode == 200){
        
        var data = jsonDecode(response.body.toString());
        print(data);
        print('Login successfully');
      
SharedPreferences prefs = await SharedPreferences.getInstance();
  
  prefs.setString('userEmail', email);
   prefs.setString('token', data['token']);

    String successMessage = "Login successfully"; // You can adjust this message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage,),),
      );


  // Navigate to the next screen
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => nextscreen()),
  );
      }else {
      // Registration failed, handle error
      var errorData = jsonDecode(response.body);
      String errorMessage = errorData['message']; // General error message
      Map<String, dynamic> errors = errorData['errors']; // Error details

      // Display general error message
     

      // Display specific error message for 'name' field
     
       if (errors.containsKey('email')) {
        String emailError = errors['email'][0]; // First error message for 'email'
        print('Email error: $emailError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailError)),
        );
      }

      // Display specific error message for 'password' field (if applicable)
      if (errors.containsKey('password')) {
        String passwordError = errors['password'][0]; // First error message for 'password'
        print('Password error: $passwordError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(passwordError)),
        );
      }

    }

    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {

    
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            
             Padding(
               padding: const EdgeInsets.only(top: 150),
               child: Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                          height: 50,
                          width: 200,
                          child: Image.asset('images/job.png',fit: BoxFit.cover,),
                        ),
                 ],
               ),
             ),
             Container(
               height: 60,
               
               margin: const EdgeInsets.only(left: 25,right: 25,top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                
                boxShadow: [BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 3,
                  
                  color: Colors.grey.shade200,
                )]
              ),
               child: TextField(
                   controller: emailController,
                  decoration: InputDecoration(
                    
                    
                    hintText: 'Email ID',
                    
                    fillColor: Colors.white,
                    filled: true,
                    
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade500,
                        
                      ),
                      borderRadius: BorderRadius.circular(10),
                     
                      
                    )
                  ),
                ),
             ),
              Container(
                height: 55,
               margin: const EdgeInsets.only(left: 25,right: 25,top: 30),
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 3,
                  
                  color: Colors.grey.shade300,
                  
                )]
              ),
               child: TextField(
                   controller: passwordController,
                  decoration: InputDecoration(
                    
                    
                    hintText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                     
                      
                    ),
                    
                  
                  ),
                ),
             ),
              Padding(
                padding: const EdgeInsets.only(right: 10,top: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   
                  
                    Text('Forget Password?',style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      login(emailController.text.toString(), passwordController.text.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      primary: Color(0xFF157EFB),
                      onPrimary: Colors.white,
                      elevation: 1,
                    ),
                    child: Container(
                      height: 50,
                      width: 300,
                      child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

         
           
           Padding(
             padding: const EdgeInsets.only(left: 90,right: 70,top: 10),
             child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children:  [
                 Text("Don't have an account?"),
                 InkWell(
                    onTap: () {
              // Navigate to the second screen when text is clicked
              Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => registeration()),
              );
                     },
                   child: Container(child: Text('Sign Up',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),))),
               ],
             ),
           ),
          
            
          ],
        ),
        
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}