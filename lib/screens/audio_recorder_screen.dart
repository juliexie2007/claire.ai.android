import 'package:flutter/material.dart';
import '../services/audio_recorder_service.dart';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({super.key});

  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final AudioService _audioService = AudioService();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _lastRecording;

  @override
  void initState() {
    super.initState();
    _audioService.init();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioService.stopRecording();
      setState(() {
        _isRecording = false;
        _lastRecording = path;
      });
    } else {
      await _audioService.startRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _audioService.stopPlayback();
      setState(() {
        _isPlaying = false;
      });
    } else {
      if (_lastRecording != null) {
        await _audioService.startPlayback();
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRecording
                  ? "Recording..."
                  : _isPlaying
                  ? "Playing..."
                  : "Tap a button to record or play",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleRecording,
                  child: Text(_isRecording ? "Stop Recording" : "Record"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _lastRecording != null ? _togglePlayback : null,
                  child: Text(_isPlaying ? "Stop Playback" : "Play"),
                ),
              ],
            ),
            if (_lastRecording != null) ...[
              const SizedBox(height: 20),
              Text("Last recording saved at:"),
              Text(
                _lastRecording!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
