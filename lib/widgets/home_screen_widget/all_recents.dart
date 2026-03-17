import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_app/widgets/home_screen_widget/music_player.dart';

class Allrecentss extends StatefulWidget {
  final List<SongModel> recentSongs;

  const Allrecentss({super.key, required this.recentSongs});

  @override
  State<Allrecentss> createState() => _AllrecentssState();
}

class _AllrecentssState extends State<Allrecentss> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final songs = widget.recentSongs;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 HEADER
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
                      'All Recents',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _countBox(songs.length),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 BODY
            Expanded(
              child: songs.isEmpty
                  ? _emptyUI()
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: 10,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return _SongCard(
                          song: songs[index],
                          songs: songs, // ✅ pass full list
                          index: index, // ✅ pass index
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔙 BACK BUTTON
  Widget _backButton(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  // 🔢 COUNT BOX
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

  // ❌ EMPTY UI
  Widget _emptyUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Recently Played Songs',
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

//////////////////////////////////////////////////////////////
/// 🎵 SONG CARD
//////////////////////////////////////////////////////////////

class _SongCard extends StatefulWidget {
  final SongModel song;
  final List<SongModel> songs;
  final int index;

  const _SongCard({
    required this.song,
    required this.songs,
    required this.index,
  });

  @override
  State<_SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<_SongCard>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();

        // 🔥 FIXED NAVIGATION
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MusicPlayerScreeneiii(songs: widget.songs, index: widget.index),
          ),
        );
      },
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
              children: [
                // 🎵 ARTWORK
                QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),

                // 🎵 TITLE
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),

                // 🎵 ARTIST
                Text(
                  song.artist ?? "Unknown",
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
