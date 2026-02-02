import 'package:flutter/material.dart';
import 'package:music_player_app/model/recently_model.dart';
import 'package:audioplayers/audioplayers.dart';

class AlbumProvider with ChangeNotifier {
  final List<Songmodel> _albums = [
    Songmodel(
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      imageurl: 'images/songsss1.jpg',
      audiourl: 'assets/audios/moosic2.mp3',
    ),
    Songmodel(
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      imageurl: 'images/songsss2.jpg',
      audiourl: 'assets/audios/moosic3.mp3',
    ),
    Songmodel(
      title: 'Happier Than Ever',
      artist: 'Billie Eilish',
      imageurl: 'images/songsss3.jpg',
      audiourl: 'assets/audios/moosic4.mp3',
    ),
    Songmodel(
      title: 'Mockingbird',
      artist: 'Eminem',
      imageurl: 'images/songsss4.jpg',
      audiourl: 'assets/audios/moosic5.mp3',
    ),
  ];

  final List<Songmodel> _recentlyPlayed = [];

  late AudioPlayer _audioPlayer;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isInitialized = false;

  List<Songmodel> get albums => _albums;
  List<Songmodel> get recentlyPlayed => _recentlyPlayed;
  PageController get pageController => _pageController;
  int get currentPage => _currentPage;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isInitialized => _isInitialized;

  void initializePlayer(String initialTitle, String initialAudioUrl) {
    if (_isInitialized) return;

    _currentPage = _albums.indexWhere(
      (album) =>
          album.title == initialTitle && album.audiourl == initialAudioUrl,
    );

    if (_currentPage == -1) _currentPage = 0;

    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.7,
    );

    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
    // _loadAudio();
    _isInitialized = true;
    notifyListeners();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _position = Duration.zero;
      notifyListeners();
      nextSong();
    });
  }

  // Future<void> _loadAudio() async {
  //   try {
  //     final currentSong = _albums[_currentPage];
  //     final audioPath = currentSong.audiourl.replaceFirst('assets/', '');
  //     await _audioPlayer.setSource(AssetSource(audioPath));
  //     print('Audio loaded successfully: $audioPath');
  //   } catch (e) {
  //     print('Error loading audio: $e');
  //   }
  //   notifyListeners();
  // }

  Future<void> playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        if (_position == Duration.zero) {
          final currentSong = _albums[_currentPage];
          final audioPath = currentSong.audiourl.replaceFirst('assets/', '');
          await _audioPlayer.play(AssetSource(audioPath));
        } else {
          await _audioPlayer.resume();
        }
        _isPlaying = true;
      }
      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> previousSong() async {
    if (_currentPage > 0) {
      await _audioPlayer.stop();
      _isPlaying = false;
      _position = Duration.zero;
      notifyListeners();

      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> nextSong() async {
    if (_currentPage < _albums.length - 1) {
      await _audioPlayer.stop();
      _isPlaying = false;
      _position = Duration.zero;
      notifyListeners();

      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> onPageChanged(int index) async {
    _currentPage = index;
    _isPlaying = false;
    _position = Duration.zero;
    notifyListeners();

    await _audioPlayer.stop();
    // await _loadAudio();
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void addToRecently(Songmodel song) {
    _recentlyPlayed.removeWhere((s) => s.title == song.title);
    _recentlyPlayed.insert(0, song);

    if (_recentlyPlayed.length > 10) {
      _recentlyPlayed.removeLast();
    }
    notifyListeners();
  }

  void disposePlayer() {
    if (_isInitialized) {
      _pageController.dispose();
      _audioPlayer.dispose();
      _isInitialized = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }
}
