import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';
import 'ai_service.dart';

class GeminiAIService implements AIService {
  final http.Client? httpClient;

  GeminiAIService({this.httpClient});

  @override
  Future<AIResponse> generate(AIRequest request) async {
    const key = AIConfig.geminiApiKey;
    if (key.isEmpty || key == 'YOUR_GEMINI_API_KEY_HERE') {
      return const AIResponse(
        text: '',
        isMock: false,
        error: 'Gemini API Key is unconfigured.',
      );
    }

    try {
      final client = httpClient ?? http.Client();
      final response = await client.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$key',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': request.prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text']?.toString();
        if (text != null && text.isNotEmpty) {
          return AIResponse(text: text.trim());
        }
      }
      return AIResponse(
        text: '',
        isMock: false,
        error: 'Gemini API Error: Status ${response.statusCode}',
      );
    } catch (e) {
      return AIResponse(
        text: '',
        isMock: false,
        error: 'Gemini API Exception: $e',
      );
    }
  }
}
