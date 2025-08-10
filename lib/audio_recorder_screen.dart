import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({super.key});
  
  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _hasRecording = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  bool _isInitialized = false;
  String _debugInfo = "Starting...";
  
  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  void _updateDebug(String message) {
    setState(() {
      _debugInfo = message;
    });
    print("DEBUG: $message");
  }

  Future<void> _initializeRecorder() async {
    try {
      _updateDebug("Initializing recorder...");
      _recorder = FlutterSoundRecorder();
      _player = FlutterSoundPlayer();
      
      // Request microphone permission
      _updateDebug("Requesting microphone permission...");
      var status = await Permission.microphone.request();
      _updateDebug("Permission status: $status");
      
      if (status == PermissionStatus.granted) {
        _updateDebug("Opening recorder...");
        await _recorder!.openRecorder();
        _updateDebug("Opening player...");
        await _player!.openPlayer();
        setState(() {
          _isInitialized = true;
        });
        _updateDebug("Initialization complete!");
      } else {
        _updateDebug("Permission denied: $status");
        _showPermissionDialog();
      }
    } catch (e) {
      _updateDebug("Error initializing: $e");
      print('Error initializing recorder: $e');
      _showErrorDialog('Failed to initialize audio recorder: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Microphone Permission Required'),
          content: Text('This app needs microphone access to record audio.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeRecorder();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    // Back to AAC format since it was working before
    String path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    _updateDebug("Recording path: $path");
    return path;
  }

  Future<void> _startRecording() async {
    if (_recorder == null || !_isInitialized) {
      _updateDebug("Cannot start recording - not initialized");
      return;
    }
    
    try {
      _updateDebug("Starting recording...");
      _recordingPath = await _getRecordingPath();
      
      // Use AAC codec since it was working before
      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
      );
      
      _updateDebug("Recording started successfully");
      
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });
      
      // Start timer to track recording duration
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration = Duration(seconds: timer.tick);
          });
          _updateDebug("Recording: ${_recordingDuration.inSeconds}s");
        }
      });
    } catch (e) {
      _updateDebug("Error starting recording: $e");
      print('Error starting recording: $e');
      _showErrorDialog('Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> _stopRecording() async {
    if (_recorder == null || !_isRecording) {
      _updateDebug("Cannot stop recording - not recording");
      return;
    }
    
    try {
      _updateDebug("Stopping recording...");
      await _recorder!.stopRecorder();
      _timer?.cancel();
      
      // Check if file exists and its size
      if (_recordingPath != null) {
        File file = File(_recordingPath!);
        if (file.existsSync()) {
          int fileSize = file.lengthSync();
          _updateDebug("Recording saved: $fileSize bytes");
          setState(() {
            _isRecording = false;
            _hasRecording = fileSize > 1000; // Need at least 1KB for valid audio
          });
        } else {
          _updateDebug("Recording file not found!");
          setState(() {
            _isRecording = false;
            _hasRecording = false;
          });
        }
      }
    } catch (e) {
      _updateDebug("Error stopping recording: $e");
      print('Error stopping recording: $e');
      _showErrorDialog('Failed to stop recording: ${e.toString()}');
    }
  }

  Future<void> _playRecording() async {
    if (_player == null || !_isInitialized || _recordingPath == null) {
      _updateDebug("Cannot play - not initialized or no recording");
      return;
    }
    
    try {
      _updateDebug("Starting playback...");
      File file = File(_recordingPath!);
      if (!file.existsSync()) {
        _updateDebug("Recording file doesn't exist!");
        return;
      }
      
      int fileSize = file.lengthSync();
      _updateDebug("File exists, size: $fileSize bytes");
      
      if (fileSize < 1000) {
        _updateDebug("File too small - likely empty recording");
        _showErrorDialog("Recording appears to be empty. Try recording for longer.");
        return;
      }
      
      // Stop any current playback first
      if (_player!.isPlaying) {
        await _player!.stopPlayer();
        await Future.delayed(Duration(milliseconds: 500));
      }
      
      _updateDebug("Attempting to play: $_recordingPath");
      
      // Try different playback approach
      await _player!.startPlayer(
        fromURI: _recordingPath,
        whenFinished: () {
          _updateDebug("Playback finished normally");
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        },
      );
      
      setState(() {
        _isPlaying = true;
      });
      _updateDebug("Playback started successfully");
      
      // Check if playback is actually happening
      Future.delayed(Duration(seconds: 1), () async {
        if (_player != null && _isPlaying) {
          bool isActuallyPlaying = _player!.isPlaying;
          _updateDebug("Playback status check: $isActuallyPlaying");
          if (!isActuallyPlaying) {
            _updateDebug("Playback failed to start properly");
            setState(() {
              _isPlaying = false;
            });
          }
        }
      });
      
    } catch (e) {
      _updateDebug("Error playing: $e");
      print('Error playing recording: $e');
      _showErrorDialog('Failed to play recording: ${e.toString()}');
    }
  }

  Future<void> _stopPlaying() async {
    if (_player == null) return;
    
    try {
      _updateDebug("Stopping playback...");
      await _player!.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
      _updateDebug("Playback stopped");
    } catch (e) {
      _updateDebug("Error stopping playback: $e");
      print('Error stopping playback: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Debug Info Box
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Debug Info:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _debugInfo,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Recording Status
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isRecording ? Icons.mic : Icons.mic_none,
                        size: 80,
                        color: _isRecording ? Colors.red : Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Text(
                        _isRecording ? 'Recording...' : 
                        _hasRecording ? 'Recording Ready' : 
                        _isInitialized ? 'Ready to Record' : 'Initializing...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _formatDuration(_recordingDuration),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _isRecording ? Colors.red : Colors.blue[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Record Button
                    GestureDetector(
                      onTap: _isInitialized ? (_isRecording ? _stopRecording : _startRecording) : null,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isInitialized 
                              ? (_isRecording ? Colors.red : Colors.blue[600])
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: _isInitialized ? [
                            BoxShadow(
                              color: (_isRecording ? Colors.red : Colors.blue)
                                  .withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ] : [],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: _isInitialized ? Colors.white : Colors.grey[500],
                          size: 40,
                        ),
                      ),
                    ),
                    
                    // Play Button
                    GestureDetector(
                      onTap: _hasRecording && !_isRecording && _isInitialized
                          ? (_isPlaying ? _stopPlaying : _playRecording)
                          : null,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _hasRecording && !_isRecording && _isInitialized
                              ? (_isPlaying ? Colors.orange : Colors.green)
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: _hasRecording && !_isRecording && _isInitialized
                              ? [
                                  BoxShadow(
                                    color: (_isPlaying ? Colors.orange : Colors.green)
                                        .withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.stop : Icons.play_arrow,
                          color: _hasRecording && !_isRecording && _isInitialized
                              ? Colors.white
                              : Colors.grey[500],
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Additional Test Info
                if (_hasRecording && _recordingPath != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      'Recording saved successfully!\nFile: ${_recordingPath!.split('/').last}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}