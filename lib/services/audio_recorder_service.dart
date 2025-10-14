// lib/services/audio_recorder_service.dart
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;

  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  bool _isPlaying = false;

  String? _recordingPath;

  /// Call once (e.g., in initState of your screen)
  Future<void> init() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    // Request mic permission
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }

    // Open recorder
    await _recorder!.openRecorder();
    _isRecorderInitialized = true;

    // Open player
    await _player!.openPlayer();
    _isPlayerInitialized = true;
  }

  /// Call in dispose of your screen
  Future<void> dispose() async {
    try {
      if (_player?.isPlaying ?? false) {
        await _player!.stopPlayer();
      }
    } catch (_) {}
    await _recorder?.closeRecorder();
    await _player?.closePlayer();

    _recorder = null;
    _player = null;
    _isRecorderInitialized = false;
    _isPlayerInitialized = false;
    _isPlaying = false;
  }

  /// Start recording to an .aac file
  Future<void> startRecording() async {
    if (!_isRecorderInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(
      toFile: path,
      codec: Codec.aacADTS, // matches your earlier working setup
    );
    _recordingPath = path;
  }

  /// Stop recording and return the saved file path
  Future<String?> stopRecording() async {
    if (!_isRecorderInitialized) return null;
    await _recorder!.stopRecorder();
    return _recordingPath;
  }

  /// Play the last recorded file (if any)
  Future<void> playRecording() async {
    if (!_isPlayerInitialized || _recordingPath == null) return;

    final file = File(_recordingPath!);
    if (!file.existsSync()) return;
    if (file.lengthSync() < 1000) {
      // Tiny file often means empty/invalid recording
      return;
    }

    // Stop current playback if any
    if (_player!.isPlaying) {
      await _player!.stopPlayer();
    }

    await _player!.startPlayer(
      fromURI: _recordingPath,
      whenFinished: () {
        _isPlaying = false;
      },
    );
    _isPlaying = true;
  }

  /// Stop playback if currently playing
  Future<void> stopPlaying() async {
    if (!_isPlayerInitialized) return;
    if (_player!.isPlaying) {
      await _player!.stopPlayer();
    }
    _isPlaying = false;
  }

  // ---- Getters (safe for your UI) ----
  bool get isRecording => _recorder?.isRecording ?? false;
  bool get isPlaying => _isPlaying;
  String? get lastRecordingPath => _recordingPath;
}
