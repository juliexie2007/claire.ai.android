import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';

class AudioPlaybackService {
  FlutterSoundPlayer? _player;
  bool _isPlayerInitialized = false;

  Future<void> init() async {
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();
    _isPlayerInitialized = true;
  }

  Future<void> dispose() async {
    await _player?.closePlayer();
    _player = null;
    _isPlayerInitialized = false;
  }

  Future<void> play(String path) async {
    if (!_isPlayerInitialized) return;
    final file = File(path);
    if (!file.existsSync()) return;

    await _player!.startPlayer(fromURI: path, whenFinished: () {});
  }

  Future<void> stop() async {
    if (!_isPlayerInitialized) return;
    await _player!.stopPlayer();
  }

  bool get isPlaying => _player?.isPlaying ?? false;
}
