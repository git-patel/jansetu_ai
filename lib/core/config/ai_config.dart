/// AI & Google Gemini API Configurations Registry
class AiConfig {
  /// Add your Gemini API Key here to enable direct client-side cloud LLM inference.
  /// If left blank or as default, JanSetu AI will automatically fall back to the offline Mock Engine.
  static const String geminiApiKey = 'AQ.Ab8R';
}

class AIConfig {
  static const String geminiApiKey = AiConfig.geminiApiKey;
}
