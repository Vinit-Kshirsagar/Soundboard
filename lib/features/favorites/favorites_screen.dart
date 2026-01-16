import 'package:flutter/material.dart';
import '../../data/repositories/favorites_repository.dart';
import '../soundboard/widgets/sound_button.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favoritesRepo = FavoritesRepository();

  void _refreshFavorites() {
    setState(() {
      // Triggers rebuild to fetch latest favorites
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSounds = favoritesRepo.getFavoriteSounds();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (favoriteSounds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${favoriteSounds.length} ${favoriteSounds.length == 1 ? 'sound' : 'sounds'}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: favoriteSounds.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(favoriteSounds),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Long press any sound and tap the heart icon to add it here',
              style: TextStyle(
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List favoriteSounds) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Favorite Sounds',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: favoriteSounds.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return SoundButton(
                  sound: favoriteSounds[index],
                  onFavoriteChanged: _refreshFavorites,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}