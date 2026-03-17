import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, SystemSound, SystemSoundType;
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/favourite_page/favourite.dart';
import 'package:music_player_app/login/login.dart';
import 'package:music_player_app/widgets/home_screen_widget/all_recents.dart';
import 'package:music_player_app/widgets/home_screen_widget/all_artist.dart';
import 'package:music_player_app/widgets/home_screen_widget/list.dart';
import 'package:music_player_app/widgets/home_screen_widget/recently.dart';
import 'package:music_player_app/widgets/home_screen_widget/slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_audio_query/on_audio_query.dart';

class homeeii extends StatefulWidget {
  const homeeii({super.key});

  @override
  State<homeeii> createState() => _homeeiiState();
}

class _homeeiiState extends State<homeeii> with TickerProviderStateMixin {
  late SharedPreferences logindata;
  late String username;

  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];

  late AnimationController _fadeInController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  DateTime _lastHapticTime = DateTime.now();
  static const Duration _hapticDebounce = Duration(milliseconds: 300);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initial();
    _initializeAnimations();
    requestPermission();
  }

  void _initializeAnimations() {
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
          lowerBound: 0.95,
          upperBound: 1.0,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _pulseController.reverse();
          }
        });

    _fadeAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeInController.forward();
    _slideController.forward();
  }

  Future<void> requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();

    if (!permissionStatus) {
      permissionStatus = await _audioQuery.permissionsRequest();
    }

    if (permissionStatus) {
      loadArtists();
    }
  }

  Future<void> loadArtists() async {
    final fetchedArtists = await _audioQuery.queryArtists();

    setState(() {
      artists = fetchedArtists;
    });
  }

  void _triggerHapticFeedback(HapticFeedbackType type) {
    final now = DateTime.now();
    if (now.difference(_lastHapticTime) >= _hapticDebounce) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selectionClick:
          HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.success:
          HapticFeedback.vibrate();
          SystemSound.play(SystemSoundType.click);
          break;
      }
      _lastHapticTime = now;
    }
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? 'Guest';
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      drawer: buildDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const CircleAvatar(
              backgroundImage: AssetImage('images/hmmmmm.jpg'),
            ),
          ),
        ),
        actions: [
          _buildActionButton(
            icon: Icons.favorite_outline_outlined,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => favvvvv()),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $username 👋',
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

                  const SizedBox(height: 20),

                  _buildSectionHeader(title: 'Artist', onSeeAllTap: () {}),

                  SizedBox(
                    height: 130,
                    child: artists.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: artists.length,
                            itemBuilder: (context, index) {
                              final artist = artists[index];
                              return _buildArtistItem(artist);
                            },
                          ),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionHeader(title: 'Recents', onSeeAllTap: () {}),
                  RecentlyPlayed(songs: []),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtistItem(ArtistModel artist) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: QueryArtworkWidget(
              id: artist.id,
              type: ArtworkType.ARTIST,
              nullArtworkWidget: const Icon(Icons.person),
            ),
          ),
          Text(
            artist.artist ?? "Unknown",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
        TextButton(onPressed: onSeeAllTap, child: const Text("See All")),
      ],
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Logout"),
            onTap: () async {
              await logindata.setBool('login', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => mmmmmmmmm()),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  success,
}
