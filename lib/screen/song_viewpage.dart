import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongFlowPage extends StatefulWidget {
  final List<SongModel> songs; // ✅ changed
  const SongFlowPage({super.key, required this.songs});

  @override
  State<SongFlowPage> createState() => _SongFlowPageState();
}

class _SongFlowPageState extends State<SongFlowPage> {
  final PageController _pageController = PageController(viewportFraction: 0.6);
  final AudioPlayer player = AudioPlayer();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _playSong(0);
  }

  // ✅ play from device path
  Future<void> _playSong(int index) async {
    final song = widget.songs[index];

    try {
      await player.setFilePath(song.data); // 🔥 device path
      player.play();

      setState(() => currentIndex = index);
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🎵 3D Song Slider
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.songs.length,
              onPageChanged: (index) => _playSong(index),
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (value).clamp(-1, 1);
                    }

                    final double scale = 1 - (value.abs() * 0.3);
                    final double angle = value * 0.5;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle)
                        ..scale(scale),
                      child: child,
                    );
                  },

                  // ✅ Artwork instead of asset image
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: QueryArtworkWidget(
                        id: widget.songs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🎧 Mini Player
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: QueryArtworkWidget(
                    id: widget.songs[currentIndex].id,
                    type: ArtworkType.AUDIO,
                    artworkWidth: 50,
                    artworkHeight: 50,
                    nullArtworkWidget: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[900],
                      child: const Icon(Icons.music_note, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songs[currentIndex].title,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.songs[currentIndex].artist ?? "Unknown",
                        style: const TextStyle(color: Colors.white54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ▶️ Play / Pause
                IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white),
                  onPressed: () {
                    if (player.playing) {
                      player.pause();
                    } else {
                      player.play();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
