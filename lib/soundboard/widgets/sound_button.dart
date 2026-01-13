import 'package:flutter/material.dart';
import '../models/sound.dart';
import '../services/sound_player.dart';

class SoundButton extends StatelessWidget {
  final Sound sound;

  const SoundButton({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    final player = SoundPlayer();

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => player.play(sound.assetPath),
      splashColor: sound.color.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          color: sound.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sound.color.withOpacity(0.4),
          ),
        ),
        child: Center(
          child: Text(
            sound.name.toUpperCase(),
            style: TextStyle(
              color: sound.color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
