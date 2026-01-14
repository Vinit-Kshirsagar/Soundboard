import 'package:flutter/material.dart';

class Sound {
  final String id;
  final String name;
  final String assetPath;
  final Color color;
  final String? description;
  final bool isFavorite;

  const Sound({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.color,
    this.description,
    this.isFavorite = false,
  });

  Sound copyWith({
    String? id,
    String? name,
    String? assetPath,
    Color? color,
    String? description,
    bool? isFavorite,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      color: color ?? this.color,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}