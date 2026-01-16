import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._internal();
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  static const String _favoritesKey = 'favorite_sound_ids';
  SharedPreferences? _prefs;

  // Initialize (call this in main.dart before runApp)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get all favorite sound IDs
  List<String> getFavoriteIds() {
    return _prefs?.getStringList(_favoritesKey) ?? [];
  }

  // Save favorite IDs
  Future<bool> saveFavoriteIds(List<String> ids) async {
    return await _prefs?.setStringList(_favoritesKey, ids) ?? false;
  }

  // Check if a sound is favorited
  bool isFavorite(String soundId) {
    return getFavoriteIds().contains(soundId);
  }

  // Add to favorites
  Future<bool> addFavorite(String soundId) async {
    final favorites = getFavoriteIds();
    if (!favorites.contains(soundId)) {
      favorites.add(soundId);
      return await saveFavoriteIds(favorites);
    }
    return true;
  }

  // Remove from favorites
  Future<bool> removeFavorite(String soundId) async {
    final favorites = getFavoriteIds();
    favorites.remove(soundId);
    return await saveFavoriteIds(favorites);
  }

  // Toggle favorite
  Future<bool> toggleFavorite(String soundId) async {
    if (isFavorite(soundId)) {
      return await removeFavorite(soundId);
    } else {
      return await addFavorite(soundId);
    }
  }
}