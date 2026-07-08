import '../../core/utils/logger.dart';
import '../../services/ai/ai_service.dart';
import '../interfaces/ai_repository.dart';

/// Local Sandbox AI Repository Implementation (LocalAiRepository)
/// Delegates all AI operations cleanly to AiService orchestrator.
/// Provides offline evaluation, caching, and reasoning per Prompt 16.
class LocalAiRepository implements AiRepository {
  @override
  Future<String> summarizeNeed(String rawText) async {
    JanSetuLogger.info('LocalAiRepo: Delegating summarizeNeed to AiService...', 'LocalAiRepo');
    return AiService.instance.summarizeText(rawText);
  }

  @override
  Future<String> categorizeGrievance(String rawText, String? imagePath) async {
    return AiService.instance.categorizeIssue(rawText, hasImage: imagePath != null);
  }

  @override
  Future<double> calculatePriority(Map<String, dynamic> needData) async {
    return AiService.instance.calculatePriorityScore(needData);
  }

  @override
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng) async {
    return AiService.instance.detectDuplicates(title, lat, lng);
  }

  @override
  Future<String> suggestDepartment(String rawText) async {
    return AiService.instance.suggestDepartment(rawText);
  }

  @override
  Future<double> calculateImpactScore(double estimatedCost, int beneficiaries) async {
    return AiService.instance.calculateImpactScore(estimatedCost, beneficiaries);
  }

  @override
  Future<String> chatAssistant(String prompt, List<Map<String, dynamic>> contextHistory, {String role = 'CITIZEN'}) async {
    JanSetuLogger.info('LocalAiRepo: Executing chatAssistant for role [$role]', 'LocalAiRepo');
    return AiService.instance.chatInference(prompt, contextHistory, role: role);
  }

  @override
  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    return AiService.instance.analyzeImage(imagePath);
  }

  @override
  Future<Map<String, dynamic>> parseOcrDocument(String documentPath) async {
    return AiService.instance.parseOcrDocument(documentPath);
  }

  @override
  Future<String> translateMultilingual(String text, String targetLang) async {
    return AiService.instance.translateMultilingual(text, targetLang);
  }

  @override
  Future<String> detectLanguage(String text) async {
    return AiService.instance.detectLanguage(text);
  }

  @override
  Future<String> correctGrammar(String text) async {
    return AiService.instance.correctGrammar(text);
  }

  @override
  Future<String> askMpCopilot(String question, Map<String, dynamic> context) async {
    return AiService.instance.generateRoleInsights(question, context, role: 'MP');
  }

  @override
  Future<String> askAdminCopilot(String question, Map<String, dynamic> context) async {
    return AiService.instance.generateRoleInsights(question, context, role: 'ADMIN');
  }

  @override
  Future<Map<String, dynamic>> naturalLanguageSearch(String query) async {
    return AiService.instance.naturalLanguageSearchToFilters(query);
  }

  @override
  Future<String> generateReasoning(String decisionType, Map<String, dynamic> data) async {
    return AiService.instance.generateReasoning(decisionType, data);
  }
}
