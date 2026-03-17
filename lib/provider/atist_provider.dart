// import 'package:flutter/material.dart';
// import 'package:music_player_app/model/artist_model.dart';

// class ArtistProvider with ChangeNotifier {
//   final List<ArtistModel> _artlists = [
//     ArtistModel(name: 'The Weeknd', imagepath: 'images/coverr1.jpg'),
//     ArtistModel(name: 'Dua Lipa', imagepath: 'images/coverr2.jpg'),
//     ArtistModel(name: 'Lana Del rey', imagepath: 'images/coverr3.jpg'),
//     ArtistModel(name: 'Ed Sheeran', imagepath: 'images/coverr4.jpg'),
//     ArtistModel(name: 'Taylor Swift', imagepath: 'images/coverr5.jpg'),
//     ArtistModel(name: 'Billie Eilish', imagepath: 'images/coverr6.jpg'),
//     ArtistModel(name: 'Anuv Jain', imagepath: 'images/coverr7.jpg'),
//     ArtistModel(name: 'Sid Sriram', imagepath: 'images/coverr8.jpg'),
//     ArtistModel(name: 'Shreya Ghoshal', imagepath: 'images/coverr9.jpg'),
//     ArtistModel(name: 'Vijay Yesudas', imagepath: 'images/coverr10.jpg'),
//     ArtistModel(name: 'Arijit Singh', imagepath: 'images/coverr11.jpg'),
//   ];
//   final List<ArtistModel> _recentlyplayed = [];

//   List<ArtistModel> get artlists => _artlists;
//   List<ArtistModel> get recetnlyplayed => _recentlyplayed;

//   get recentSongs => null;

//   void togglefavorite(ArtistModel artlists) {
//     final existingindex = _artlists.indexWhere(
//       (aaa) => aaa.name == artlists.name,
//     );
//     if (existingindex >= 0) {
//       _artlists[existingindex] = _artlists[existingindex].copywith(
//         isfavorite: !_artlists[existingindex].isfavorite,
//       );
//       notifyListeners();
//     }



//     ;
//   }
// }





















// //   List<ArtistModel> get artists => _artists;

// //   // function to toggle favorite status
// //   void toggleFavorite(ArtistModel artist) {
// //     final index = _artists.indexWhere((a) => a.name == artist.name);
// //     if (index != -1) {
// //       _artists[index] =
// //           _artists[index].copyWith(isFavorite: !_artists[index].isFavorite);
// //       notifyListeners(); // updates UI wherever artists are used
// //     }
// //   }
// // }