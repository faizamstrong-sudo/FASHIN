import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/now_playing_panel.dart';
import 'home_screen_desktop.dart';
import 'search_screen.dart';
import 'playlist_screen.dart';

class DesktopMainShell extends ConsumerStatefulWidget {
  const DesktopMainShell({super.key});

  @override
  ConsumerState<DesktopMainShell> createState() => _DesktopMainShellState();
}

class _DesktopMainShellState extends ConsumerState<DesktopMainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreenDesktop(),
    SearchScreen(),
    PlaylistScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: Row(
        children: [
          // Left Sidebar (320px) - Navigation + Playlists
          SidebarNavigation(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),

          // Main Content (Fluid) - Home/Search/Playlists
          Expanded(
            child: Column(
              children: [
                // Top Bar with controls
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.darkBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.darkCardColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        // Back/Forward buttons
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: AppTheme.darkTextSecondary,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: AppTheme.darkTextSecondary,
                          onPressed: () {},
                        ),
                        const Spacer(),
                        // User profile button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.darkCardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: AppTheme.darkTextSecondary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'User',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main content area
                Expanded(
                  child: _screens[_selectedIndex],
                ),

                // Bottom Player Controls
                if (audioState.currentSong != null)
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppTheme.darkCardColor,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Progress bar
                        _buildProgressBar(audioState),

                        // Controls
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                // Left: Song info
                                Expanded(
                                  child: Row(
                                    children: [
                                      // Album art
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: AppTheme.darkHoverColor,
                                        ),
                                        child: audioState.currentSong?.albumArt != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: Image.network(
                                                  audioState.currentSong!.albumArt!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.music_note,
                                                      color: AppTheme.darkTextSecondary,
                                                    );
                                                  },
                                                ),
                                              )
                                            : Icon(
                                                Icons.music_note,
                                                color: AppTheme.darkTextSecondary,
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              audioState.currentSong?.title ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              audioState.currentSong?.artist ?? '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.darkTextSecondary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.favorite_border),
                                        color: AppTheme.darkTextSecondary,
                                        iconSize: 20,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),

                                // Center: Player controls
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.shuffle),
                                            color: AppTheme.darkTextSecondary,
                                            iconSize: 20,
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.skip_previous),
                                            color: Colors.white,
                                            iconSize: 28,
                                            onPressed: () => audioNotifier.playPrevious(),
                                          ),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                audioState.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                              ),
                                              color: Colors.black,
                                              iconSize: 24,
                                              onPressed: () => audioNotifier.togglePlayPause(),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.skip_next),
                                            color: Colors.white,
                                            iconSize: 28,
                                            onPressed: () => audioNotifier.playNext(),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.repeat),
                                            color: AppTheme.darkTextSecondary,
                                            iconSize: 20,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                      // Time display
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _formatDuration(audioState.position),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.darkTextSecondary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _formatDuration(audioState.duration ?? Duration.zero),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.darkTextSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right: Volume and other controls
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.queue_music),
                                        color: AppTheme.darkTextSecondary,
                                        iconSize: 20,
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.devices),
                                        color: AppTheme.darkTextSecondary,
                                        iconSize: 20,
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.volume_up),
                                        color: AppTheme.darkTextSecondary,
                                        iconSize: 20,
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Slider(
                                          value: 0.5,
                                          onChanged: (value) {},
                                          activeColor: Colors.white,
                                          inactiveColor: AppTheme.darkTextSecondary.withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Right Sidebar (400px) - Now Playing
          const NowPlayingPanel(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AudioState audioState) {
    final progress = audioState.duration != null && audioState.duration!.inSeconds > 0
        ? audioState.position.inSeconds / audioState.duration!.inSeconds
        : 0.0;

    return SizedBox(
      height: 4,
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        backgroundColor: AppTheme.darkHoverColor,
        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.darkPrimaryColor),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
