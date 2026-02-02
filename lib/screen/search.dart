import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class searchhhh extends StatefulWidget {
  searchhhh({super.key});

  @override
  State<searchhhh> createState() => _searchhhhState();
}

class _searchhhhState extends State<searchhhh> {
  @override
  Widget build(BuildContext context) {
    final List<String> discoverimages = [
      'images/pop.jpg',
      'images/lofi.jpg',
      'images/bollywood.jpg',
      'images/jazz.jpg',
      'images/hollywood.jpg',
    ];

    final List<String> discovernames = [
      '#popmusic',
      '#malayalamlofi',
      '#bollywood',
      '#indianjazz',
      '#hollywood',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: Colors.black,
        flexibleSpace: Spacer(),
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Text(
              'Search ',
              style: GoogleFonts.khula(
                textStyle: const TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 35, top: 32),
              child: Text(
                'Your Ideas !',
                style: GoogleFonts.khula(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 255, 248, 239),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Your Items',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 0,
                    ),
                    border: InputBorder.none,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 280, top: 10),
            child: Text(
              "Discover",
              style: GoogleFonts.notoSansLinearB(
                textStyle: TextStyle(
                  color: Colors.lightGreenAccent,
                  fontSize: 23,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: discoverimages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 118,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(.5),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(discoverimages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 190, left: 8),
                    child: Text(
                      discovernames[index],
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Moods & Genres',
                style: GoogleFonts.notoSansLinearB(
                  textStyle: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
