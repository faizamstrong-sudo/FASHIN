import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/song_model.dart';

class NowPlayingPanel extends ConsumerWidget {
  const NowPlayingPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final song = audioState.currentSong;

    if (song == null) {
      return Container(
        width: 400,
        color: AppTheme.darkSidebarColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.music_note,
                size: 80,
                color: AppTheme.darkTextSecondary.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No song playing',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a song to play',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.darkTextSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 400,
      color: AppTheme.darkSidebarColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(
                    Icons.queue_music,
                    color: AppTheme.darkTextSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Now Playing',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Album Art with shadow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: song.albumArt != null
                        ? Image.network(
                            song.albumArt!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderArt();
                            },
                          )
                        : _buildPlaceholderArt(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Song Title and Artist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        song.artist,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.darkTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Verified badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.darkPrimaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Artist Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.darkPrimaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: AppTheme.darkPrimaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.artist,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Artist',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.darkTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.people,
                      label: 'Monthly listeners',
                      value: _formatListeners(1234567),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.music_note,
                      label: 'Total tracks',
                      value: '42',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Song Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Song Information',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem('Duration', _formatDuration(audioState.duration)),
                  _buildInfoItem('Album', song.album ?? 'Unknown Album'),
                  _buildInfoItem('Genre', 'Pop'),
                  _buildInfoItem('Released', '2024'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Currently Playing Indicator
            if (audioState.isPlaying)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.darkPrimaryColor.withOpacity(0.2),
                        AppTheme.darkPrimaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.darkPrimaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle_filled,
                        color: AppTheme.darkPrimaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Now Playing',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatPosition(audioState.position),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.darkTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _buildPlayingAnimation(),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderArt() {
    return Container(
      color: AppTheme.darkCardColor,
      child: Center(
        child: Icon(
          Icons.album,
          size: 120,
          color: AppTheme.darkTextSecondary.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.darkTextSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.darkTextSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.darkTextSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayingAnimation() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            width: 3,
            height: 12 + (index * 2).toDouble(),
            decoration: BoxDecoration(
              color: AppTheme.darkPrimaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  String _formatListeners(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatPosition(Duration position) {
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
