import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:music_player_app/provider/recently_provider.dart';

class MusicPlayerScreeneiii extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  const MusicPlayerScreeneiii({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });

  @override
  State<MusicPlayerScreeneiii> createState() => _MusicPlayerScreeneiiiState();
}

class _MusicPlayerScreeneiiiState extends State<MusicPlayerScreeneiii> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<AlbumProvider>(context, listen: false);
      provider.initializePlayer(widget.title, widget.audioUrl);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isMediumScreen = size.width >= 360 && size.width < 600;

    final provider = Provider.of<AlbumProvider>(context, listen: false);
    provider.disposePlayer();
    final albumHeight = isSmallScreen
        ? size.height * 0.45
        : isMediumScreen
        ? size.height * 0.5
        : size.height * 0.55;
    final albumMaxHeight = isSmallScreen
        ? 320.0
        : isMediumScreen
        ? 380.0
        : 450.0;
    final albumMaxWidth = isSmallScreen
        ? 240.0
        : isMediumScreen
        ? 300.0
        : 360.0;

    return Consumer<AlbumProvider>(
      builder: (context, provider, child) {
        final albums = provider.albums;

        if (albums.isEmpty || !provider.isInitialized) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
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
                                Navigator.pop(context);
                              },
                              icon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  albums[provider.currentPage].title,
                  style: GoogleFonts.orbitron(
                    color: const Color.fromARGB(255, 175, 255, 255),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),

                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          backgroundColor: Colors.black,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: size.height * 0.05,
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.04),
                          SizedBox(
                            height: albumHeight.clamp(280.0, albumMaxHeight),
                            child: PageView.builder(
                              controller: provider.pageController,
                              onPageChanged: provider.onPageChanged,
                              itemCount: albums.length,
                              itemBuilder: (context, index) {
                                return AnimatedBuilder(
                                  animation: provider.pageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (provider
                                        .pageController
                                        .position
                                        .haveDimensions) {
                                      value =
                                          provider.pageController.page! - index;
                                      value = (1 - (value.abs() * 0.3)).clamp(
                                        0.7,
                                        1.0,
                                      );
                                    }
                                    return Center(
                                      child: SizedBox(
                                        height:
                                            Curves.easeOut.transform(value) *
                                            (albumMaxHeight * 0.9),
                                        width:
                                            Curves.easeOut.transform(value) *
                                            albumMaxWidth,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: AlbumCard(
                                    imageUrl: albums[index].imageurl,
                                    title: albums[index].title,
                                    artist: albums[index].artist,
                                    isActive: index == provider.currentPage,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.08,
                              vertical: size.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: isSmallScreen ? 2 : 3,
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: isSmallScreen ? 5 : 6,
                                    ),
                                    overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                  child: Slider(
                                    value: provider.position.inSeconds
                                        .toDouble(),
                                    max: provider.duration.inSeconds
                                        .toDouble()
                                        .clamp(1.0, double.infinity),
                                    onChanged: (value) {
                                      provider.seekTo(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        provider.formatDuration(
                                          provider.position,
                                        ),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: isSmallScreen ? 11 : 12,
                                        ),
                                      ),
                                      Text(
                                        provider.formatDuration(
                                          provider.duration,
                                        ),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: isSmallScreen ? 11 : 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.012,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900]?.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: provider.currentPage > 0
                                          ? provider.previousSong
                                          : null,
                                      icon: Icon(
                                        Icons.skip_previous_rounded,
                                        size: isSmallScreen ? 32 : 40,
                                      ),
                                      color: provider.currentPage > 0
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.3),
                                    ),
                                    IconButton(
                                      onPressed: provider.playPause,
                                      icon: Icon(
                                        provider.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: isSmallScreen ? 32 : 40,
                                      ),
                                      color: Colors.white,
                                    ),
                                    IconButton(
                                      onPressed:
                                          provider.currentPage <
                                              albums.length - 1
                                          ? provider.nextSong
                                          : null,
                                      icon: Icon(
                                        Icons.skip_next_rounded,
                                        size: isSmallScreen ? 32 : 40,
                                      ),
                                      color:
                                          provider.currentPage <
                                              albums.length - 1
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.3),
                                    ),
                                    Container(
                                      width: isSmallScreen ? 38 : 45,
                                      height: isSmallScreen ? 38 : 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            albums[provider.currentPage]
                                                .imageurl,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.02,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              albums[provider.currentPage]
                                                  .title,
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 12
                                                    : 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              albums[provider.currentPage]
                                                  .artist,
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 10
                                                    : 12,
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final bool isActive;

  const AlbumCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.025,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    artist,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
