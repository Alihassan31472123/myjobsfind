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
  bool _isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailErrorText = '';
  String passwordErrorText = '';
  bool showPassword = false;

  void clearErrorMessages() {
    setState(() {
      emailErrorText = '';
      passwordErrorText = '';
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  

  bool isLoading = false; // Add this variable to track loading state

void login(String email, String password) async {
  setState(() {
    isLoading = true; // Show the circular progress indicator
  });

  try {
    Response response = await post(
      Uri.parse('https://www.myjobsfind.com/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Login successful
      var data = jsonDecode(response.body.toString());
      print(data);
      print('Login successfully');

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('userEmail', email);
      prefs.setString('token', data['token']);

      String successMessage = "Login successfully";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.orange,
        ),
      );

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextscreen()),
      );
    } else if (response.statusCode == 401) {
      // Handle 401 unauthorized error
      var errorData = jsonDecode(response.body);
      Map<String, dynamic> message = errorData['message'] ?? {};

      message.forEach((field, errorList) {
        errorList.forEach((error) {
          print('$field error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$field $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        });
      });
    } else {
      // Handle other error cases
      var errorData = jsonDecode(response.body);
      String errorMessage = errorData['message']; // General error message
      Map<String, dynamic> errors = errorData['errors']; // Error details

      // Display general error message

      // Display specific error message for 'email' field
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
  } catch (e) {
    print(e.toString());
  } finally {
    setState(() {
      isLoading = false; // Hide the circular progress indicator
    });
  }
}


  @override
  Widget build(BuildContext context) {

    
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            
             Padding(
               padding: const EdgeInsets.only(top: 120),
               child: Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                          height: 45,
                          width: 190,
                           decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
                          child: Image.asset('images/job.png',fit: BoxFit.cover,),
                        ),
                 ],
               ),
             ),
             SingleChildScrollView(
               child: Column(
                 children: [
                  SizedBox(
                    height: 30,
                  ),
                   Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                     child: TextField(
                      
                       controller: emailController,
                       decoration: InputDecoration(
                        
                         hintText: 'Email',
                         fillColor: Colors.white,
                         filled: true,
                          prefixIcon: Icon(Icons.mail),
                         
                         errorText:
                             emailErrorText.isNotEmpty ? emailErrorText : null,
                       ),
                     ),
                   ),
                   SizedBox(height: 30),
                   
                 ],
               ),
             ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                         prefixIcon: Icon(Icons.lock),
                       errorText:
                            passwordErrorText.isNotEmpty ? passwordErrorText : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                ],
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
  onPressed: isLoading
      ? null // Disable the button when loading
      : () {
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
             MaterialPageRoute(builder: (context) => Registeration()),
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
