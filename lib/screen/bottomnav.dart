import 'package:flutter/material.dart';
import 'package:music_player_app/screen/home_screen.dart';
import 'package:music_player_app/screen/library.dart';
import 'package:music_player_app/screen/profile.dart';
import 'package:music_player_app/screen/search.dart';

class bottomnavvv extends StatefulWidget {
  const bottomnavvv({super.key});

  @override
  State<bottomnavvv> createState() => _bottomnavvvState();
}

class _bottomnavvvState extends State<bottomnavvv> {
  int currentindex = 0;

  final List<Widget> pages = [homeeii(), searchhhh(), libraryy(), profileee()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFF1A1A1A),
            selectedItemColor: Colors.lightGreenAccent,
            unselectedItemColor: Colors.white,
            currentIndex: currentindex,
            onTap: (index) {
              setState(() {
                currentindex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music_outlined),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: currentindex, children: pages),
    );
  }
}
