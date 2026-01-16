import '../models/sound.dart';
import '../../services/storage_service.dart';
import 'category_repository.dart';


class FavoritesRepository {
  final StorageService _storage = StorageService();
  final CategoryRepository _categoryRepo = CategoryRepository();

  // Get all favorited sounds
  List<Sound> getFavoriteSounds() {
    final favoriteIds = _storage.getFavoriteIds();
    final allSounds = _categoryRepo.getAllSounds();
    
    return allSounds.where((sound) => favoriteIds.contains(sound.id)).toList();
  }

  // Check if a sound is favorited
  bool isFavorite(String soundId) {
    return _storage.isFavorite(soundId);
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String soundId) async {
    return await _storage.toggleFavorite(soundId);
  }

  // Get count of favorites
  int getFavoriteCount() {
    return _storage.getFavoriteIds().length;
  }
}