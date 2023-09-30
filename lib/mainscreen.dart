import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myjobsfind2/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'about.dart';
import 'jobperv.dart';
import 'login.dart';
import 'logo.dart';
import 'modals/CountryModal.dart';
import 'modals/Jobsmodal.dart';
import 'modals/jobtypemodaldart.dart';
import 'modals/result.dart';

class nextscreen extends StatefulWidget {
  const nextscreen({super.key});
  

  @override
  State<nextscreen> createState() => _nextscreenState();
}

class _nextscreenState extends State<nextscreen> {

  
    int _selectedIndex = 0;

  final List<Widget> _screens = [
    const nextscreen(),
    const logo(),
    const about(),
    MyForm(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Add navigation logic here
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => _screens[index],
    ));
  }
  DateTime? currentBackPressTime;



  String? selectedCountry;
  List<String> countries = [];
  List<String> cityNames = [];
  String? selectedCity;
  String? selectedJobType;
  List<String> jobTypes = [];
  TextEditingController jobTitleController = TextEditingController();
  String? searchJobTitle;
  bool isFilterVisible = false;

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('https://www.myjobsfind.com/api/countries'));
      if (response.statusCode == 200) {
        final countriesModal = CountryModal.fromJson(json.decode(response.body));
        setState(() {
          countries = countriesModal.data?.map((data) => data.name ?? "").toList() ?? [];
        });
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (error) {
      print('Error fetching countries: $error');
    }
  }

  Future<void> fetchCities(int countryId) async {
    try {
      final response = await http.get(Uri.parse('https://www.myjobsfind.com/api/cities/$countryId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final List<String> cities = (responseData['cities'] as List<dynamic>)
            .map((city) => city['name'].toString())
            .toList();
        setState(() {
          cityNames = cities;
        });
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching cities: $error');
    }
  }

  Future<void> fetchJobTypes() async {
    try {
      final response = await http.get(Uri.parse('https://www.myjobsfind.com/api/job_type'));
      if (response.statusCode == 200) {
        final jobTypeData = Jobtypemodaldart.fromJson(json.decode(response.body));
        setState(() {
          jobTypes = jobTypeData.jobType ?? [];
        });
      } else {
        throw Exception('Failed to load job types');
      }
    } catch (error) {
      print('Error fetching job types: $error');
    }
  }

  void searchJobs() async {
    if (searchJobTitle != null) {
      try {
        final response = await http.post(
          Uri.parse('https://www.myjobsfind.com/api/search_jobs'),
          body: {
            if (selectedCountry != null) 'country': selectedCountry!,
            if (selectedCity != null) 'city': selectedCity!,
            if (selectedJobType != null) 'job_type': selectedJobType!,
            'job_title': searchJobTitle!,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse.containsKey('jobs') && jsonResponse['jobs'] is List<dynamic>) {
            final List<Map<String, dynamic>> searchResults = List<Map<String, dynamic>>.from(jsonResponse['jobs']);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultScreen(searchResults: searchResults),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Invalid response data format'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to search for jobs.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred: $error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text('Error'),
            content: Text('Please enter a job title.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Jobsmodal? jobsData; // Declare this variable to hold your job data

  @override
  void initState() {
    super.initState();
    fetchCountries();
    fetchCities(1); // Replace 1 with the appropriate country code
    fetchJobTypes();
    _reloadData();
     _jobsFuture = fetchJobs(); // Load initial job data
  }

  Future<void> _reloadData() async {
    try {
      final newData = await fetchJobs(); // Fetch the latest data
      setState(() {
        jobsData = newData; // Update your jobsData variable
      });
    } catch (error) {
      print('Error refreshing data: $error');
    }
  }

  

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
          String successMessage =
              "Logout successfully"; // You can adjust this message
          ScaffoldMessenger.of(context).showSnackBar(
            
            SnackBar(
              content: Text(
                successMessage,
              ),
            ),
          );

          // Navigate to the login screen after logout
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

  XFile? image;

  final ImagePicker picker = ImagePicker();

  // Function to show the image picker dialog
  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Choose Image Source'),
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
                  icon: const Icon(Icons.image),
                  label: const Text('From Gallery'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text('From Camera'),
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



  Future<Jobsmodal> fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');
    final response = await http.get(
      Uri.parse('https://www.myjobsfind.com/api/jobs'),
      headers: {'Authorization': 'Bearer $userToken'},
    );
    if (response.statusCode == 200) {
      print('Response content: ${response.body}');
      return Jobsmodal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load jobs');
    }
  }

 Future<String?> fetchJobDescription(String jobId, String? userToken) async {
  if (userToken == null) {
    return null; // Handle the case when the userToken is not available
  }

  try {
    final response = await http.get(
      Uri.parse('https://www.myjobsfind.com/api/single-job/$jobId'),
      headers: {
        
        'Authorization': 'Bearer $userToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jobDetails = json.decode(response.body);

      if (jobDetails.containsKey('description')) {
        return jobDetails['description'].toString();
      } else {
        throw Exception('Description field not found in response');
      }
    } else {
      throw Exception('Failed to load job description: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching job description: $e');
    return null; // Handle the error gracefully
  }
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        SystemNavigator.pop(); // This line exits the app
        return true;
      },
       child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black, size: 30),
     
            backgroundColor: Colors.white, // Set app bar background color to white
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
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'images/job.png', // Replace with your logo image path
                    height: 35.0,
                    width: 120,
                    fit: BoxFit.cover, // Adjust the image height as needed
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
                color: const Color(0xFF157EFB),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    ? const Icon(Icons.account_circle, size: 30)
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: showImagePickerDialog,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 10,
                                    ),
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
                          String userName =
                              snapshot.data!.getString('userName') ?? 'N/A';
                          String userEmail =
                              snapshot.data!.getString('userEmail') ?? 'N/A';
     
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Name  $userName',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Email  $userEmail',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
                ListTile(
                leading: const Icon(Icons.person_2_outlined),
                title: const Text('Profile'),
               onTap: () {
              // Navigate to the second screen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  MyForm(),
              ));
            },
              ),
               const Divider(
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(Icons.person_2_outlined),
                title: const Text('Applied Jobs'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle drawer item tap
                },
              ),
              const Divider(
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log out'),
                onTap: () async {
                  logout();
                  // Navigate to login screen or any other screen
                }
                ),

              const Divider(
                thickness: 3,
              ),
            ],
          ),
        ),
        
        body: 
        
         Column(
        children: [
          
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Dream',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Jobs is waiting',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 290,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: jobTitleController,
                    decoration: InputDecoration(
                      hintText: 'Job Title',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchJobTitle = value;
                      });
                    },
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      searchJobs();
                    },
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      setState(() {
                        isFilterVisible = !isFilterVisible;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (isFilterVisible && countries.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: SearchableDropdown.single(
                items: countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                value: selectedCountry,
                hint: "Select a Country",
                searchHint: "Search for a Country",
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    selectedCity = null;
                    cityNames.clear();
                  });
                  if (value != null) {
                    final countryId = countries.indexOf(value);
                    if (countryId >= 0) {
                      fetchCities(countryId + 1);
                    }
                  }
                },
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          if (isFilterVisible && cityNames.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: SearchableDropdown.single(
                items: cityNames.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                value: selectedCity,
                hint: "Select a City",
                searchHint: "Search for a City",
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          if (isFilterVisible && jobTypes.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: SearchableDropdown.single(
                items: jobTypes.map((String jobType) {
                  return DropdownMenuItem<String>(
                    value: jobType,
                    child: Text(jobType),
                  );
                }).toList(),
                value: selectedJobType,
                hint: "Select a Job Type",
                searchHint: "Search for a Job Type",
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    selectedJobType = value;
                  });
                },
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
                width: 10,
              ),
              Text(
                'Explore Top Jobs',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.orange,
               onRefresh: _reloadData,
              child: FutureBuilder<Jobsmodal>(
                future: _jobsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final jobsData = snapshot.data;
                    return Scrollbar(
                       isAlwaysShown: false, // Ensure the scrollbar is always visible
                radius: const Radius.circular(10.0), // Customize the scrollbar radius
                thickness: 6.0,
                
                      child: ListView.builder(
                        itemCount: jobsData?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final job = jobsData!.data![index];
                          return InkWell(
                            onTap: () {
                               Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => JobDetailsScreen(
                                                    title: job.jobTitle ?? '',
                                                    companyName: job.companyName ?? '',
                                                    description: job.description ?? '',
                                                    createdAt: job.createdAt ?? '',
                                                    city: job.city ?? '',
                                                    salary: job.salary ?? '',
                                                    country: job.country ?? '',
                                                    phone: job.phone ?? '',
                                                    jobsEmail: job.jobsEmail ?? '',
                                                    companyLogo: job.companyLogo ?? '',
                                                    jobId: job.id?.toInt() ?? 0,
                                                  ),
                                                ),
                                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 2.0,
                                shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        job.jobTitle ?? '',
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.business, size: 16.0),
                                                    const SizedBox(width: 6.0),
                                                    Expanded(
                                                      child: Text(
                                                        job.companyName ?? '',
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6.0),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(Icons.my_location, size: 16.0),
                                          const SizedBox(width: 6.0),
                                          Expanded(
                                            child: Text(
                                              job.city ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12.0),
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
                                                const Icon(
                                                  Icons.event_available_rounded,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                Text(
                                                  job.jobStatus ?? '',
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 5),
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
                                                const Icon(
                                                  Icons.alarm,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                Text(
                                                  job.jobType ?? '',
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => JobDetailsScreen(
                                                    title: job.jobTitle ?? '',
                                                    companyName: job.companyName ?? '',
                                                    description: job.description ?? '',
                                                    createdAt: job.createdAt ?? '',
                                                    city: job.city ?? '',
                                                    salary: job.salary ?? '',
                                                    country: job.country ?? '',
                                                    phone: job.phone ?? '',
                                                    jobsEmail: job.jobsEmail ?? '',
                                                    companyLogo: job.companyLogo ?? '',
                                                    jobId: job.id?.toInt() ?? 0,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('Apply'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white, // Background color of the bottom navigation bar
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(50),
      topRight: Radius.circular(50),
    ), // Optional: Add rounded corners to the top
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ), // Optional: Add a shadow
    ],
  ),
  child: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home,size: 30,),
        label: 'Home',
        backgroundColor: _selectedIndex == 0 ? Colors.white : null,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search),
        label: 'Explore',
        backgroundColor: _selectedIndex == 1 ? Colors.white : null,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.filter_list),
        label: 'Filter',
        backgroundColor: _selectedIndex == 2 ? Colors.white : null,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_pin),
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

),
       
       
       
    );
    
  }
}

