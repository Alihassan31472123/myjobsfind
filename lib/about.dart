import 'package:flutter/material.dart';
import 'package:myjobsfind2/profile.dart';

import 'logo.dart';
import 'mainscreen.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
   int _selectedIndex = 2;

  final List<Widget> _screens = [
    nextscreen(),
    logo(),
    about(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('about'))
        ],
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
    );
  }
}