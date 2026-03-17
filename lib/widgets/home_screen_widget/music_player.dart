import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayerScreeneiii extends StatefulWidget {
  final List<SongModel> songs;
  final int index;

  const MusicPlayerScreeneiii({
    super.key,
    required this.songs,
    required this.index,
  });

  @override
  State<MusicPlayerScreeneiii> createState() => _MusicPlayerScreeneiiiState();
}

class _MusicPlayerScreeneiiiState extends State<MusicPlayerScreeneiii> {
  final AudioPlayer player = AudioPlayer();
  late PageController _pageController;

  int currentIndex = 0;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.index;

    _pageController = PageController(
      initialPage: currentIndex,
      viewportFraction: 0.75,
    );

    _playSong(currentIndex);

    player.positionStream.listen((p) {
      setState(() => position = p);
    });

    player.durationStream.listen((d) {
      if (d != null) setState(() => duration = d);
    });
  }

  Future<void> _playSong(int index) async {
    final song = widget.songs[index];

    try {
      await player.setFilePath(song.data); // 🔥 device file path
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
    final size = MediaQuery.of(context).size;

    if (widget.songs.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("No Songs Found", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final song = widget.songs[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          song.title,
          style: GoogleFonts.orbitron(
            color: Colors.lightGreenAccent,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 30),

          // 🎵 CAROUSEL
          SizedBox(
            height: size.height * 0.45,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.songs.length,
              onPageChanged: _playSong,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.7, 1);
                    }

                    return Transform.scale(scale: value, child: child);
                  },
                  child: _albumCard(widget.songs[index]),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // 🎵 SONG INFO
          Text(
            song.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            song.artist ?? "Unknown",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 20),

          // 🎵 SLIDER
          Slider(
            value: position.inSeconds.toDouble().clamp(
              0,
              duration.inSeconds.toDouble() == 0
                  ? 1
                  : duration.inSeconds.toDouble(),
            ),
            max: duration.inSeconds.toDouble().clamp(1, double.infinity),
            onChanged: (value) {
              player.seek(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.lightGreenAccent,
          ),

          // 🎵 TIME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(position),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _format(duration),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 🎵 CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: currentIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    : null,
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              IconButton(
                onPressed: () {
                  if (player.playing) {
                    player.pause();
                  } else {
                    player.play();
                  }
                  setState(() {});
                },
                icon: Icon(
                  player.playing ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              IconButton(
                onPressed: currentIndex < widget.songs.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    : null,
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // 🎵 ARTWORK
  Widget _albumCard(SongModel song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: Container(
            color: Colors.grey[900],
            child: const Icon(Icons.music_note, color: Colors.white, size: 80),
          ),
        ),
      ),
    );
  }

  // 🎵 TIME FORMAT
  String _format(Duration d) {
    final min = d.inMinutes;
    final sec = d.inSeconds % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }
}
