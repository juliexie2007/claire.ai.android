import 'package:flutter/material.dart';
import 'audio_recorder_screen.dart';
import 'transcription_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.mic),
              label: const Text("Voice Recorder"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const AudioRecorderScreen(),
                ));
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text("Transcription History"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const TranscriptionHistoryScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
