import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/youtube_service.dart';
import '../../models/song_model.dart';
import '../../core/theme/app_theme.dart';

class HomeScreenDesktop extends ConsumerStatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  ConsumerState<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends ConsumerState<HomeScreenDesktop> {
  final YouTubeService _youtubeService = YouTubeService();

  // Indonesian popular songs
  final List<Song> _indoSongs = [
    Song(id: '1', title: 'Tak Segampang Itu', artist: 'Anggi Marito'),
    Song(id: '2', title: 'Lathi', artist: 'Weird Genius ft. Sara Fajira'),
    Song(id: '3', title: 'Hanya Satu Persinggahan', artist: 'Tulus'),
    Song(id: '4', title: 'Pilu Membiru', artist: 'Kunto Aji'),
    Song(id: '5', title: 'Untuk Perempuan Yang Sedang Dalam Pelukan', artist: 'Payung Teduh'),
    Song(id: '6', title: 'Konselatif', artist: 'Nadin Amizah'),
  ];

  // Western popular songs
  final List<Song> _westernSongs = [
    Song(id: '9', title: 'Anti-Hero', artist: 'Taylor Swift'),
    Song(id: '10', title: 'Blinding Lights', artist: 'The Weeknd'),
    Song(id: '11', title: 'Levitating', artist: 'Dua Lipa'),
    Song(id: '12', title: 'Shape of You', artist: 'Ed Sheeran'),
    Song(id: '13', title: 'Die With A Smile', artist: 'Lady Gaga, Bruno Mars'),
    Song(id: '14', title: 'Flowers', artist: 'Miley Cyrus'),
  ];

  // Featured playlists
  final List<Map<String, dynamic>> _featuredPlaylists = [
    {'title': 'Today\'s Top Hits', 'subtitle': 'The hottest tracks right now'},
    {'title': 'RapCaviar', 'subtitle': 'New music from Lil Baby and more'},
    {'title': 'Rock Classics', 'subtitle': 'Rock legends & epic songs'},
    {'title': 'Chill Vibes', 'subtitle': 'Kick back to the best new chill hits'},
    {'title': 'Indonesian Hits', 'subtitle': 'Lagu-lagu terpopuler Indonesia'},
    {'title': 'Workout', 'subtitle': 'Get your heart pumping'},
  ];

  Future<void> _playSong(Song song) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Searching ${song.title}...'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.darkCardColor,
        ),
      );

      final results = await _youtubeService.searchSongs(
        '${song.title} ${song.artist}',
        maxResults: 1,
      );

      if (results.isNotEmpty) {
        await ref.read(audioProvider.notifier).playSong(results[0]);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Song not found'),
              backgroundColor: AppTheme.darkCardColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.darkCardColor,
          ),
        );
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Header
            Container(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.darkCardColor,
                    AppTheme.darkBackgroundColor,
                  ],
                ),
              ),
              child: Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Featured Playlists (3 columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Playlists',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3.5,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final playlist = _featuredPlaylists[index];
                      return _buildFeaturedPlaylistCard(
                        playlist['title'],
                        playlist['subtitle'],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recently Played Section
            _buildSection(
              'Recently Played',
              _indoSongs.take(5).toList(),
            ),

            const SizedBox(height: 24),

            // Your Top Mixes
            _buildSection(
              'Your Top Mixes',
              _westernSongs.take(5).toList(),
            ),

            const SizedBox(height: 24),

            // Made For You
            _buildSection(
              'Made For You',
              [..._indoSongs.take(3), ..._westernSongs.take(3)].toList(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPlaylistCard(String title, String subtitle) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Handle playlist tap
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.darkCardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.darkHoverColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      Icons.album,
                      size: 40,
                      color: AppTheme.darkTextSecondary.withOpacity(0.5),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Song> songs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildSongCard(songs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongCard(Song song) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _playSong(song),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Album Art
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.darkHoverColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: song.albumArt != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            song.albumArt!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderArt();
                            },
                          ),
                        )
                      : _buildPlaceholderArt(),
                ),
                const SizedBox(height: 12),
                // Song Title
                Text(
                  song.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Artist
                Text(
                  song.artist,
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
        ),
      ),
    );
  }

  Widget _buildPlaceholderArt() {
    return Center(
      child: Icon(
        Icons.music_note,
        size: 60,
        color: AppTheme.darkTextSecondary.withOpacity(0.3),
      ),
    );
  }
}
