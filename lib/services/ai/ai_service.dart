import '../../core/utils/cache_manager.dart';
import '../../core/utils/logger.dart';
import '../cloud/firebase_monitoring_service.dart';
import 'ai_provider.dart';
import 'gemini_ai_provider.dart';
import 'mock_ai_provider.dart';

/// Central AI Service Orchestrator (AiService)
/// Coordinates caching with TTL (30 minutes), automatic provider switching between
/// live Gemini and offline Mock AI, retry mechanisms, and transparent reasoning generation.
/// Serves as the single point of truth for AI intelligence across JanSetu AI per Prompt 16.
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  final GeminiAiProvider _geminiProvider = GeminiAiProvider();
  final MockAiProvider _mockProvider = MockAiProvider();

  /// Determine active provider based on Remote Config and network status
  AiProvider get _activeProvider {
    final useDemo = FirebaseMonitoringService.getBoolFlag('demo_mode_enabled');
    final aiEnabled = FirebaseMonitoringService.getBoolFlag('ai_features_enabled');
    if (useDemo || !aiEnabled) {
      return _mockProvider;
    }
    return _geminiProvider;
  }

  /// Execute AI operation with TTL caching and automatic offline retry/fallback
  Future<T> _executeWithCache<T>(String cacheKey, Future<T> Function(AiProvider provider) action, {bool useCache = true}) async {
    if (useCache) {
      final cached = CacheManager.getMemory<T>(cacheKey);
      if (cached != null) {
        JanSetuLogger.info('AI Cache hit for key: $cacheKey', 'AiService');
        return cached;
      }
    }

    try {
      final result = await action(_activeProvider);
      if (useCache && result != null) {
        CacheManager.putMemory(cacheKey, result, ttl: const Duration(minutes: 30));
      }
      return result;
    } catch (e, st) {
      JanSetuLogger.warning('Active AI provider failed ($e), falling back to MockAiProvider...', 'AiService');
      FirebaseMonitoringService.recordFlutterError(e, st, reason: 'AiService fallback triggered');
      final fallbackResult = await action(_mockProvider);
      return fallbackResult;
    }
  }

  Future<String> summarizeText(String rawText) async {
    return _executeWithCache('summary_${rawText.hashCode}', (p) => p.summarizeText(rawText));
  }

  Future<String> categorizeIssue(String rawText, {bool hasImage = false}) async {
    return _executeWithCache('cat_${rawText.hashCode}_$hasImage', (p) => p.categorizeIssue(rawText, hasImage: hasImage));
  }

  Future<double> calculatePriorityScore(Map<String, dynamic> data) async {
    return _executeWithCache('pri_${data.hashCode}', (p) => p.calculatePriorityScore(data), useCache: false);
  }

  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    return _executeWithCache('img_${imagePath.hashCode}', (p) => p.analyzeImage(imagePath));
  }

  Future<Map<String, dynamic>> parseOcrDocument(String documentPath) async {
    return _executeWithCache('ocr_${documentPath.hashCode}', (p) => p.parseOcrDocument(documentPath));
  }

  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng) async {
    return _executeWithCache('dup_${title.hashCode}_${lat.toStringAsFixed(2)}', (p) => p.detectDuplicates(title, lat, lng), useCache: false);
  }

  Future<String> translateMultilingual(String text, String targetLang) async {
    return _executeWithCache('trans_${text.hashCode}_$targetLang', (p) => p.translateMultilingual(text, targetLang));
  }

  Future<String> detectLanguage(String text) async {
    return _executeWithCache('lang_${text.hashCode}', (p) => p.detectLanguage(text));
  }

  Future<String> correctGrammar(String text) async {
    return _executeWithCache('gram_${text.hashCode}', (p) => p.correctGrammar(text));
  }

  Future<String> suggestDepartment(String rawText) async {
    return _executeWithCache('dept_${rawText.hashCode}', (p) => p.suggestDepartment(rawText));
  }

  Future<double> calculateImpactScore(double estimatedCost, int beneficiaries) async {
    return _executeWithCache('impact_${estimatedCost}_$beneficiaries', (p) => p.calculateImpactScore(estimatedCost, beneficiaries));
  }

  Future<String> chatInference(String prompt, List<Map<String, dynamic>> history, {required String role}) async {
    // Chat responses should not be cached to ensure conversational dynamism
    return _executeWithCache('chat_${prompt.hashCode}_$role', (p) => p.chatInference(prompt, history, role: role), useCache: false);
  }

  Future<String> generateRoleInsights(String promptType, Map<String, dynamic> context, {required String role}) async {
    return _executeWithCache('insight_${promptType}_$role', (p) => p.generateRoleInsights(promptType, context, role: role), useCache: false);
  }

  Future<Map<String, dynamic>> naturalLanguageSearchToFilters(String query) async {
    return _executeWithCache('nl_search_${query.hashCode}', (p) => p.naturalLanguageSearchToFilters(query));
  }

  Future<String> generateReasoning(String decisionType, Map<String, dynamic> data) async {
    return _executeWithCache('reason_${decisionType}_${data.hashCode}', (p) => p.generateReasoning(decisionType, data));
  }
}
