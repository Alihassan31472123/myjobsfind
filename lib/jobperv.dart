import 'package:flutter/material.dart';

class jobperv extends StatefulWidget {
  const jobperv({super.key});

  @override
  State<jobperv> createState() => _jobpervState();
}

class _jobpervState extends State<jobperv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          leading: Container(
            
            child: Icon(Icons.arrow_back_ios)),
            
          
          backgroundColor: Colors.blue,// Set app bar background color to white
          centerTitle: true,
          title: Row(
            children: [
              Container(
                 decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 1), // changes the position of the shadow
          ),
        ],
      ),
                child: Image.asset(
                  'images/job.png', // Replace with your logo image path
                  height: 40.0,
                  width: 120,fit: BoxFit.cover, // Adjust the image height as needed
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              
              
              children: [
                SizedBox(
                  height: 10,
                ),
              
               
               
                SizedBox(
                  height: 10,
                ),
                Container(
                   decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes the position of the shadow
          ),
        ],
      ),
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 8.0,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                     
                     Column(
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
                        
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                      'Creative Graphic Designer',
                      style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                      ],
                     ),
                    ],
                  ),
                 
                  
                  
                  SizedBox(height: 12.0),
                  Row(
                    children:  [
                      Icon(Icons.layers, size: 16.0),
                      SizedBox(width: 6.0),
                       Container(
                    height: 25,
                    
                   
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                     
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        
                       
                        Text(
                          'Al Ahlia General Trading Co.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                      
                      
                      
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(Icons.my_location, size: 16.0),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          'Abu Dhabi Island and Internal Islands City, United Arab Emirates',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                 Row(
                   children: [
                     Container(
                        height: 25,
                       
                       
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                         
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            
                           
                            Text(
                              'Publish Date',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('2023-08-02 13:01:42')
                   ],
                 ),
                 SizedBox(
                  height: 10,
                 ),
                 Row(
                  children: [
                    Text('City',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                  ],
                 ),
                  Row(
                  children: [
                    Text('Abu Dhabi Island and Internal Islands City',style: TextStyle(),)
                  ],
                 ),
                 SizedBox(
                  height: 10,
                 ),
                 Row(
                  children: [
                    Text('Salary',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                  ],
                 ),
                  Row(
                  children: [
                    Text('Aed',style: TextStyle(),)
                  ],
                 ),
                 SizedBox(
                  height: 10,
                 ),
                 Row(
                  children: [
                    Text('Job Description',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                  ],
                 ),
                 SizedBox(
                  height: 5,
                 ),
                  Column(
                    children: [
                      Text(
            '''Collaborate with the marketing and creative teams to understand design requirements and objectives for digital and outdoor branding initiatives. Conceptualize and develop eye-catching graphics, illustrations, and layouts tailored for social media platforms, the company website, and outdoor displays. Produce engaging motion graphics and animated visuals for social media campaigns to enhance brand storytelling. Ensure all designs align with brand guidelines and maintain consistency across various marketing materials. Adapt and optimize designs for different digital platforms, ensuring seamless user experiences and responsiveness. Stay up-to-date with design trends, best practices, and emerging technologies in the graphic design field. Collaborate with cross-functional teams to brainstorm ideas and contribute to creative strategies for marketing campaigns. Manage multiple design projects simultaneously and meet deadlines in a fast-paced environment.''',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.left, // Align text to the left
          ),
                    ],
                  ),
                  
                   Row(mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 8.0,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.9),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Info',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.0),
              ContactItem(
                title: 'Country',
                value: 'United Arab Emirates',
              ),
              ContactItem(
                title: 'Phone',
                value: '+971 02 6419811',
              ),
              ContactItem(
                title: 'Email Address',
                value: 'AGTC@alahliagroup.com',
              ),
            ],
          ),
        ),
      ),
    ),
                     ],
                   ),
                   
                 
                 
                  
                  
                     Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
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
    ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}

class ContactItem extends StatelessWidget {
  final String title;
  final String value;

  ContactItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}