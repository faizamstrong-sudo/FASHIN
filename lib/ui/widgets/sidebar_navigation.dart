import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/playlist_provider.dart';
import '../../core/theme/app_theme.dart';

class SidebarNavigation extends ConsumerStatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  ConsumerState<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends ConsumerState<SidebarNavigation> {
  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistProvider);
    final theme = Theme.of(context);

    return Container(
      width: 320,
      color: AppTheme.darkSidebarColor,
      child: Column(
        children: [
          // Logo / App Title
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.darkPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'FASHIN Play',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Menu
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            isSelected: widget.selectedIndex == 0,
            onTap: () => widget.onItemTapped(0),
          ),
          _buildNavItem(
            icon: Icons.search,
            label: 'Search',
            isSelected: widget.selectedIndex == 1,
            onTap: () => widget.onItemTapped(1),
          ),
          _buildNavItem(
            icon: Icons.library_music,
            label: 'Your Library',
            isSelected: widget.selectedIndex == 2,
            onTap: () => widget.onItemTapped(2),
          ),

          const SizedBox(height: 24),

          // Create Playlist Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showCreatePlaylistDialog(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Create Playlist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkHoverColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Playlists Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Playlists',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.darkTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (playlistState.userPlaylists.isNotEmpty)
                  Text(
                    '${playlistState.userPlaylists.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTextSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // Playlists List
          Expanded(
            child: playlistState.userPlaylists.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.queue_music,
                            size: 48,
                            color: AppTheme.darkTextSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No playlists yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.darkTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first playlist',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.darkTextSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: playlistState.userPlaylists.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final playlist = playlistState.userPlaylists[index];
                      return _buildPlaylistItem(
                        name: playlist.name,
                        songCount: playlist.songs.length,
                        onTap: () {
                          // Navigate to playlist detail
                        },
                      );
                    },
                  ),
          ),

          // Recent Plays / Liked Songs Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.darkTextSecondary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildNavItem(
                  icon: Icons.favorite,
                  label: 'Liked Songs',
                  isSelected: false,
                  onTap: () {
                    // Handle liked songs
                  },
                  isCompact: true,
                ),
                _buildNavItem(
                  icon: Icons.history,
                  label: 'Recent Plays',
                  isSelected: false,
                  onTap: () {
                    // Handle recent plays
                  },
                  isCompact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isCompact = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 0 : 8,
        vertical: isCompact ? 4 : 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: isCompact ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.darkHoverColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppTheme.darkPrimaryColor
                      : AppTheme.darkTextSecondary,
                  size: isCompact ? 20 : 24,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isCompact ? 14 : 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistItem({
    required String name,
    required int songCount,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.darkHoverColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.queue_music,
                  color: AppTheme.darkTextSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$songCount ${songCount == 1 ? 'song' : 'songs'}',
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
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCardColor,
        title: const Text(
          'Create Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: AppTheme.darkTextSecondary),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.darkTextSecondary),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppTheme.darkPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.darkTextSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                ref.read(playlistProvider.notifier).createPlaylist(
                  nameController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
