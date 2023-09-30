import 'package:flutter/material.dart';

import 'about.dart';
import 'jobperv.dart';
import 'mainscreen.dart';
import 'modals/Jobsmodal.dart';
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
import 'jobperv.dart';
import 'login.dart';
import 'modals/CountryModal.dart';
import 'modals/Jobsmodal.dart';
import 'modals/jobtypemodaldart.dart';
import 'modals/result.dart';

class logo extends StatefulWidget {
  const logo({super.key});

  @override
  State<logo> createState() => _logoState();
}

class _logoState extends State<logo> {
  
   int _selectedIndex = 1;

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
      final response =
          await http.get(Uri.parse('https://www.myjobsfind.com/api/countries'));
      if (response.statusCode == 200) {
        final countriesModal =
            CountryModal.fromJson(json.decode(response.body));
        setState(() {
          countries =
              countriesModal.data?.map((data) => data.name ?? "").toList() ??
                  [];
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
      final response = await http
          .get(Uri.parse('https://www.myjobsfind.com/api/cities/$countryId'));
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
      final response =
          await http.get(Uri.parse('https://www.myjobsfind.com/api/job_type'));
      if (response.statusCode == 200) {
        final jobTypeData =
            Jobtypemodaldart.fromJson(json.decode(response.body));
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

          if (jsonResponse.containsKey('jobs') &&
              jsonResponse['jobs'] is List<dynamic>) {
            final List<Map<String, dynamic>> searchResults =
                List<Map<String, dynamic>>.from(jsonResponse['jobs']);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SearchResultScreen(searchResults: searchResults),
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
            title: const Text('Error'),
            content: const Text('Please enter a job title.'),
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
        throw Exception(
            'Failed to load job description: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching job description: $e');
      return null; // Handle the error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
      appBar: AppBar(
        title: const Text('Explore Jobs'),
      ),
     body: Column(
      
      children: [
         
         SizedBox(
          height: 20,
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
                      return  Center(child: CircularProgressIndicator(
                        backgroundColor: Colors.orange,
                      ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final jobsData = snapshot.data;
                      return Scrollbar(
                         isAlwaysShown: false, // Ensure the scrollbar is always visible
                  radius:  Radius.circular(10.0), // Customize the scrollbar radius
                  thickness: 6.0,
                  
                        child: ListView.builder(
                itemCount: jobsData?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final job = jobsData!.data![index];
                  return Container(
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
                  );
                },
              )
              
                      );
                    }
                  },
                ),
              ),
            ),
      ],
     ),
    
   ),
   );
  }
}
