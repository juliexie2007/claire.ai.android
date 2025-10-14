import 'package:flutter/material.dart';
import '../models/transcription_entry.dart';
import 'transcription_detail_screen.dart';

class TranscriptionHistoryScreen extends StatelessWidget {
  const TranscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load from Hive box in real app
    final entries = <TranscriptionEntry>[];

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Transcripts")),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (_, i) {
          final e = entries[i];
          return ListTile(
            title: Text(e.transcription, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(e.timestamp.toString()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => TranscriptionDetailScreen(entry: e),
              ));
            },
          );
        },
      ),
    );
  }
}
