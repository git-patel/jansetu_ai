/// Governance Analytics & Digital Twin Repository Interface
/// Dynamically computes ward development scores, citizen satisfaction, budget burn rates, and project progress.
abstract class AnalyticsRepository {
  Future<double> calculateDevelopmentScore(String jurisdictionId);
  Future<double> getCitizenSatisfaction(String jurisdictionId);
  Future<Map<String, dynamic>> getBudgetUtilization(String jurisdictionId);
  Future<List<Map<String, dynamic>>> getDepartmentPerformance(String jurisdictionId);
  Future<Map<String, dynamic>> getProjectProgress(String jurisdictionId);
}
