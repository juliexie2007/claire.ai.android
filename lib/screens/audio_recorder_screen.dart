import 'dart:io';
import 'package:flutter/material.dart';
import '../services/audio_recorder_service.dart';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({super.key});

  @override
  State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final AudioRecorderService _recorderService = AudioRecorderService();
  bool _isRecording = false;
  String? _currentFilePath;

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      final filePath = await _recorderService.stopRecording();
      setState(() {
        _isRecording = false;
        _currentFilePath = filePath;
      });

      if (filePath != null && await File(filePath).exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recording saved: ${filePath.split('/').last}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Recording failed to save.")),
        );
      }
    } else {
      // Start recording
      final filePath = await _recorderService.startRecording();
      setState(() {
        _isRecording = true;
        _currentFilePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recording started...")),
      );
    }
  }

  Future<void> _playRecording() async {
    if (_currentFilePath != null && await File(_currentFilePath!).exists()) {
      await _recorderService.playRecording(_currentFilePath!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No recording available to play.")),
      );
    }
  }

  @override
  void dispose() {
    _recorderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audio Recorder")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playRecording,
              child: const Text("Play Recording"),
            ),
          ],
        ),
      ),
    );
  }
}
