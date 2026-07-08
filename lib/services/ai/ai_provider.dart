/// AI Provider Abstraction Interface (AiProvider)
/// Decouples UI and domain services from specific LLM implementations (Gemini, Mock, OpenAI, Gov APIs).
abstract class AiProvider {
  /// Summarize raw citizen grievance text or unstructured data
  Future<String> summarizeText(String rawText);

  /// Categorize civic issue and route to department
  Future<String> categorizeIssue(String rawText, {bool hasImage = false});

  /// Calculate 0-100 Priority Score for grievance or project
  Future<double> calculatePriorityScore(Map<String, dynamic> data);

  /// Analyze civic image (returns Object, Condition, Damage Level, Suggested Dept, Severity)
  Future<Map<String, dynamic>> analyzeImage(String imagePath);

  /// Parse document via OCR (returns Address, Road Name, Government Board, Survey Numbers, Landmarks)
  Future<Map<String, dynamic>> parseOcrDocument(String documentPath);

  /// Detect spatial and semantic duplicates
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng);

  /// Multilingual translation (supports English, Gujarati, Hindi)
  Future<String> translateMultilingual(String text, String targetLang);

  /// Language detection (returns 'en', 'gu', or 'hi')
  Future<String> detectLanguage(String text);

  /// Grammar correction and enhancement
  Future<String> correctGrammar(String text);

  /// Suggest official government department
  Future<String> suggestDepartment(String rawText);

  /// Calculate impact score based on cost and beneficiaries
  Future<double> calculateImpactScore(double estimatedCost, int beneficiaries);

  /// Conversational chat inference for Citizen, MP Copilot, and State Admin AI
  Future<String> chatInference(String prompt, List<Map<String, dynamic>> history, {required String role});

  /// Generate specialized role insights (e.g., MP approvals, State health summary, speech points)
  Future<String> generateRoleInsights(String promptType, Map<String, dynamic> context, {required String role});

  /// Convert natural language search queries into structured spatial/status filters
  Future<Map<String, dynamic>> naturalLanguageSearchToFilters(String query);

  /// Generate transparent AI reasoning explanation ("Why this decision?")
  Future<String> generateReasoning(String decisionType, Map<String, dynamic> data);
}
