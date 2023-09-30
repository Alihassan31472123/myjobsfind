import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myjobsfind2/login.dart';
import 'package:myjobsfind2/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registeration extends StatefulWidget {
  const Registeration({Key? key}) : super(key: key);

  @override
  State<Registeration> createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // Remove these error variables since they are not being used
   String nameErrorText = '';
    String emailErrorText = '';
  String passwordErrorText = '';
  bool showPassword = false;

  void clearErrorMessages() {
    setState(() {
      emailErrorText = '';
      passwordErrorText = '';
       nameErrorText = '';

    });
  }

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');

    // Retrieve the user token
    if (userToken != null) {
      try {
        final response = await http.post(
          Uri.parse('https://www.myjobsfind.com/api/logout'), // Replace with your API endpoint
          headers: {'Authorization': 'Bearer $userToken'},
        );

        if (response.statusCode == 200) {
          prefs.remove('token'); // Clear user token from SharedPreferences
          String successMessage = "Log out Successfully";
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(successMessage),
     
    ),
  );
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

void register(
  String email,
  String password,
  String name,
) async {

  try {
    final response = await http.post(
      Uri.parse('https://www.myjobsfind.com/api/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(response.body);

      if (data.containsKey('Token')) {
        String token = data['Token'];
        print('Token: $token');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', name);
        prefs.setString('userEmail', email);
        prefs.setString('token', token);
        String successMessage = "User created successfully";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextscreen()),
        );
      }
    } else if (response.statusCode == 401) {
      var errorData = jsonDecode(response.body);
      Map<String, dynamic> message = errorData['message'] ?? {};
      
      message.forEach((field, errorList) {
        errorList.forEach((error) {
          print('$field error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$field $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
      });
    } else {
      var errorData = jsonDecode(response.body);
      String errorMessage = errorData['message'] ?? 'Unknown error';
      Map<String, dynamic> errors = errorData['errors'] ?? {};

      print('Registration failed: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.amber,
        ),
      );

      errors.forEach((field, errorList) {
        errorList.forEach((error) {
          print('$field error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$field error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred during registration'),
        backgroundColor: Colors.red,
      ),
    );
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
                          height: 60,
                          width: 210,
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
                        ),              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  
                  margin: EdgeInsets.only(left: 30,right: 30),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      fillColor: Colors.white,
                      filled: true,
                       prefixIcon: Icon(Icons.person),
                      errorText:
                                   nameErrorText.isNotEmpty ? nameErrorText : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30,right: 30),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email ID',
                      fillColor: Colors.white,
                      filled: true,
                       prefixIcon: Icon(Icons.mail),
                       errorText:
                                   emailErrorText.isNotEmpty ? emailErrorText : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
            padding: const EdgeInsets.only(right: 10, top: 20),
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
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    register (
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
            padding: const EdgeInsets.only(left: 110, right: 90, top: 20),
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
