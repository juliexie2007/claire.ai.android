import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/audio_recorder_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // On web, .env must be an asset. Handle errors gracefully so you don't get a blank screen.
  try {
    await dotenv.load(fileName: 'assets/.env', mergeWith: {
      // Optional: allow passing a key at build time for non-web:
      'OPENAI_API_KEY': const String.fromEnvironment('OPENAI_API_KEY'),
    });
  } catch (e) {
    // Don’t fail hard; just log. Your app will still run, and you can show a friendly UI message.
    debugPrint('dotenv load failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Recorder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AudioRecorderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
