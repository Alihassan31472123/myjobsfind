import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'about.dart';
import 'logo.dart';
import 'mainscreen.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  
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

  int _selectedIndex = 3;
  bool _isEditing = false; // Track whether the form is in edit mode

  final List<Widget> _screens = [
    nextscreen(),
    logo(),
    about(),
    MyForm(),
  ];

  // Initialize the form values
  String jobTitle = "flutter";
  String experience = "2";
  String country = "Pakistan";
  String city = "Faisalabad";
  String address = "alihaxxan314@gmail.com";
  String qualification = "Intermediate";
  String phone = "03036294778";
  String gender = "Male";

  // Create TextEditingController for each field to enable editing
TextEditingController jobTitleController = TextEditingController();
TextEditingController countryController = TextEditingController();
TextEditingController cityController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController qualificationController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController genderController = TextEditingController();

  // Create variables to control DropdownButtonFormField
  String selectedExperience = "2";
  String selectedQualification = "Intermediate";
  String selectedGender = "Male";

  @override
  void initState() {
    super.initState();
    // Set initial values for the controllers
    jobTitleController.text = jobTitle;
    countryController.text = country;
    cityController.text = city;
    addressController.text = address;
    qualificationController.text = qualification;
    phoneController.text = phone;
    genderController.text = gender;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Add navigation logic here
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => _screens[index],
    ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        actions: [
          _isEditing
              ? IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the changes and exit edit mode
                      setState(() {
                        jobTitle = jobTitleController.text;
                        country = countryController.text;
                        city = cityController.text;
                        address = addressController.text;
                        qualification = selectedQualification;
                        phone = phoneController.text;
                        gender = selectedGender;
                        _isEditing = false;
                      });
                    }
                  },
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Enter edit mode
                    setState(() {
                      _isEditing = true;
                    });
                  },
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture Widget
                Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
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
                                      boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                   
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    
                    child: TextFormField(
                      readOnly: !_isEditing, // Enable field only in edit mode
                      controller: jobTitleController,
                      decoration: InputDecoration(labelText: 'Job Title'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a job title';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  value: selectedExperience,
                  items: const [
                    DropdownMenuItem(value: "0.5", child: Text('Less than 1 year')),
                    DropdownMenuItem(value: "1", child: Text('1 year')),
                    DropdownMenuItem(value: "2", child: Text('2 years')),
                    DropdownMenuItem(value: "3", child: Text('3 years')),
                    DropdownMenuItem(value: "4", child: Text('4 years')),
                    DropdownMenuItem(value: "5", child: Text('5 years')),
                    DropdownMenuItem(value: "6", child: Text('6 years')),
                    DropdownMenuItem(value: "7", child: Text('7 years')),
                    DropdownMenuItem(value: "8", child: Text('8 years')),
                    DropdownMenuItem(value: "9", child: Text('9 years')),
                    DropdownMenuItem(value: "10", child: Text('10 years')),
                    DropdownMenuItem(value: "10+", child: Text('10+ years')),
                  ],
                  onChanged: _isEditing
                      ? (value) {
                          setState(() {
                            selectedExperience = value.toString();
                          });
                        }
                      : null,
                ),
                TextFormField(
                  readOnly: !_isEditing,
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                ),
                TextFormField(
                  readOnly: !_isEditing,
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  readOnly: !_isEditing,
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                DropdownButtonFormField(
                  value: selectedQualification,
                  items: const [
                    DropdownMenuItem(value: "Matric", child: Text('Matric')),
                    DropdownMenuItem(value: "Intermediate", child: Text('Intermediate')),
                    DropdownMenuItem(value: "Graduation", child: Text('Graduation')),
                    DropdownMenuItem(value: "Master", child: Text('Master')),
                  ],
                  onChanged: _isEditing
                      ? (value) {
                          setState(() {
                            selectedQualification = value.toString();
                          });
                        }
                      : null,
                ),
                TextFormField(
                  readOnly: !_isEditing,
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                DropdownButtonFormField(
                  value: selectedGender,
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text('Male')),
                    DropdownMenuItem(value: "Female", child: Text('Female')),
                  ],
                  onChanged: _isEditing
                      ? (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        }
                      : null,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle form submission here
                      print('Job Title: $jobTitle');
                      print('Experience: $selectedExperience');
                      print('Country: $country');
                      print('City: $city');
                      print('Address: $address');
                      print('Qualification: $selectedQualification');
                      print('Phone: $phone');
                      print('Gender: $selectedGender');
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
          bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white, // Background color of the bottom navigation bar
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(50),
      topRight: Radius.circular(50),
    ), // Optional: Add rounded corners to the top
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 5,
        offset: Offset(0, 3),
      ), // Optional: Add a shadow
    ],
  ),
  child: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home,size: 30,),
        label: 'Home',
        backgroundColor: _selectedIndex == 0 ? Colors.white : null,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Explore',
        backgroundColor: _selectedIndex == 1 ? Colors.white : null,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.filter_list),
        label: 'Filter',
        backgroundColor: _selectedIndex == 2 ? Colors.white : null,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_pin),
        label: 'Profile',
        backgroundColor: _selectedIndex == 3 ? Colors.white : null,
      ),
    ],
    currentIndex: _selectedIndex,
    selectedItemColor: Colors.orange,
    unselectedItemColor: Colors.black,
    onTap: _onItemTapped,
  ),
),
      // Bottom Navigation Bar...
    );
  }
}
