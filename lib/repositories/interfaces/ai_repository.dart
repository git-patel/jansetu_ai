/// AI Intelligence Repository Interface (AiRepository)
/// Manages Gemini 2.5 Pro inference, grievance summarization, duplicate detection, OCR parsing,
/// image damage classification, multilingual translation, and executive copilot insights per Prompt 16.
abstract class AiRepository {
  Future<String> summarizeNeed(String rawText);
  Future<String> categorizeGrievance(String rawText, String? imagePath);
  Future<double> calculatePriority(Map<String, dynamic> needData);
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng);
  Future<String> suggestDepartment(String rawText);
  Future<double> calculateImpactScore(double estimatedCost, int beneficiaries);
  Future<String> chatAssistant(String prompt, List<Map<String, dynamic>> contextHistory, {String role = 'CITIZEN'});

  // --- Prompt 16 Expanded Capabilities ---
  Future<Map<String, dynamic>> analyzeImage(String imagePath);
  Future<Map<String, dynamic>> parseOcrDocument(String documentPath);
  Future<String> translateMultilingual(String text, String targetLang);
  Future<String> detectLanguage(String text);
  Future<String> correctGrammar(String text);
  Future<String> askMpCopilot(String question, Map<String, dynamic> context);
  Future<String> askAdminCopilot(String question, Map<String, dynamic> context);
  Future<Map<String, dynamic>> naturalLanguageSearch(String query);
  Future<String> generateReasoning(String decisionType, Map<String, dynamic> data);
}
