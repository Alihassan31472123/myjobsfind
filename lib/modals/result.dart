import 'package:flutter/material.dart';

import '../jobperv.dart';

class SearchResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  SearchResultScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Future.value(searchResults),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Map<String, dynamic>> jobsData = snapshot.data!;
            if (jobsData.isNotEmpty) {
              return Scrollbar(
                child: ListView(
                  children: jobsData.map((job) {
                    return Container(
                      margin: EdgeInsets.all(10),
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
                      child: InkWell(
                        onTap: () {
                           Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => JobDetailsScreen(
                                            title: job['job_title'] ?? '',
                                            companyName: job['company_name'] ?? '',
                                            description: job['description'] ?? '',
                                            createdAt: job['created_at'] ?? '',
                                            city: job['city'] ?? '',
                                            salary: job['salary'] ?? '',
                                            country: job['country'] ?? '',
                                            phone: job['phone'] ?? '',
                                            jobsEmail: job['jobs_email'] ?? '',
                                            companyLogo : job['companyLogo'] ?? '',
                                            jobId: job['id']?.toInt() ?? 0,
                                          ),
                                        ),
                                      );
                        },
                        child: Card(
                          elevation: 2,
                          shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
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
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  job['job_title'] ?? '',
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
                                            job['company_name'] ?? '',
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
                                        job['city'] ?? '',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.event_available_rounded,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          Text(
                                            job['job_status'] ?? '',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.alarm,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          Text(
                                            job['job_type'] ?? '',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailsScreen(
                                              title: job['job_title'] ?? '',
                                              companyName: job['company_name'] ?? '',
                                              description: job['description'] ?? '',
                                              createdAt: job['created_at'] ?? '',
                                              city: job['city'] ?? '',
                                              salary: job['salary'] ?? '',
                                              country: job['country'] ?? '',
                                              phone: job['phone'] ?? '',
                                              jobsEmail: job['jobs_email'] ?? '',
                                              companyLogo : job['companyLogo'] ?? '',
                                              jobId: job['id']?.toInt() ?? 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Apply job'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
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
                  }).toList(),
                ),
              );
            } else {
              return Center(child: Text('No results found.'));
            }
          }
        },
      ),
    );
  }
}
