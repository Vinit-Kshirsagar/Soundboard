import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/sound.dart';

class CategoryRepository {
  static final List<Category> _categories = [
    Category(
      id: 'f1',
      name: 'F1 Engines',
      description: 'Formula 1 engine sounds',
      icon: Icons.sports_motorsports,
      color: const Color(0xFFE74C3C),
      sounds: const [
        Sound(
          id: 'f1_v12',
          name: 'V12 Engine',
          assetPath: 'sounds/f1_V12.mp3',
          color: Color(0xFFE74C3C),
          description: 'Classic V12 scream',
        ),
        Sound(
          id: 'f1_v8',
          name: 'V8 Engine',
          assetPath: 'sounds/f1_V8.mp3',
          color: Color(0xFFC0392B),
          description: 'Powerful V8 roar',
        ),
        Sound(
          id: 'f1_v6_turbo',
          name: 'V6 Turbo',
          assetPath: 'sounds/f1_V6.mp3',
          color: Color(0xFF992D22),
          description: 'Modern hybrid sound',
        ),
        Sound(
          id: 'f1_H16',
          name: 'f1_H16',
          assetPath: 'sounds/f1_H16.mp3',
          color: Color(0xFFD35400),
          description: 'Early F1 engine',
        ),
      ],
    ),
    Category(
      id: 'animals',
      name: 'Animals',
      description: 'Animal sounds from around the world',
      icon: Icons.pets,
      color: const Color(0xFF27AE60),
      sounds: const [
        Sound(
          id: 'lion_roar',
          name: 'Lion Roar',
          assetPath: 'sounds/lion.mp3',
          color: Color(0xFF27AE60),
          description: 'Powerful lion roar',
        ),
        Sound(
          id: 'elephant',
          name: 'Elephant',
          assetPath: 'sounds/elephant.mp3',
          color: Color(0xFF229954),
          description: 'Elephant trumpet',
        ),
        Sound(
          id: 'wolf_howl',
          name: 'Wolf Howl',
          assetPath: 'sounds/wolf.mp3',
          color: Color(0xFF1E8449),
          description: 'Wolf howling at moon',
        ),
        Sound(
          id: 'eagle',
          name: 'Eagle',
          assetPath: 'sounds/eagle.mp3',
          color: Color(0xFF186A3B),
          description: 'Eagle screech',
        ),
      ],
    ),
    Category(
      id: 'guns',
      name: 'Guns & Weapons',
      description: 'Firearm and weapon sounds',
      icon: Icons.gps_fixed,
      color: const Color(0xFF7F8C8D),
      sounds: const [
        Sound(
          id: 'ak47',
          name: 'AK-47',
          assetPath: 'sounds/ak47.mp3',
          color: Color(0xFF7F8C8D),
          description: 'AK-47 burst',
        ),
        Sound(
          id: 'shotgun',
          name: 'Shotgun',
          assetPath: 'sounds/shotgun.mp3',
          color: Color(0xFF707B7C),
          description: 'Shotgun blast',
        ),
        Sound(
          id: 'sniper',
          name: 'Sniper',
          assetPath: 'sounds/sniper.mp3',
          color: Color(0xFF5D6D7E),
          description: 'Sniper rifle shot',
        ),
        Sound(
          id: 'reload',
          name: 'Reload',
          assetPath: 'sounds/reload.mp3',
          color: Color(0xFF515A5A),
          description: 'Gun reload sound',
        ),
      ],
    ),
    Category(
      id: 'aircraft',
      name: 'Aircraft',
      description: 'Airplane and helicopter sounds',
      icon: Icons.flight,
      color: const Color(0xFF3498DB),
      sounds: const [
        Sound(
          id: 'jet_takeoff',
          name: 'Jet Takeoff',
          assetPath: 'sounds/jet_takeoff.mp3',
          color: Color(0xFF3498DB),
          description: 'Commercial jet taking off',
        ),
        Sound(
          id: 'helicopter',
          name: 'Helicopter',
          assetPath: 'sounds/helicopter.mp3',
          color: Color(0xFF2E86C1),
          description: 'Helicopter rotors',
        ),
        Sound(
          id: 'fighter_jet',
          name: 'Fighter Jet',
          assetPath: 'sounds/fighter.mp3',
          color: Color(0xFF2874A6),
          description: 'Military fighter flyby',
        ),
        Sound(
          id: 'landing',
          name: 'Landing',
          assetPath: 'sounds/landing.mp3',
          color: Color(0xFF21618C),
          description: 'Aircraft landing',
        ),
      ],
    ),
  ];

  List<Category> getAllCategories() {
    return _categories;
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Sound> getAllSounds() {
    return _categories.expand((cat) => cat.sounds).toList();
  }
}