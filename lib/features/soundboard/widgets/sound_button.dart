import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/sound.dart';
import '../../../data/repositories/favorites_repository.dart';
import '../../../services/sound_player.dart';

class SoundButton extends StatefulWidget {
  final Sound sound;
  final VoidCallback? onFavoriteChanged;

  const SoundButton({
    super.key,
    required this.sound,
    this.onFavoriteChanged,
  });

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final player = SoundPlayer();
  final favoritesRepo = FavoritesRepository();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = favoritesRepo.isFavorite(widget.sound.id);
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    _controller.forward().then((_) => _controller.reverse());
    player.play(widget.sound.assetPath);
  }

  void _onLongPress() {
    HapticFeedback.lightImpact();
    _showFavoriteSheet();
  }

  void _showFavoriteSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.music_note,
              size: 48,
              color: widget.sound.color,
            ),
            const SizedBox(height: 16),
            Text(
              widget.sound.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.sound.description != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.sound.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: _isFavorite ? 'Unfavorite' : 'Favorite',
                  color: Colors.red,
                  onTap: () async {
                    await favoritesRepo.toggleFavorite(widget.sound.id);
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    widget.onFavoriteChanged?.call();
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? 'Added to favorites'
                                : 'Removed from favorites',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.play_arrow,
                  label: 'Play',
                  color: widget.sound.color,
                  onTap: () {
                    player.play(widget.sound.assetPath);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _onTap,
        onLongPress: _onLongPress,
        splashColor: widget.sound.color.withOpacity(0.3),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.sound.color.withOpacity(0.2),
                    widget.sound.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.sound.color.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: widget.sound.color,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.sound.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.sound.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isFavorite)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}