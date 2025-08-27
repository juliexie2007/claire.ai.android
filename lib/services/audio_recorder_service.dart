import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;

  Future<void> init() async {
    await _recorder.openRecorder();
    _isRecorderInitialized = true;

    await _player.openPlayer();
    _isPlayerInitialized = true;
  }

  /// Start recording audio, returns file path
  Future<String?> startRecording() async {
    if (!_isRecorderInitialized) {
      await init();
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );

    return filePath;
  }

  /// Stop recording and return the file path if it exists
  Future<String?> stopRecording() async {
    if (!_isRecorderInitialized) return null;

    final filePath = await _recorder.stopRecorder();

    if (filePath == null) return null;

    final file = File(filePath);
    if (await file.exists()) {
      debugPrint("✅ Recording saved: $filePath");
      return filePath;
    } else {
      debugPrint("⚠️ Recording failed to save.");
      return null;
    }
  }

  /// Play a saved recording
  Future<void> playRecording(String filePath) async {
    if (!_isPlayerInitialized) {
      await init();
    }

    final file = File(filePath);
    if (await file.exists()) {
      await _player.startPlayer(
        fromURI: filePath,
        codec: Codec.aacADTS,
      );
    } else {
      debugPrint("⚠️ Tried to play non-existent file: $filePath");
    }
  }

  /// Clean up resources
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
  }
}
