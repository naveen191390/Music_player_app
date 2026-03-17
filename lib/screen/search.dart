import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:google_fonts/google_fonts.dart';

class searchhhh extends StatefulWidget {
  searchhhh({super.key});

  @override
  State<searchhhh> createState() => _searchhhhState();
}

class _searchhhhState extends State<searchhhh> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  DateTime _lastHapticTime = DateTime.now();
  static const Duration _hapticDebounce = const Duration(milliseconds: 300);

  final List<String> discoverImages = [
    'images/pop.jpg',
    'images/lofi.jpg',
    'images/bollywood.jpg',
    'images/jazz.jpg',
    'images/hollywood.jpg',
  ];

  final List<String> discoverNames = [
    '#popmusic',
    '#malayalamlofi',
    '#bollywood',
    '#indianjazz',
    '#hollywood',
  ];

  final List<Map<String, String>> moodAndGenres = [
    {'name': 'Happy', 'icon': '😊', 'color': '#FFD700'},
    {'name': 'Sad', 'icon': '😢', 'color': '#4169E1'},
    {'name': 'Energetic', 'icon': '⚡', 'color': '#FF4500'},
    {'name': 'Relaxing', 'icon': '😌', 'color': '#32CD32'},
    {'name': 'Workout', 'icon': '💪', 'color': '#DC143C'},
    {'name': 'Romantic', 'icon': '❤️', 'color': '#FF69B4'},
    {'name': 'Party', 'icon': '🎉', 'color': '#9370DB'},
    {'name': 'Focus', 'icon': '🎯', 'color': '#20B2AA'},
  ];

  final List<Map<String, String>> topCharts = [
    {'name': 'Global Top 50', 'image': 'images/global.jpg'},
    {'name': 'US Top 50', 'image': 'images/us.jpg'},
    {'name': 'UK Top 50', 'image': 'images/uk.jpg'},
    {'name': 'India Top 50', 'image': 'images/india.jpg'},
    {'name': 'Viral 50', 'image': 'images/viral.jpg'},
  ];

  final List<String> recentSearches = [
    'Shape of You',
    'Blinding Lights',
    'Perfect',
    'Dance Monkey',
    'Believer',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _triggerHapticFeedback(HapticFeedbackType.lightImpact);
    }
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
        case HapticFeedbackType.selectionClick:
          HapticFeedback.selectionClick();
          break;
      }
      _lastHapticTime = now;
    }
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _triggerHapticFeedback(HapticFeedbackType.mediumImpact);
      print('Searching for: $query');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            _triggerHapticFeedback(HapticFeedbackType.lightImpact);
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                'Search ',
                style: GoogleFonts.khula(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: 35,
                top: 32,
                child: Text(
                  'Your Ideas !',
                  style: GoogleFonts.khula(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightGreenAccent.withOpacity(0.3),
                              blurRadius: _searchFocusNode.hasFocus ? 15 : 5,
                              spreadRadius: _searchFocusNode.hasFocus ? 2 : 0,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onSubmitted: _performSearch,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Search songs, artists, albums...',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 248, 239),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () =>
                                  _performSearch(_searchController.text),
                              color: Colors.grey.shade800,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _triggerHapticFeedback(
                                        HapticFeedbackType.lightImpact,
                                      );
                                      _searchController.clear();
                                    },
                                    color: Colors.grey.shade800,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (recentSearches.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Searches",
                        style: GoogleFonts.notoSansLinearB(
                          textStyle: const TextStyle(
                            color: Colors.lightGreenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _triggerHapticFeedback(
                            HapticFeedbackType.mediumImpact,
                          );
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentSearches.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _triggerHapticFeedback(
                            HapticFeedbackType.lightImpact,
                          );
                          _searchController.text = recentSearches[index];
                          _performSearch(recentSearches[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                recentSearches[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Discover",
                  style: GoogleFonts.notoSansLinearB(
                    textStyle: const TextStyle(
                      color: Colors.lightGreenAccent,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: discoverImages.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.8, end: 1),
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      curve: Curves.easeOutBack,
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: _buildDiscoverCard(
                            image: discoverImages[index],
                            name: discoverNames[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Charts',
                      style: GoogleFonts.notoSansLinearB(
                        textStyle: const TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _triggerHapticFeedback(HapticFeedbackType.mediumImpact);
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: topCharts.length,
                  itemBuilder: (context, index) {
                    return _buildChartCard(topCharts[index]);
                  },
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Moods & Genres',
                      style: GoogleFonts.notoSansLinearB(
                        textStyle: const TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _triggerHapticFeedback(HapticFeedbackType.mediumImpact);
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: moodAndGenres.length,
                itemBuilder: (context, index) {
                  return _buildMoodCard(moodAndGenres[index]);
                },
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Artists',
                      style: GoogleFonts.notoSansLinearB(
                        textStyle: const TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _triggerHapticFeedback(HapticFeedbackType.mediumImpact);
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return _buildArtistCard(index);
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverCard({required String image, required String name}) {
    return GestureDetector(
      onTap: () {
        _triggerHapticFeedback(HapticFeedbackType.mediumImpact);
      },
      child: Container(
        width: 118,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(.5), width: 1.5),
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(Map<String, String> chart) {
    return GestureDetector(
      onTap: () {
        _triggerHapticFeedback(HapticFeedbackType.mediumImpact);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(chart['image']!),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                chart['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(Map<String, String> mood) {
    return GestureDetector(
      onTap: () {
        _triggerHapticFeedback(HapticFeedbackType.lightImpact);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(int.parse(mood['color']!.replaceFirst('#', '0xFF'))),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(
                int.parse(mood['color']!.replaceFirst('#', '0xFF')),
              ).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood['icon']!, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              mood['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistCard(int index) {
    final artists = [
      'Ariana Grande',
      'Ed Sheeran',
      'Taylor Swift',
      'Drake',
      'Weeknd',
      'BTS',
      'Dua Lipa',
      'Justin Bieber',
    ];

    return GestureDetector(
      onTap: () {
        _triggerHapticFeedback(HapticFeedbackType.lightImpact);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.lightGreenAccent.withOpacity(0.5),
                  width: 2,
                ),
                image: const DecorationImage(
                  image: AssetImage('images/artist_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              artists[index % artists.length],
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

enum HapticFeedbackType { lightImpact, mediumImpact, selectionClick }
