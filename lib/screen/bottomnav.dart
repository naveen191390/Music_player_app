import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player_app/screen/home_screen.dart';
import 'package:music_player_app/screen/library.dart';
import 'package:music_player_app/screen/profile.dart';
import 'package:music_player_app/screen/search.dart';
import 'dart:math' as math;
import 'package:on_audio_query/on_audio_query.dart';
import 'package:file_picker/file_picker.dart';

class UnifiedSong {
  final String title;
  final String? artist;
  final String? path;
  final String? uri;
  final int? duration;

  const UnifiedSong({
    required this.title,
    this.artist,
    this.path,
    this.uri,
    this.duration,
  });

  factory UnifiedSong.fromSongModel(SongModel song) => UnifiedSong(
    title: song.title,
    artist: song.artist,
    uri: song.uri,
    duration: song.duration,
  );

  /// Build from file_picker PlatformFile
  factory UnifiedSong.fromPlatformFile(PlatformFile file) => UnifiedSong(
    title: file.name.replaceAll(RegExp(r'\.[^.]+$'), ''), // strip extension
    path: file.path,
  );
}

// ─── Main widget ──────────────────────────────────────────────────────────────
class bottomnavvv extends StatefulWidget {
  const bottomnavvv({super.key});

  @override
  State<bottomnavvv> createState() => _bottomnavvvState();
}

class _bottomnavvvState extends State<bottomnavvv> {
  int currentindex = 0;
  bool _menuOpen = false;

  final OnAudioQuery _audioQuery = OnAudioQuery();

  // FIX 2: strongly-typed list — no more List<dynamic> mixing two unrelated types
  List<UnifiedSong> addedSongs = [];

  List<Widget> get pages => [
    homeeii(),
    searchhhh(),
    libraryy(addedSongs: addedSongs),
    profileee(),
  ];

  void _onNavTap(int navIdx) {
    final pageIndex = navIdx > 2 ? navIdx - 1 : navIdx;
    if (_menuOpen) _closeMenu();
    setState(() => currentindex = pageIndex);
  }

  int get _navIndex => currentindex >= 2 ? currentindex + 1 : currentindex;

  void _toggleMenu() {
    HapticFeedback.lightImpact();
    setState(() => _menuOpen = !_menuOpen);
  }

  void _closeMenu() {
    setState(() => _menuOpen = false);
  }

  Future<void> scandeviceSongs() async {
    bool permission = await _audioQuery.permissionsRequest();
    if (!permission) return;

    final songs = await _audioQuery.querySongs();

    setState(() {
      // Normalise every SongModel → UnifiedSong
      addedSongs = songs.map(UnifiedSong.fromSongModel).toList();
      currentindex = 2;
    });
    _closeMenu();
  }

