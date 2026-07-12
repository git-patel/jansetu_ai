abstract class AIRepository {
  Future<String> chat(String prompt, String history, {String role = 'CITIZEN'});
  
  Future<String> summarizeComplaint(String rawText);
  
  Future<Map<String, dynamic>> analyzeImage(String description);
  
  Future<String> detectDepartment(String rawText);
  
  Future<double> suggestPriority(String title, String description);
  
  Future<String> generateProjectSummary(Map<String, dynamic> projectData);
  
  Future<String> generateCitizenReply(String rawText);
  
  Future<String> generateMpRecommendation(String query, String statusSummary);
  
  Future<String> generateStateSummary(Map<String, dynamic> stateData);
}
