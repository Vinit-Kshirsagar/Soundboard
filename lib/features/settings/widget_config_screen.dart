import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/sound.dart';
import '../../services/widget_service.dart';
import '../../services/sound_player.dart';

class WidgetConfigScreen extends StatefulWidget {
  const WidgetConfigScreen({super.key});

  @override
  State<WidgetConfigScreen> createState() => _WidgetConfigScreenState();
}

class _WidgetConfigScreenState extends State<WidgetConfigScreen> {
  final categoryRepo = CategoryRepository();
  final widgetService = WidgetService();
  Sound? selectedSound;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedSound();
  }

  Future<void> _loadSelectedSound() async {
    final soundId = await widgetService.getWidgetSoundId();
    if (soundId != null) {
      final allSounds = categoryRepo.getAllSounds();
      setState(() {
        selectedSound = allSounds.firstWhere(
          (s) => s.id == soundId,
          orElse: () => allSounds.first,
        );
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectSound(Sound sound) async {
    print('🎵 Selecting sound for widget: ${sound.name} (${sound.id})');
    
    setState(() {
      selectedSound = sound;
    });
    
    await widgetService.setWidgetSound(sound);
    print('✅ Widget sound saved');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Widget updated to "${sound.name}"'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Test',
            onPressed: () async {
              final player = SoundPlayer();
              await player.play(sound.assetPath);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Widget Sound',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildSoundList()),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C5CE7).withOpacity(0.2),
            const Color(0xFF6C5CE7).withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.widgets,
                  color: Color(0xFF6C5CE7),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Home Screen Widget',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap a sound to set it as your widget',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedSound != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selectedSound!.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedSound!.color.withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: selectedSound!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current: ${selectedSound!.name}',
                    style: TextStyle(
                      color: selectedSound!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoundList() {
    final categories = categoryRepo.getAllCategories();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, catIndex) {
        final category = categories[catIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    color: category.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: category.color,
                    ),
                  ),
                ],
              ),
            ),
            ...category.sounds.map((sound) => _buildSoundTile(sound)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildSoundTile(Sound sound) {
    final isSelected = selectedSound?.id == sound.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: sound.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.music_note,
            color: sound.color,
            size: 24,
          ),
        ),
        title: Text(
          sound.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: sound.description != null
            ? Text(
                sound.description!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              )
            : null,
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: sound.color,
              )
            : Icon(
                Icons.circle_outlined,
                color: Colors.grey[700],
              ),
        onTap: () => _selectSound(sound),
      ),
    );
  }
}