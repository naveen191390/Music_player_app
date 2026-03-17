import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_app/widgets/home_screen_widget/music_player.dart';

class RecentlyPlayed extends StatelessWidget {
  final List<SongModel> songs;

  const RecentlyPlayed({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 60) / 2;
    final itemHeight = itemWidth + 40;

    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 7),

          GridView.builder(
            itemCount: songs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              mainAxisExtent: itemHeight,
            ),
            itemBuilder: (context, index) {
              final song = songs[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MusicPlayerScreeneiii(songs: songs, index: index),
                    ),
                  );
                },

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      song.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      song.artist ?? "Unknown",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
