import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../services/audio_recorder_service.dart';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({super.key});

  @override
  State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorderService _audio = AudioRecorderService();

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;

  bool _ready = false;
  bool _isRecording = false;
  String? _lastPath;

  @override
  void initState() {
    super.initState();
    _init();
    _ticker = createTicker((elapsed) {
      if (_isRecording) {
        setState(() {
          _elapsed = elapsed;
        });
      }
    });
  }

  Future<void> _init() async {
    try {
      await _audio.init();
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Init failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _audio.dispose();
    super.dispose();
  }

  Future<void> _onRecordPressed() async {
    if (!_ready) return;

    if (_isRecording) {
      final path = await _audio.stopRecording();
      _ticker.stop();
      setState(() {
        _isRecording = false;
        _lastPath = path;
      });
    } else {
      await _audio.startRecording();
      _ticker.start();
      setState(() {
        _isRecording = true;
        _elapsed = Duration.zero;
      });
    }
  }

  Future<void> _onPlayPressed() async {
    if (_audio.isPlaying) {
      await _audio.stopPlaying();
    } else {
      await _audio.playRecording();
    }
    setState(() {});
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final canPlay = _audio.lastRecordingPath != null && !_isRecording;

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Recorder')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isRecording ? Icons.mic : Icons.mic_none,
                size: 72,
                color: _isRecording ? Colors.red : Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                _isRecording
                    ? 'Recording… ${_fmt(_elapsed)}'
                    : _ready
                    ? (canPlay ? 'Recording ready' : 'Ready to record')
                    : 'Initializing…',
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _ready ? _onRecordPressed : null,
                    icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
                    label: Text(_isRecording ? 'Stop' : 'Record'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording ? Colors.red : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: canPlay ? _onPlayPressed : null,
                    icon: Icon(_audio.isPlaying ? Icons.stop : Icons.play_arrow),
                    label: Text(_audio.isPlaying ? 'Stop' : 'Play'),
                  ),
                ],
              ),
              if (_lastPath != null) ...[
                const SizedBox(height: 16),
                const Text('Saved file:'),
                Text(
                  _lastPath!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
