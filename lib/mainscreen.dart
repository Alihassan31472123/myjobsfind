import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import 'login.dart';
import 'modals/Jobsmodal.dart';
import 'modals/posts_model.dart';



class nextscreen extends StatefulWidget {
  const nextscreen({super.key});

  @override
  State<nextscreen> createState() => _nextscreenState();
}

class _nextscreenState extends State<nextscreen> {



 

  var newData;


void logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('token');

  if (userToken != null) {
    try {
      Response response = await get(
        Uri.parse('https://www.myjobsfind.com/api/logout'),
        headers: {'Authorization': 'Bearer $userToken'},
      );

      if (response.statusCode == 200) {
        prefs.remove('token');
        print('Logout successful');

          String successMessage = "Logout successfully"; // You can adjust this message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage,),),
      );
      
        // Navigate to the login screen after logout
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
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





  XFile? image;

  final ImagePicker picker = ImagePicker();

  // Function to show the image picker dialog
  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('Choose Image Source'),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text('From Gallery'),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('From Camera'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to pick an image from gallery or camera
  Future getImage(ImageSource source) async {
    var img = await picker.pickImage(source: source);
    if (img != null) {
      setState(() {
        image = img;
      });
    }
  }




 late Future<Jobsmodal> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = fetchJobs();
  }
Future<Jobsmodal> fetchJobs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('token');
  final response = await http.get(Uri.parse('https://www.myjobsfind.com/api/jobs'),
   headers: {'Authorization': 'Bearer $userToken'},
  );
  if (response.statusCode == 200) {
    print('Response content: ${response.body}');
    return Jobsmodal.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load jobs');
  }
}

Future<List<PostsModel>> getPostApi() async {
    try {
      final response =
          await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return PostsModel(
            id: map['id'] as int,
            title: map['title'] as String,
            body: map['body'] as String,
          );
        }).toList();
      }
    } on SocketException {
      await Future.delayed(const Duration(milliseconds: 1800));
      throw Exception('No Internet Connection');
    } on TimeoutException {
      throw Exception('');
    }
    throw Exception('error fetching data');
  }

  var selectedId;
  var selectedTitle;
  var selectedBody;


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white,size: 30), 
          
          backgroundColor: Colors.blue,// Set app bar background color to white
          centerTitle: true,
          title: Row(
            children: [
              Container(
                 decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0), // changes the position of the shadow
          ),
        ],
      ),
                child: Image.asset(
                  'images/job.png', // Replace with your logo image path
                  height: 35.0,
                  width: 120,fit: BoxFit.cover, // Adjust the image height as needed
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              color: Color(0xFF157EFB),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                         Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                    Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Placeholder color
                    image: image != null
                        ? DecorationImage(
                            image: FileImage(File(image!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    ),
                    child: image == null
                      ? Icon(Icons.account_circle, size: 30)
                      : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                    onTap: showImagePickerDialog,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.camera_alt,size: 10,),
                    ),
                      ),
                    ),
                              ],
                            ),
                      ],
                    ),
                  ),
                   FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String userName = snapshot.data!.getString('userName') ?? 'N/A';
            String userEmail = snapshot.data!.getString('userEmail') ?? 'N/A';

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Name  $userName',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Email  $userEmail',style: TextStyle(color: Colors.white),),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
                ],
              ),
            ),
          
           
            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text('Applied Jobs'),
              onTap: () {
                Navigator.pop(context);
                // Handle drawer item tap
              },
            ),
            Divider(
              thickness: 3,
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Log out'),
              onTap: ()async {
    logout();
    // Navigate to login screen or any other screen
  },
            ),
            Divider(
              thickness: 3,
            ),
          ],
        ),
      ),
     body:
     
     Column(
  children: [
    FutureBuilder<List<PostsModel>>(
      future: getPostApi(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton(
                  // Initial Value
                  value: selectedId,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Job,Title,Company Name'),
                  ),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: snapshot.data!.map((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(item.id.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedId = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 5),
             Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton(
                  // Initial Value
                  value: selectedId,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Job type'),
                  ),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: snapshot.data!.map((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(item.id.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedId = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton(
                  // Initial Value
                  value: selectedId,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Country'),
                  ),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: snapshot.data!.map((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(item.id.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedId = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton(
                  // Initial Value
                  value: selectedId,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('City'),
                  ),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: snapshot.data!.map((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(item.id.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedId = value;
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    ),
    SizedBox(height: 10),
    Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Add your search logic here
        },
        child: Text('Search'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          minimumSize: Size(100, 50),
        ),
      ),
    ),
    SizedBox(
      height: 10,
    ),
    
     Expanded(
       child: FutureBuilder<Jobsmodal>(
        future: _jobsFuture,
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final jobsData = snapshot.data;
          return ListView.builder(
              itemCount: jobsData?.data?.length ?? 0,
              itemBuilder: (context, index) {
                final job = jobsData!.data![index];
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Card(
       elevation: 8.0,
       shadowColor: Color.fromRGBO(0, 0, 0, 0.8),
       child: Padding(
         padding: EdgeInsets.all(15),
         child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  'https://www.myjobsfind.com/frontend/assets/images/no-pic.webp',
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Flexible( // Wrap with Flexible
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            job.jobTitle ?? '',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      job.companyName ?? '',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 6.0),
          Row(
            children: [
              Icon(Icons.my_location, size: 16.0),
              SizedBox(width: 6.0),
              Expanded(
                child: Text(
                  job.city ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            children: [
              Container(
                height: 25,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.event_available_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      job.jobStatus ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Container(
                height: 25,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      job.jobType ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle Apply Job button tap
                },
                child: Text('Apply Job'),
              ),
            ],
          ),
        ],
         ),
       ),
     ),
     
                  );
        
              },
            );
        }
        },
         ),
     ),

    
  ],
),
      
    );
  }
}





