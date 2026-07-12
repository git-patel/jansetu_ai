class PromptTemplates {
  static String citizenChat(String message, String history) {
    return '''
You are JanSetu AI, an empathetic civic assistant for citizens. 
Help them report local issues, understand government schemes, or query community needs.
History:
$history
Citizen: $message
Assistant:''';
  }

  static String complaintTriage(String title, String description) {
    return '''
Analyze the following civic complaint and categorize it.
Title: $title
Description: $description
Format the output as valid JSON:
{
  "category": "Roads & Traffic/Water & Sanitation/Electricity/Waste Management/Public Health/Others",
  "department": "PWD/Municipal Water/Electricity Board/Sanitation Dept/Health Dept/Other",
  "priorityScore": <number between 10.0 and 99.5>,
  "urgency": "LOW/MEDIUM/HIGH/CRITICAL",
  "summaryEn": "Short English description",
  "suggestedActions": ["Action 1", "Action 2"]
}''';
  }

  static String imageAnalysis(String description) {
    return '''
Analyze the image context and describe the damage level.
Context description: $description
Format output as JSON:
{
  "damageSeverity": "LOW/MEDIUM/HIGH/SEVERE",
  "structuralThreat": true/false,
  "confidenceScore": <0.0 to 1.0>,
  "detectedObjects": ["object1", "object2"]
}''';
  }

  static String mpRecommendation(String query, String statusSummary) {
    return '''
You are the JanSetu AI MP Copilot. Generate budget planning recommendations or answer questions.
Context Status Summary:
$statusSummary
Question: $query
Recommendation:''';
  }

  static String adminTriage(String question, String statusSummary) {
    return '''
You are the JanSetu AI Admin Copilot. Generate administrative insights, department ranks, or project recommendations.
State Status Summary:
$statusSummary
Question: $question
Insight:''';
  }

  static String summarizeComplaint(String rawText) {
    return '''
Provide a clean, concise, 2-sentence summary of this citizen grievance:
Grievance:
$rawText
Summary:''';
  }

  static String projectSummary(Map<String, dynamic> projectData) {
    return '''
Generate a professional progress summary for the following development project:
Data: $projectData
Summary:''';
  }

  static String citizenReply(String rawText) {
    return '''
Generate an encouraging and polite response to the citizen for their report:
Report: $rawText
Response:''';
  }

  static String stateSummary(Map<String, dynamic> stateData) {
    return '''
Generate a district-by-district progress and budget summary report:
Data: $stateData
Report:''';
  }
}
