import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, SystemSound, SystemSoundType;
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

class _homeeiiState extends State<homeeii> with TickerProviderStateMixin {
  late SharedPreferences logindata;
  late String username;

  late AnimationController _fadeInController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  DateTime _lastHapticTime = DateTime.now();
  static const Duration _hapticDebounce = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    initial();
    _initializeAnimations();
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

  void _handleNavigation(
    Widget page, {
    HapticFeedbackType feedback = HapticFeedbackType.mediumImpact,
  }) {
    _triggerHapticFeedback(feedback);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? 'Guest';
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _fadeInController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ArtistProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
                _triggerHapticFeedback(HapticFeedbackType.lightImpact);
                _scaffoldKey.currentState?.openDrawer();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
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
                  _buildActionButton(
                    icon: Icons.favorite_outline_outlined,
                    onPressed: () {
                      _handleNavigation(
                        favvvvv(),
                        feedback: HapticFeedbackType.mediumImpact,
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.notifications_none,
                    onPressed: () {
                      _triggerHapticFeedback(HapticFeedbackType.lightImpact);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 5),
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

                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      builder: (context, double value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Listeeei(),
                    ),

                    ImageSlider(),

                    const SizedBox(height: 30),

                    _buildSectionHeader(
                      title: 'Artist',
                      onSeeAllTap: () {
                        _handleNavigation(
                          AllArtistScreen(),
                          feedback: HapticFeedbackType.lightImpact,
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 130,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Consumer<ArtistProvider>(
                          builder: (context, provider, child) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: provider.artlists.length > 11
                                  ? 11
                                  : provider.artlists.length,
                              itemBuilder: (context, index) {
                                final artist = provider.artlists[index];
                                return TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: Duration(
                                    milliseconds: 400 + (index * 50),
                                  ),
                                  curve: Curves.easeOutBack,
                                  builder: (context, double value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: _buildArtistItem(artist),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    _buildSectionHeader(
                      title: 'Recents',
                      onSeeAllTap: () {
                        _handleNavigation(
                          Allrecentss(),
                          feedback: HapticFeedbackType.lightImpact,
                        );
                      },
                    ),

                    RecentlyPlayed(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTapDown: (_) {
          _pulseController.forward();
          _triggerHapticFeedback(HapticFeedbackType.lightImpact);
        },
        onTapUp: (_) {
          onPressed();
        },
        onTapCancel: () {
          _pulseController.reverse();
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseController.value,
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: Colors.white.withOpacity(0.1),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildArtistItem(artist) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () {
          _triggerHapticFeedback(HapticFeedbackType.lightImpact);
        },
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
            Text(artist.name, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.khula(
            textStyle: const TextStyle(color: Colors.white, fontSize: 23),
          ),
        ),
        GestureDetector(
          onTapDown: (_) {
            _triggerHapticFeedback(HapticFeedbackType.lightImpact);
          },
          onTap: onSeeAllTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
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
    );
  }

  buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Maeve'),
            accountEmail: Text('maevewilley@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/hmmmmm.jpg'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _triggerHapticFeedback(HapticFeedbackType.heavyImpact);

                await logindata.setBool('login', true);

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        mmmmmmmmm(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;

                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('LogOut'),
            ),
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
