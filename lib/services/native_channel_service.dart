import 'package:flutter/services.dart';

class NativeChannelService {
  static const platform = MethodChannel('com.example.soundboard/widget');
  
  // Callback for widget taps
  static Function(String)? onWidgetTapped;
  
  static void init() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'widgetTapped') {
        final uri = call.arguments as String?;
        if (uri != null && onWidgetTapped != null) {
          onWidgetTapped!(uri);
        }
      }
    });
  }
  
  static Future<String?> getInitialIntent() async {
    try {
      final String? result = await platform.invokeMethod('getInitialIntent');
      return result;
    } catch (e) {
      print('Error getting initial intent: $e');
      return null;
    }
  }
}