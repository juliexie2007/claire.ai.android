import 'package:flutter/material.dart';
import '../models/transcription_entry.dart';
import '../services/openai_service.dart';

class TranscriptionDetailScreen extends StatefulWidget {
  final TranscriptionEntry entry;
  const TranscriptionDetailScreen({super.key, required this.entry});

  @override
  State<TranscriptionDetailScreen> createState() => _TranscriptionDetailScreenState();
}

class _TranscriptionDetailScreenState extends State<TranscriptionDetailScreen> {
  final aiService = OpenAIService();
  String? response;
  bool loading = false;

  Future<void> _analyze(String type) async {
    setState(() => loading = true);
    response = await aiService.analyze(widget.entry.transcription, promptType: type);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transcript Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.entry.transcription),
            const SizedBox(height: 20),
            Wrap(spacing: 10, children: [
              ElevatedButton(onPressed: () => _analyze("summary"), child: const Text("Summarize")),
              ElevatedButton(onPressed: () => _analyze("tasks"), child: const Text("Extract Tasks")),
              ElevatedButton(onPressed: () => _analyze("insights"), child: const Text("Insights")),
            ]),
            if (loading) const CircularProgressIndicator(),
            if (response != null) Expanded(child: SingleChildScrollView(child: Text(response!))),
          ],
        ),
      ),
    );
  }
}
