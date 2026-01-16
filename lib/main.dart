import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/settings/settings_screen.dart';
import 'services/storage_service.dart';
import 'services/widget_service.dart';
import 'services/sound_player.dart';
import 'services/native_channel_service.dart';
import 'data/repositories/category_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage before running app
  await StorageService().init();
  await WidgetService().init();
  
  // Initialize native channel
  NativeChannelService.init();
  
  runApp(const SoundboardApp());
}

class SoundboardApp extends StatelessWidget {
  const SoundboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
      onGenerateRoute: (settings) {
        // Handle deep links from widget
        if (settings.name == '/play-widget-sound') {
          return MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(playWidgetSound: true),
          );
        }
        return null;
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final bool playWidgetSound;
  
  const MainNavigationScreen({
    super.key,
    this.playWidgetSound = false,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Listen for widget taps via native channel
    NativeChannelService.onWidgetTapped = (uri) {
      print('🎯 Widget tapped via native channel! URI: $uri');
      _playWidgetSound();
    };
    
    // Also listen to home_widget (backup method)
    HomeWidget.widgetClicked.listen((uri) {
      print('🎯 Widget tapped via home_widget! URI: $uri');
      _playWidgetSound();
    });
    
    // Check for initial widget launch
    _checkInitialWidgetLaunch();
  }
  
  Future<void> _checkInitialWidgetLaunch() async {
    // Check native channel first
    await Future.delayed(const Duration(milliseconds: 300));
    final nativeIntent = await NativeChannelService.getInitialIntent();
    print('🚀 Native initial intent: $nativeIntent');
    
    if (nativeIntent != null && nativeIntent.contains('play')) {
      print('▶️ Playing from native intent');
      await _playWidgetSound();
      return;
    }
    
    // Fallback to home_widget
    final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    print('🚀 Home widget initial URI: $initialUri');
    
    if (initialUri != null && initialUri.toString().contains('play')) {
      print('▶️ Playing from home widget');
      await _playWidgetSound();
    }
  }
  
  Future<void> _playWidgetSound() async {
    print('🎶 _playWidgetSound called');
    final widgetService = WidgetService();
    final soundId = await widgetService.getWidgetSoundId();
    
    print('🔍 Widget sound ID: $soundId');
    
    if (soundId != null && soundId.isNotEmpty) {
      final categoryRepo = CategoryRepository();
      final allSounds = categoryRepo.getAllSounds();
      
      print('📚 Total sounds available: ${allSounds.length}');
      
      try {
        final sound = allSounds.firstWhere((s) => s.id == soundId);
        print('✅ Found sound: ${sound.name} at ${sound.assetPath}');
        
        final player = SoundPlayer();
        await player.play(sound.assetPath);
        print('🔊 Playing sound...');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Playing: ${sound.name}'),
              duration: const Duration(seconds: 2),
              backgroundColor: sound.color,
            ),
          );
        }
      } catch (e) {
        print('❌ Error playing widget sound: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Sound not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      print('⚠️ No sound ID found in widget preferences');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No widget sound configured'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}