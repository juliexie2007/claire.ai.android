import 'package:flutter/material.dart';
import 'package:vosk_flutter_2/vosk_flutter_2.dart';
import 'dart:io';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({super.key});

  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final _vosk = VoskFlutterPlugin.instance();
  final _modelLoader = ModelLoader();
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  bool _recognitionStarted = false;
  String _currentSession = ''; // ongoing transcription
  final List<String> _transcriptions = []; // finalized sessions

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      // Load model description
      final modelDescription = await _modelLoader.loadModelsList().then(
        (list) => list.firstWhere(
          (m) => m.name == 'vosk-model-small-en-us-0.15',
        ),
      );

      // Download model
      final modelPath = await _modelLoader.loadFromNetwork(modelDescription.url);

      // Create Model object
      final model = await _vosk.createModel(modelPath);

      setState(() {
        _model = model;
      });

      // Create recognizer
      _recognizer =
          await _vosk.createRecognizer(model: _model!, sampleRate: 16000);

      // Initialize speech service
      if (Platform.isAndroid) {
        _speechService = await _vosk.initSpeechService(_recognizer!);

        // Live partial results
        _speechService!.onPartial().listen((text) {
          if (text.isNotEmpty) {
            setState(() {
              _currentSession = text;
            });
          }
        });

        // Final results → append to current session
        _speechService!.onResult().listen((text) {
          if (text.isNotEmpty) {
            setState(() {
              _currentSession = _currentSession.isEmpty
                  ? text
                  : '$_currentSession $text';
            });
          }
        });
      }

      print("✅ Model loaded successfully!");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  @override
  void dispose() {
    _speechService?.stop();
    super.dispose();
  }

  void _toggleRecognition() async {
    if (_speechService == null || _model == null) return;

    if (_recognitionStarted) {
      // Stop recognition → save session
      await _speechService!.stop();
      if (_currentSession.trim().isNotEmpty) {
        setState(() {
          _transcriptions.insert(0, _currentSession.trim());
          _currentSession = '';
          _recognitionStarted = false;
        });
      } else {
        setState(() => _recognitionStarted = false);
      }
    } else {
      // Start recognition
      await _speechService!.start();
      setState(() {
        _recognitionStarted = true;
        _currentSession = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech to Text')),
      body: _model == null
          ? const Center(child: Text('Loading model...'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: _toggleRecognition,
                      child: Text(
                        _recognitionStarted
                            ? 'Stop Recognition'
                            : 'Start Recognition',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Live transcription
                  const Text(
                    'Current Session:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentSession.isEmpty
                          ? '--- speak to see text ---'
                          : _currentSession,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const Divider(height: 30),

                  // Saved sessions
                  const Text(
                    'Previous Sessions:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _transcriptions.isEmpty
                        ? const Center(
                            child: Text(
                              'No transcriptions yet.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _transcriptions.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    _transcriptions[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
