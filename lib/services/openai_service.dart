// lib/services/openai_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Simple service for calling OpenAI's Chat Completions API.
/// NOTE: For production web builds, never ship your secret key to the browser.
/// Use a backend proxy instead.
class OpenAIService {
  OpenAIService({
    http.Client? client,
    String? apiKeyOverride,
    String model = 'gpt-4o-mini', // fast & inexpensive; change if you need
    Uri? endpoint,
    Duration timeout = const Duration(seconds: 45),
  })  : _client = client ?? http.Client(),
        _apiKeyOverride = apiKeyOverride,
        _model = model,
        _endpoint =
            endpoint ?? Uri.parse('https://api.openai.com/v1/chat/completions'),
        _timeout = timeout;

  final http.Client _client;
  final String? _apiKeyOverride;
  final String _model;
  final Uri _endpoint;
  final Duration _timeout;

  /// Pull the key from (in priority order):
  /// 1) explicit override in constructor
  /// 2) dotenv (.env) -> OPENAI_API_KEY
  /// 3) compile-time --dart-define=OPENAI_API_KEY=...
  String? get _apiKey {
    if (_apiKeyOverride != null && _apiKeyOverride!.isNotEmpty) {
      return _apiKeyOverride;
    }
    final fromDotEnv = dotenv.env['OPENAI_API_KEY'];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) return fromDotEnv;

    final fromDefine = const String.fromEnvironment('OPENAI_API_KEY');
    if (fromDefine.isNotEmpty) return fromDefine;

    return null;
  }

  /// High-level helpers mirroring your Swift methods
  Future<String> analyzeTranscription(
      String transcription, {
        String prompt =
        'Summarize this transcription and extract key insights:',
      }) {
    final system = _defaultSystemPrompt;
    final user =
    '$prompt\n\nTranscription:\n$transcription'.trimRight();
    return _chat(system: system, user: user);
  }

  Future<String> createStructuredSummary(String transcription) {
    const prompt = '''
Create a well-structured summary with these sections:

**Main Topic/Purpose:**
**Key Points:**
**Important Details:**
**Next Steps/Actions:**
**Questions/Considerations:**

Keep it concise but comprehensive.
''';
    return analyzeTranscription(transcription, prompt: prompt);
  }

  Future<String> extractActionableItems(String transcription) {
    const prompt = '''
Extract all actionable items, tasks, deadlines, and commitments.

For each item, include:
• Specific action
• Any deadlines/timeframes
• Priority (if apparent)
• Responsible person (if mentioned)

Also list decisions made, follow-ups, and resources needed.
Return an organized, to-do-list-friendly format.
''';
    return analyzeTranscription(transcription, prompt: prompt);
  }

  Future<String> generateInstructionalInsights(String transcription) {
    const prompt = '''
You are an expert instructor/advisor. Provide detailed, actionable guidance.

If:
- Process/recipe: step-by-step with tips
- Problem: structured solution with specific actions
- Learning: study strategies and key concepts
- Planning: concrete next steps and considerations
- Goals: specific actions and milestones

Use clear headings and bullet points.
''';
    return analyzeTranscription(transcription, prompt: prompt);
  }

  Future<String> analyzeWithCustomPrompt(
      String transcription, {
        required String customPrompt,
      }) {
    final prompt = '''
You are an expert instructor, advisor, and assistant. Provide detailed, practical, and actionable responses. Use headings and bullet points where helpful.

User's specific request:
$customPrompt

Based on this voice note transcription, please respond:
''';
    return analyzeTranscription(transcription, prompt: prompt);
  }

  /// Core chat call
  Future<String> _chat({
    required String system,
    required String user,
    double temperature = 0.7,
    int maxTokens = 1200,
  }) async {
    final key = _apiKey;
    if (key == null) {
      // Don’t crash the app; return a helpful message
      return 'OpenAI API key missing. Add it to assets/.env (OPENAI_API_KEY=...) '
          'or pass --dart-define=OPENAI_API_KEY=your_key at build time. '
          'For web, do NOT ship secrets to production—use a backend proxy.';
    }

    final body = {
      'model': _model,
      'messages': [
        {
          'role': 'system',
          'content': system,
        },
        {
          'role': 'user',
          'content': user,
        },
      ],
      'temperature': temperature,
      'max_tokens': maxTokens,
    };

    try {
      final resp = await _client
          .post(
        _endpoint,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $key',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(body),
      )
          .timeout(_timeout);

      if (resp.statusCode != 200) {
        debugPrint('OpenAI error ${resp.statusCode}: ${resp.body}');
        return _friendlyError(resp.statusCode, resp.body);
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final choices = (data['choices'] as List?) ?? const [];
      if (choices.isEmpty) return 'No response received.';
      final msg = choices.first['message'] as Map<String, dynamic>?;
      final content = (msg?['content'] as String?)?.trim();
      return (content == null || content.isEmpty)
          ? 'No response received.'
          : content;
    } on SocketException {
      return 'Network error. Check your connection and try again.';
    } on FormatException {
      return 'Unexpected response format from OpenAI.';
    } on HttpException catch (e) {
      return 'HTTP error: ${e.message}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  String get _defaultSystemPrompt =>
      'You are an expert instructor, advisor, and assistant. '
          'Provide detailed, practical, and actionable responses. '
          'Use clear formatting with headings and bullet points when appropriate.';

  String _friendlyError(int code, String body) {
    if (code == 401) {
      return 'Unauthorized (401). Your API key may be missing/invalid.';
    }
    if (code == 429) {
      return 'Rate limited (429). You have exceeded the quota; try again later.';
    }
    if (code >= 500) {
      return 'OpenAI server error ($code). Please try again later.';
    }
    // Try to pass through useful message from OpenAI if present
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final err = json['error'];
      if (err is Map && err['message'] is String) {
        return 'Error $code: ${err['message']}';
      }
    } catch (_) {}
    return 'Request failed ($code).';
  }

  void dispose() {
    _client.close();
  }
}
