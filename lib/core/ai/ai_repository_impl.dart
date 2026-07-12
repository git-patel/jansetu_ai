import 'dart:convert';
import 'ai_repository.dart';
import 'ai_service.dart';
import 'prompt_templates.dart';
import '../config/ai_config.dart';

class AIRepositoryImpl implements AIRepository {
  final AIService geminiService;
  final AIService mockService;

  AIRepositoryImpl({
    required this.geminiService,
    required this.mockService,
  });

  bool get _isGeminiConfigured {
    const key = AIConfig.geminiApiKey;
    return key.isNotEmpty && key != 'YOUR_GEMINI_API_KEY_HERE';
  }

  Future<String> _executeWithFallback(String prompt) async {
    if (!_isGeminiConfigured) {
      final response = await mockService.generate(AIRequest(prompt: prompt));
      return response.text;
    }
    
    try {
      final response = await geminiService.generate(AIRequest(prompt: prompt));
      if (response.error != null || response.text.isEmpty) {
        // Fallback to mock service
        final fallbackResponse = await mockService.generate(AIRequest(prompt: prompt));
        return fallbackResponse.text;
      }
      return response.text;
    } catch (_) {
      final fallbackResponse = await mockService.generate(AIRequest(prompt: prompt));
      return fallbackResponse.text;
    }
  }

  @override
  Future<String> chat(String prompt, String history, {String role = 'CITIZEN'}) async {
    final formattedPrompt = PromptTemplates.citizenChat(prompt, history);
    return _executeWithFallback(formattedPrompt);
  }

  @override
  Future<String> summarizeComplaint(String rawText) async {
    final formattedPrompt = PromptTemplates.summarizeComplaint(rawText);
    return _executeWithFallback(formattedPrompt);
  }

  @override
  Future<Map<String, dynamic>> analyzeImage(String description) async {
    final formattedPrompt = PromptTemplates.imageAnalysis(description);
    final responseText = await _executeWithFallback(formattedPrompt);
    try {
      return json.decode(responseText) as Map<String, dynamic>;
    } catch (_) {
      return {
        'damageSeverity': 'MEDIUM',
        'structuralThreat': false,
        'confidenceScore': 0.7,
        'detectedObjects': []
      };
    }
  }

  @override
  Future<String> detectDepartment(String rawText) async {
    final formattedPrompt = PromptTemplates.complaintTriage('', rawText);
    final responseText = await _executeWithFallback(formattedPrompt);
    try {
      final data = json.decode(responseText) as Map<String, dynamic>;
      return data['department'] ?? 'General Municipal Administration';
    } catch (_) {
      return 'General Municipal Administration';
    }
  }

  @override
  Future<double> suggestPriority(String title, String description) async {
    final formattedPrompt = PromptTemplates.complaintTriage(title, description);
    final responseText = await _executeWithFallback(formattedPrompt);
    try {
      final data = json.decode(responseText) as Map<String, dynamic>;
      final val = data['priorityScore'];
      if (val is num) return val.toDouble();
      return 50.0;
    } catch (_) {
      return 50.0;
    }
  }

  @override
  Future<String> generateProjectSummary(Map<String, dynamic> projectData) async {
    final formattedPrompt = PromptTemplates.projectSummary(projectData);
    return _executeWithFallback(formattedPrompt);
  }

  @override
  Future<String> generateCitizenReply(String rawText) async {
    final formattedPrompt = PromptTemplates.citizenReply(rawText);
    return _executeWithFallback(formattedPrompt);
  }

  @override
  Future<String> generateMpRecommendation(String query, String statusSummary) async {
    final formattedPrompt = PromptTemplates.mpRecommendation(query, statusSummary);
    return _executeWithFallback(formattedPrompt);
  }

  @override
  Future<String> generateStateSummary(Map<String, dynamic> stateData) async {
    final formattedPrompt = PromptTemplates.stateSummary(stateData);
    return _executeWithFallback(formattedPrompt);
  }
}
