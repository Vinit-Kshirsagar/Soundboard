import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  SoundPlayer._internal();

  static final SoundPlayer _instance = SoundPlayer._internal();
  factory SoundPlayer() => _instance;

  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String assetPath) async {
    await _player.stop();
    await _player.play(AssetSource(assetPath));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}