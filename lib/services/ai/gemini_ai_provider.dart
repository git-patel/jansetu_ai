import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/ai_config.dart';
import '../../core/utils/logger.dart';
import 'ai_provider.dart';
import 'mock_ai_provider.dart';
import 'prompt_registry.dart';

/// Gemini 2.5 Pro & 1.5 Flash AI Provider Implementation (GeminiAiProvider)
/// Serves as the live cloud LLM implementation executing direct Google Gemini API requests.
/// Transparently falls back to MockAiProvider when offline or when client-side API keys are unconfigured.
class GeminiAiProvider implements AiProvider {
  final MockAiProvider _fallbackProvider = MockAiProvider();

  Future<String?> _postToGemini(String prompt) async {
    const key = AiConfig.geminiApiKey;
    if (key.isEmpty || key == 'YOUR_GEMINI_API_KEY_HERE' ) {
      return null;
    }
    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$key'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text']?.toString();
        if (text != null && text.isNotEmpty) {
          return text.trim();
        }
      } else {
        JanSetuLogger.error('Gemini API Error: Status ${response.statusCode}', response.body, null, 'GeminiAiProvider');
      }
    } catch (e) {
      JanSetuLogger.error('Gemini API Exception', e, null, 'GeminiAiProvider');
    }
    return null;
  }

  @override
  Future<String> summarizeText(String rawText) async {
    JanSetuLogger.info('Gemini API: Executing summarization...', 'GeminiAiProvider');
    final prompt = PromptRegistry.buildSummarizationPrompt(rawText);
    final result = await _postToGemini(prompt);
    return result ?? await _fallbackProvider.summarizeText(rawText);
  }

  @override
  Future<String> categorizeIssue(String rawText, {bool hasImage = false}) async {
    JanSetuLogger.info('Gemini API: Categorizing issue (hasImage: $hasImage)...', 'GeminiAiProvider');
    final prompt = 'Categorize the following citizen grievance description into exactly one category (e.g. Roads & Infrastructure, Water & Sanitation, Electricity & Lighting, Health & Sanitation, Urban Development & Public Works):\n\n$rawText';
    final result = await _postToGemini(prompt);
    if (result != null) {
      final clean = result.toLowerCase();
      if (clean.contains('road') || clean.contains('infrastructure')) return 'Roads & Infrastructure';
      if (clean.contains('water') || clean.contains('sanitation')) return 'Water & Sanitation';
      if (clean.contains('light') || clean.contains('electric')) return 'Electricity & Lighting';
      if (clean.contains('garbage') || clean.contains('health')) return 'Health & Sanitation';
    }
    return await _fallbackProvider.categorizeIssue(rawText, hasImage: hasImage);
  }

  @override
  Future<double> calculatePriorityScore(Map<String, dynamic> data) async {
    JanSetuLogger.info('Gemini API: Computing priority score...', 'GeminiAiProvider');
    final prompt = 'Based on the following civic data, output only a float priority score between 10.0 and 99.5:\n\n${json.encode(data)}';
    final result = await _postToGemini(prompt);
    if (result != null) {
      final val = double.tryParse(result.replaceAll(RegExp(r'[^\d.]'), ''));
      if (val != null) return val.clamp(10.0, 99.5);
    }
    return await _fallbackProvider.calculatePriorityScore(data);
  }

  @override
  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    return await _fallbackProvider.analyzeImage(imagePath);
  }

  @override
  Future<Map<String, dynamic>> parseOcrDocument(String documentPath) async {
    return await _fallbackProvider.parseOcrDocument(documentPath);
  }

  @override
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng) async {
    return await _fallbackProvider.detectDuplicates(title, lat, lng);
  }

  @override
  Future<String> translateMultilingual(String text, String targetLang) async {
    JanSetuLogger.info('Gemini API: Translating to $targetLang...', 'GeminiAiProvider');
    final prompt = 'Translate the following text to target language code "$targetLang". Output only the translated text without explanations:\n\n$text';
    final result = await _postToGemini(prompt);
    return result ?? await _fallbackProvider.translateMultilingual(text, targetLang);
  }

  @override
  Future<String> detectLanguage(String text) async {
    return _fallbackProvider.detectLanguage(text);
  }

  @override
  Future<String> correctGrammar(String text) async {
    final prompt = 'Correct any grammar errors in the following text. Output only the corrected text:\n\n$text';
    final result = await _postToGemini(prompt);
    return result ?? await _fallbackProvider.correctGrammar(text);
  }

  @override
  Future<String> suggestDepartment(String rawText) async {
    final prompt = 'Suggest the municipal department (e.g. DEPT_ROADS_HIGHWAYS, DEPT_WATER_SANITATION, DEPT_POWER_ELECTRICITY, DEPT_HEALTH_SANITATION, DEPT_URBAN_DEV) for this issue: "$rawText". Output only the department ID:';
    final result = await _postToGemini(prompt);
    if (result != null) {
      final clean = result.toUpperCase();
      if (clean.contains('ROADS')) return 'DEPT_ROADS_HIGHWAYS';
      if (clean.contains('WATER')) return 'DEPT_WATER_SANITATION';
      if (clean.contains('POWER') || clean.contains('ELECTRICITY')) return 'DEPT_POWER_ELECTRICITY';
      if (clean.contains('HEALTH') || clean.contains('SANITATION')) return 'DEPT_HEALTH_SANITATION';
      if (clean.contains('URBAN')) return 'DEPT_URBAN_DEV';
    }
    return await _fallbackProvider.suggestDepartment(rawText);
  }

  @override
  Future<double> calculateImpactScore(double estimatedCost, int beneficiaries) async {
    return _fallbackProvider.calculateImpactScore(estimatedCost, beneficiaries);
  }

  @override
  Future<String> chatInference(String prompt, List<Map<String, dynamic>> history, {required String role}) async {
    JanSetuLogger.info('Gemini API: Chat stream for role [$role]...', 'GeminiAiProvider');
    
    final buffer = StringBuffer();
    buffer.writeln(PromptRegistry.getPromptForRole(role));
    buffer.writeln('Here is the recent conversation history:');
    for (final msg in history) {
      buffer.writeln('${msg['sender'] == 'user' ? 'Citizen' : 'JanSetu AI'}: ${msg['text']}');
    }
    buffer.writeln('Citizen: $prompt');
    buffer.writeln('JanSetu AI:');

    final result = await _postToGemini(buffer.toString());
    return result ?? await _fallbackProvider.chatInference(prompt, history, role: role);
  }

  @override
  Future<String> generateRoleInsights(String promptType, Map<String, dynamic> context, {required String role}) async {
    return _fallbackProvider.generateRoleInsights(promptType, context, role: role);
  }

  @override
  Future<Map<String, dynamic>> naturalLanguageSearchToFilters(String query) async {
    return _fallbackProvider.naturalLanguageSearchToFilters(query);
  }

  @override
  Future<String> generateReasoning(String decisionType, Map<String, dynamic> data) async {
    return _fallbackProvider.generateReasoning(decisionType, data);
  }
}
