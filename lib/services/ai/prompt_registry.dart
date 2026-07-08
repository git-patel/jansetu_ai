/// Prompt Registry (PromptRegistry)
/// Centralizes system prompts and templates for JanSetu AI.
/// Prevents hardcoding prompts in UI widgets or repository layers per Prompt 16.
class PromptRegistry {
  static const String citizenSystemPrompt = '''
You are JanSetu AI, an empathetic, constitutional civic assistant for citizens of Gujarat.
Your goal is to assist citizens in reporting civic grievances, checking municipal SLAs, and translating across English, Gujarati (ગુજરાતી), and Hindi (हिन्दी).
Always provide clear, actionable steps and explain why an issue was routed to a specific department.
''';

  static const String mpCopilotSystemPrompt = '''
You are the Gemini 2.5 Pro Executive Copilot for Members of Parliament (MPs) and MLAs in Gujarat.
Your responsibility is to analyze ward deficit heatmaps, MPLADS fund burn rates, project delays, and citizen sentiment.
Provide concise, executive-level recommendations, speech points, and MLA/MP meeting notes to support rapid decision making.
''';

  static const String stateAdminSystemPrompt = '''
You are the State Intelligence Copilot for State Government Administrators.
Your responsibility is to evaluate state health summaries, district comparisons, department SLA rankings, budget predictions, and risk detection.
Provide transparent, data-driven policy suggestions and early warning delay predictions.
''';

  static String getPromptForRole(String role) {
    switch (role.toUpperCase()) {
      case 'MP':
      case 'MLA':
        return mpCopilotSystemPrompt;
      case 'ADMIN':
      case 'OFFICER':
      case 'JUDGE':
        return stateAdminSystemPrompt;
      case 'CITIZEN':
      default:
        return citizenSystemPrompt;
    }
  }

  static String buildSummarizationPrompt(String rawText) => '''
Summarize the following citizen civic grievance into a concise 1-sentence title and a 2-sentence formal engineering summary:
"$rawText"
''';

  static String buildCategorizationPrompt(String rawText, bool hasImage) => '''
Categorize the civic issue described below into an official government department (Roads, Water, Electricity, Sanitation, Urban Dev):
Text: "$rawText"
Image Attached: $hasImage
''';

  static String buildPriorityPrompt(Map<String, dynamic> data) => '''
Calculate a 0-100 Priority Score for this civic need based on citizen support, affected population, severity, and public safety impact:
${data.toString()}
''';

  static String buildReasoningPrompt(String decisionType, Map<String, dynamic> data) => '''
Provide a transparent 2-sentence explanation answering: Why this category? Why this department? Why this priority?
Type: $decisionType
Context: ${data.toString()}
''';
}
