import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/sound.dart';
import '../../../services/sound_player.dart';

class SoundButton extends StatefulWidget {
  final Sound sound;

  const SoundButton({super.key, required this.sound});

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _onTap,
        splashColor: widget.sound.color.withOpacity(0.3),
        child: Container(
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
      ),
    );
  }
}