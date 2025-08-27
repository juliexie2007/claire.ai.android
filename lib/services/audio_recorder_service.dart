import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  String? _recordingPath;

  /// Initialize recorder and player
  Future<void> init() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    await _recorder!.openRecorder();
    _isRecorderInitialized = true;

    await _player!.openPlayer();
    _isPlayerInitialized = true;
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _recorder?.closeRecorder();
    _recorder = null;
    _isRecorderInitialized = false;

    await _player?.closePlayer();
    _player = null;
    _isPlayerInitialized = false;
  }

  /// Start recording
  Future<void> startRecording() async {
    if (!_isRecorderInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _recordingPath = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(
      toFile: _recordingPath,
      codec: Codec.aacADTS,
    );
  }

  /// Stop recording and return file path
  Future<String?> stopRecording() async {
    if (!_isRecorderInitialized) return null;
    await _recorder!.stopRecorder();
    return _recordingPath;
  }

  /// Start playback
  Future<void> startPlayback() async {
    if (!_isPlayerInitialized || _recordingPath == null) return;

    final file = File(_recordingPath!);
    if (!file.existsSync()) return;

    await _player!.startPlayer(
      fromURI: _recordingPath,
      whenFinished: () {
        _player?.stopPlayer();
      },
    );
  }

  /// Stop playback
  Future<void> stopPlayback() async {
    if (!_isPlayerInitialized) return;
    await _player!.stopPlayer();
  }

  /// Check if currently recording
  bool get isRecording => _recorder?.isRecording ?? false;

  /// Check if currently playing
  bool get isPlaying => _player?.isPlaying ?? false;

  /// Get last recording path
  String? get lastRecording => _recordingPath;
}