  Future<void> pickSongs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        // Normalise every PlatformFile → UnifiedSong before adding
        addedSongs.addAll(result.files.map(UnifiedSong.fromPlatformFile));
        currentindex = 2;
      });
    }

    // FIX 1: always close the menu, whether the user picked files or cancelled
    _closeMenu();
  }

  Future<void> pickfolder() async {
    String? folderpath = await FilePicker.platform.getDirectoryPath();

    if (folderpath != null) {
      debugPrint('Folder selected: $folderpath');
    }
    _closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _menuOpen ? _closeMenu : null,
        child: IndexedStack(index: currentindex, children: pages),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFF111118),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 36,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      isActive: _navIndex == 0,
                      onTap: () => _onNavTap(0),
                    ),
                    _NavItem(
                      icon: Icons.search_rounded,
                      isActive: _navIndex == 1,
                      onTap: () => _onNavTap(1),
                    ),
                    const SizedBox(width: 62),
                    _NavItem(
                      icon: Icons.library_music_outlined,
                      isActive: _navIndex == 3,
                      onTap: () => _onNavTap(3),
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      isActive: _navIndex == 4,
                      onTap: () => _onNavTap(4),
                    ),
                  ],
                ),
              ),
            ),
            _FanMenuItem(
              emoji: '📁',
              label: 'Scan Device',
              isOpen: _menuOpen,
              offsetX: -90,
              offsetY: -110,
              delay: 0,
              color: const Color(0xFF6C63FF),
              onTap: scandeviceSongs,
            ),
            _FanMenuItem(
              emoji: '🎵',
              label: 'Select Songs',
              isOpen: _menuOpen,
              offsetX: 0,
              offsetY: -135,
              delay: 60,
              color: const Color(0xFF98F5A0),
              onTap: pickSongs,
            ),
            _FanMenuItem(
              emoji: '📂',
              label: 'Select Folder',
              isOpen: _menuOpen,
              offsetX: 90,
              offsetY: -110,
              delay: 120,
              color: const Color(0xFFFFB347),
              onTap: pickfolder,
            ),
            Positioned(
              top: 0,
              child: _FabButton(isOpen: _menuOpen, onTap: _toggleMenu),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fan menu item ────────────────────────────────────────────────────────────
class _FanMenuItem extends StatefulWidget {
  final String emoji;
  final String label;
  final bool isOpen;
  final double offsetX;
  final double offsetY;
  final int delay;
  final Color color;
  final VoidCallback onTap;

  const _FanMenuItem({
    required this.emoji,
    required this.label,
    required this.isOpen,
    required this.offsetX,
    required this.offsetY,
    required this.delay,
    required this.color,
    required this.onTap,
  });

  @override
  State<_FanMenuItem> createState() => _FanMenuItemState();
}

class _FanMenuItemState extends State<_FanMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.offsetX, widget.offsetY),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(_FanMenuItem old) {
    super.didUpdateWidget(old);
    if (widget.isOpen != old.isOpen) {
      if (widget.isOpen) {
        Future.delayed(Duration(milliseconds: widget.delay), () {
          if (mounted) _ctrl.forward();
        });
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) {
        return Positioned(
          top: 29 + _slide.value.dy,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.translate(
              offset: Offset(_slide.value.dx, 0),
              child: Opacity(
                opacity: _opacity.value.clamp(0.0, 1.0),
                child: Transform.scale(scale: _scale.value, child: child),
              ),
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(0.12),
                border: Border.all(
                  color: widget.color.withOpacity(0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(widget.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: widget.color.withOpacity(0.2)),
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FAB button ───────────────────────────────────────────────────────────────
class _FabButton extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _FabButton({required this.isOpen, required this.onTap});

  @override
  State<_FabButton> createState() => _FabButtonState();
}

class _FabButtonState extends State<_FabButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotate;
  late Animation<double> _scale;
  late Animation<double> _ringPulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _rotate = Tween<double>(
      begin: 0,
      end: 0.375,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.82), weight: 35),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.82,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 65,
      ),
    ]).animate(_ctrl);
    _ringPulse = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(_FabButton old) {
    super.didUpdateWidget(old);
    if (widget.isOpen != old.isOpen) {
      widget.isOpen ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (_ctrl.value > 0 && _ctrl.value < 1)
                Opacity(
                  opacity: (1 - _ringPulse.value).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 1.0 + _ringPulse.value * 1.6,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              Transform.scale(
                scale: _scale.value,
                child: Transform.rotate(
                  angle: _rotate.value * 2 * math.pi,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isOpen
                            ? [const Color(0xFFFF6B6B), const Color(0xFFE53E3E)]
                            : [
                                const Color(0xFF7B74FF),
                                const Color(0xFF4F46E5),
                              ],
                      ),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black,
                          blurRadius: 0,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.07),
                          blurRadius: 0,
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: widget.isOpen
                              ? const Color(0xFFFF6B6B).withOpacity(0.5)
                              : const Color(0xFF6C63FF).withOpacity(0.55),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isOpen ? Icons.close_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Nav item ─────────────────────────────────────────────────────────────────
class _NavItem extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleCtrl;
  late Animation<double> _ripple;
  Offset _tapPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _ripple = CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails d) {
    _tapPos = d.localPosition;
    _rippleCtrl.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      child: AnimatedBuilder(
        animation: _ripple,
        builder: (ctx, child) => CustomPaint(
          painter: _RipplePainter(progress: _ripple.value, tapPos: _tapPos),
          child: child,
        ),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: widget.isActive ? 1.0 : 0.0,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const RadialGradient(
                      colors: [Color(0x2298F5A0), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    offset: widget.isActive
                        ? const Offset(0, -0.12)
                        : Offset.zero,
                    child: Icon(
                      widget.icon,
                      size: 22,
                      color: widget.isActive
                          ? Colors.lightGreenAccent
                          : Colors.white.withOpacity(0.32),
                    ),
                  ),
                  const SizedBox(height: 3),
                  AnimatedScale(
                    scale: widget.isActive ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.lightGreenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ripple painter ───────────────────────────────────────────────────────────
class _RipplePainter extends CustomPainter {
  final double progress;
  final Offset tapPos;

  _RipplePainter({required this.progress, required this.tapPos});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final paint = Paint()
      ..color = Colors.white.withOpacity((1 - progress) * 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(tapPos, progress * size.width * 1.1, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter old) =>
      old.progress != progress || old.tapPos != tapPos;
}
