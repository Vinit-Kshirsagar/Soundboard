import 'package:home_widget/home_widget.dart';
import '../data/models/sound.dart';
import 'storage_service.dart';

class WidgetService {
  WidgetService._internal();
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;

  static const String _widgetSoundIdKey = 'widget_sound_id';
  static const String _widgetSoundNameKey = 'widget_sound_name';
  static const String _widgetSoundColorKey = 'widget_sound_color';
  
  final storage = StorageService();

  // Initialize widget (call in main.dart)
  Future<void> init() async {
    await HomeWidget.setAppGroupId('group.soundboard.widget');
  }

  // Set the sound to be used in the widget
  Future<void> setWidgetSound(Sound sound) async {
    print('💾 Saving widget sound: ${sound.id} - ${sound.name}');
    
    // Save to app storage
    final prefs = storage.prefs;
    await prefs?.setString(_widgetSoundIdKey, sound.id);
    await prefs?.setString(_widgetSoundNameKey, sound.name);
    await prefs?.setInt(_widgetSoundColorKey, sound.color.value);

    print('📤 Updating widget data...');
    // Update widget data (for the widget to display)
    await HomeWidget.saveWidgetData<String>('sound_id', sound.id);
    await HomeWidget.saveWidgetData<String>('sound_name', sound.name);
    await HomeWidget.saveWidgetData<int>('sound_color', sound.color.value);
    
    print('🔄 Triggering widget update...');
    // Trigger widget update
    await HomeWidget.updateWidget(
      androidName: 'SoundboardWidgetProvider',
      iOSName: 'SoundboardWidget',
    );
    print('✅ Widget update complete');
  }

  // Get the currently selected widget sound ID
  Future<String?> getWidgetSoundId() async {
    final prefs = storage.prefs;
    return prefs?.getString(_widgetSoundIdKey);
  }

  // Get the currently selected widget sound name
  Future<String?> getWidgetSoundName() async {
    final prefs = storage.prefs;
    return prefs?.getString(_widgetSoundNameKey);
  }

  // Handle widget tap (play the sound)
  Future<String?> handleWidgetTap() async {
    final soundId = await getWidgetSoundId();
    return soundId;
  }
}