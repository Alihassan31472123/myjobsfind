import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:myjobsfind2/modals/result.dart';

import 'CountryModal.dart';
import 'jobtypemodaldart.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String? selectedCountry;
  List<String> countries = [];
  List<String> cityNames = [];
  String? selectedCity;
  String? selectedJobType;
  List<String> jobTypes = [];
  TextEditingController jobTitleController = TextEditingController();
  String? searchJobTitle;
  bool isFilterVisible = false;
  
   // Track whether the filter dropdowns are visible

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('https://www.myjobsfind.com/api/countries'));
      if (response.statusCode == 200) {
        final countriesModal = CountryModal.fromJson(json.decode(response.body));
        setState(() {
          countries = countriesModal.data?.map((data) => data.name ?? "").toList() ?? [];
        });
      }
       else {
        throw Exception('Failed to load countries');
      }
    }
     catch (error) {
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
                  title: Text('Error'),
                  content: Text('Invalid response data format.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
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
                title: Text('Error'),
                content: Text('Failed to search for jobs.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
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
              title: Text('Error'),
              content: Text('An error occurred: $error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
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
            title: Text('Error'),
            content: Text('Please enter a job title.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCountries();
    fetchCities(1); // Replace 1 with the appropriate country code
    fetchJobTypes();
  }

  void showCountryDropdown() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Country'),
          content: Container(
            width: 300,
            height: 300,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return ListTile(
                    title: Text(country),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        selectedCountry = country;
                        selectedCity = null;
                        cityNames.clear();
                      });
                      if (country != null) {
                        final countryId = countries.indexOf(country) + 1;
                        fetchCities(countryId);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showCityDropdown() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a City'),
          content: Container(
            width: 300,
            height: 300,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: cityNames.length,
                itemBuilder: (context, index) {
                  final city = cityNames[index];
                  return ListTile(
                    title: Text(city),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        selectedCity = city;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showJobTypeDropdown() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Job Type'),
          content: Container(
            width: 300,
            height: 100,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: jobTypes.length,
                itemBuilder: (context, index) {
                  final jobType = jobTypes[index];
                  return ListTile(
                    title: Text(jobType),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        selectedJobType = jobType;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country, City, and Job Type Selector'),
       
      ),
      body: ListView(
       
        children: [
         
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 290,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
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
                ),
              ),
               IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Toggle the visibility of the filter dropdowns
              setState(() {
                isFilterVisible = !isFilterVisible;
              });
            },
          ),
            ],
          ),
          
          SizedBox(
            height: 10,
          ),
          // Dropdowns are shown/hidden based on isFilterVisible
          if (isFilterVisible) ...[
  SearchableDropdown.single(
  items: (countries.isNotEmpty)
      ? countries.map((String country) {
          return DropdownMenuItem<String>(
            value: country,
            child: Text(country),
          );
        }).toList()
      : [DropdownMenuItem<String>(value: null, child: Text('Loading...'))],
  value: selectedCountry,
  hint: "Select a Country",
  searchHint: "Search for a Country",
  isExpanded: true,
  onChanged: (value) {
    setState(() {
      if (countries.contains(value)) {
        selectedCountry = value;

        // Clear selected city when the country changes
        selectedCity = null;
        cityNames.clear();

        if (value != null) {
          final countryId = countries.indexOf(value);
          if (countryId >= 0) {
            fetchCities(countryId + 1);
          }
        }
      } else {
        // Handle the case where the selected country is not found in the list.
        // You can show an error message or take appropriate action.
        print('Selected country is not in the list.');
      }
    });
  },
),


            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: SearchableDropdown.single(
                items: (cityNames.isNotEmpty)
                    ? cityNames.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList()
                    : [
                        DropdownMenuItem<String>(
                            value: null,
                            child: Text('Select a Country first'))
                      ], // Provide a message if cityNames is empty
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
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: SearchableDropdown.single(
                items: (jobTypes.isNotEmpty)
                    ? jobTypes.map((String jobType) {
                        return DropdownMenuItem<String>(
                          value: jobType,
                          child: Text(jobType),
                        );
                      }).toList()
                    : [
                        DropdownMenuItem<String>(
                            value: null, child: Text('Loading...'))
                      ], // Provide a loading item if jobTypes is empty
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
          ],
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 50,
            child: ElevatedButton(
              onPressed: searchJobs,
              child: Text('Search'),
            ),
          ),
        ],
      ),
    );
  }
}
