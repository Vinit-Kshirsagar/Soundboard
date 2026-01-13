import 'package:flutter/material.dart';
import 'models/sound_data.dart';
import 'widgets/sound_button.dart';

class SoundboardScreen extends StatelessWidget {
  const SoundboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soundboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: sounds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,        // adaptive later
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return SoundButton(sound: sounds[index]);
          },
        ),
      ),
    );
  }
}
