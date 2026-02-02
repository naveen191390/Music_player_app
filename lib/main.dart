import 'package:flutter/material.dart';
import 'package:music_player_app/provider/atist_provider.dart';
import 'package:music_player_app/provider/recently_provider.dart';
import 'package:music_player_app/screen/bottomnav.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArtistProvider()),
        ChangeNotifierProvider(create: (context) => AlbumProvider()),
      ],
      child: MaterialApp(
        home: bottomnavvv(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
