import 'package:flutter/material.dart';
import 'package:music_player_app/provider/recently_provider.dart';
import 'package:music_player_app/widgets/home_screen_widget/music_player.dart';
import 'package:provider/provider.dart';

class RecentlyPlayed extends StatelessWidget {
  const RecentlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<AlbumProvider>(context);
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
            itemCount: songProvider.albums.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              mainAxisExtent: itemHeight,
            ),
            itemBuilder: (context, index) {
              final song = songProvider.albums[index];
              return GestureDetector(
                onTap: () {
                  songProvider.addToRecently(song);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (index) => MusicPlayerScreeneiii(
                        title: song.title,
                        artist: song.artist,
                        imageUrl: song.imageurl,
                        audioUrl: song.audiourl,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          song.imageurl,
                          width: itemWidth,
                          height: itemWidth,
                          fit: BoxFit.cover,
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
                      song.artist,
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
