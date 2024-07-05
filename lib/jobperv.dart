import 'package:flutter/material.dart';

class JobDetailsScreen extends StatelessWidget {
  final String title;
  final String companyName;
  final String description;
  final int jobId;
  final String createdAt;
  final String city;
  final String salary;
  final String country;
  final String phone;
  final String jobsEmail;
  final String companyLogo;

  JobDetailsScreen({
    required this.title,
    required this.companyName,
    required this.description,
    required this.jobId,
    required this.createdAt,
    required this.city,
    required this.salary,
    required this.country,
    required this.phone,
    required this.jobsEmail,
    required this.companyLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 10.0,
            shadowColor: Color.fromRGBO(
                0, 0, 0, 0.9), // Add elevation for a shadow effect
            margin: EdgeInsets.all(15), // Add margin for spacing
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  SizedBox(height: 10),
                  Text(
                    '$title',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 25,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:  [
                            Icon(
                              Icons.event_available_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                              'Publish Date',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          ' $createdAt',
                          style: TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        '$companyName',
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Country:',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$country',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'City :',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$city',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Salary : ',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$salary',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description : ',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$description',
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  Card(
                    elevation: 5, // Add elevation for a shadow effect
                    margin: EdgeInsets.all(10),
                    shadowColor:
                        Color.fromRGBO(0, 0, 0, 0.9), // Add margin for spacing
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.all(16), // Add padding for content

                      title: Text(
                        'Contact Information',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone:',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '$phone', // Replace with the actual phone number
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email Address:',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '$jobsEmail',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors
                                  .black, // Make the URL boss na apna kol huda no baith ta sheesha pee rha boss sofa ta
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Apply button press
                          },
                          child: Text('Apply'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
