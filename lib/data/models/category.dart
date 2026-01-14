import 'package:flutter/material.dart';
import 'sound.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<Sound> sounds;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.sounds,
  });
}