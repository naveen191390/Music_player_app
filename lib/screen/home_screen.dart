import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/favourite_page/favourite.dart';
import 'package:music_player_app/login/login.dart';
import 'package:music_player_app/provider/atist_provider.dart';
import 'package:music_player_app/widgets/home_screen_widget/all_recents.dart';
import 'package:music_player_app/widgets/home_screen_widget/all_artist.dart';
import 'package:music_player_app/widgets/home_screen_widget/list.dart';
import 'package:music_player_app/widgets/home_screen_widget/recently.dart';
import 'package:music_player_app/widgets/home_screen_widget/slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homeeii extends StatefulWidget {
  homeeii({super.key});
  @override
  State<homeeii> createState() => _homeeiiState();
}

class _homeeiiState extends State<homeeii> {
  late SharedPreferences logindata;
  late String username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final artistproviderr = Provider.of<ArtistProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: _isdark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        drawer: buildDrawer(),
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.black),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                width: 80,
                height: 80,
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/hmmmmm.jpg'),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => favvvvv(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.favorite_outline_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Naveen 👋',
                  style: GoogleFonts.cabin(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Listeeei(),
                ImageSlider(),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Artist',
                      style: GoogleFonts.khula(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllArtistScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Text(
                          'See All',
                          style: GoogleFonts.khula(
                            textStyle: const TextStyle(
                              color: Colors.lightGreenAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: artistproviderr.artlists.length > 11
                          ? 11
                          : artistproviderr.artlists.length,
                      itemBuilder: (context, index) {
                        final artist = artistproviderr.artlists[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.85),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(artist.imagepath),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                artist.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recents',
                      style: GoogleFonts.khula(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Allrecentss(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Text(
                          'See All',
                          style: GoogleFonts.khula(
                            textStyle: const TextStyle(
                              color: Colors.lightGreenAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                RecentlyPlayed(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Maeve'),
            accountEmail: Text('maevewilley@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/hmmmmm.jpg'),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              logindata.setBool('login', true);
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(builder: (context) => mmmmmmmmm()),
              );
            },
            child: Text('LogOut'),
          ),
        ],
      ),
    );
  }
}
