import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:on_audio_query/on_audio_query.dart';

class AllArtistScreen extends StatefulWidget {
  const AllArtistScreen({super.key});

  @override
  State<AllArtistScreen> createState() => _AllArtistScreenState();
}

class _AllArtistScreenState extends State<AllArtistScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.black)),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.02,
                  ),
                  child: Row(
                    children: [
                      _backButton(context),

                      const SizedBox(width: 15),

                      const Expanded(
                        child: Text(
                          'All Artists',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      _countBox(artists.length),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: artists.isEmpty
                      ? _emptyState()
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: 10,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: size.width > 600 ? 3 : 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: artists.length,
                          itemBuilder: (context, index) {
                            final artist = artists[index];
                            return _ArtistCard(artist: artist, index: index);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _countBox(int count) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.lightGreenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Artists Found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// 🎨 Artist Card (UI SAME, data changed)
class _ArtistCard extends StatefulWidget {
  final ArtistModel artist;
  final int index;

  const _ArtistCard({required this.artist, required this.index});

  @override
  State<_ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<_ArtistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  child: QueryArtworkWidget(
                    id: widget.artist.id,
                    type: ArtworkType.ARTIST,
                    nullArtworkWidget: const Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  widget.artist.artist ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),

                const Text(
                  'Artist',
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
