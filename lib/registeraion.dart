import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myjobsfind2/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import 'mainscreen.dart';

class registeration extends StatefulWidget {
  const registeration({super.key});

  @override
  State<registeration> createState() => _registerationState();
}

class _registerationState extends State<registeration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String nameError = '';
  String emailError = '';
  String passwordError = '';
  

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');

    // Retrieve the user token

    if (userToken != null) {
      try {
        Response response = await post(
          Uri.parse(
              'https://www.myjobsfind.com/api/logout'), // Replace with your API endpoint
          headers: {'Authorization': 'Bearer $userToken'},
        );

        if (response.statusCode == 200) {
          prefs.remove('token'); // Clear user token from SharedPreferences
          print('Logout successful');

          
          // Optionally, you can navigate to the login screen here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        } else {
          print('Logout failed: ${response.statusCode}');
        }
      } catch (e) {
        print('Error during logout: ${e.toString()}');
      }
    } else {
      print('User token not found');
    }
  }

  void login(
    String email,
    password,
    name,
  ) async {
    try {
      Response response = await post(
          Uri.parse('https://www.myjobsfind.com/api/register'),
          body: {
            'name': name,
            'email': email,
            'password': password,
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print(jsonDecode(response.body.toString()));

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', name);
        prefs.setString('userEmail', email);
        prefs.setString('token', data['token']);

        String successMessage = "User created successfully"; // You can adjust this message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage,),),
      );

        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }  else {
      // Registration failed, handle error
      var errorData = jsonDecode(response.body);
      String errorMessage = errorData['message']; // General error message
      Map<String, dynamic> errors = errorData['errors']; // Error details

      // Display general error message
      print('Registration failed: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage,selectionColor: Colors.amber,)),
      );

      // Display specific error message for 'name' field
      if (errors.containsKey('name')) {
        String nameError = errors['name'][0]; // First error message for 'name'
        print('Name error: $nameError');
        
        // Display the specific name field error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(nameError)),
        );
      }
       if (errors.containsKey('email')) {
        String emailError = errors['email'][0]; // First error message for 'email'
        print('Email error: $emailError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailError))
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 200,
                  child: Image.asset(
                    'images/job.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 60,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 40),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 3,
                    color: Colors.grey.shade200,
                  )
                ]),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 3,
                    color: Colors.grey.shade300,
                  )
                ]),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email ID',
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
          Container(
            height: 60,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 3,
                    color: Colors.grey.shade200,
                  )
                ]),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Forget Password?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    login(
                      emailController.text.toString(),
                      passwordController.text.toString(),
                      nameController.text.toString(),
                    );
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
                        'Register',
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
            padding: const EdgeInsets.only(left: 110, right: 90, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Have an account?"),
                InkWell(
                    onTap: () {
                      // Navigate to the second screen when text is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Container(
                        child: Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
