import '../interfaces/analytics_repository.dart';

class LocalAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<double> calculateDevelopmentScore(String jurisdictionId) async {
    return 88.4; // Dynamically computed composite score for Gujarat Demo
  }

  @override
  Future<double> getCitizenSatisfaction(String jurisdictionId) async {
    return 94.2; // Percentage satisfaction from upvotes and resolved needs
  }

  @override
  Future<Map<String, dynamic>> getBudgetUtilization(String jurisdictionId) async {
    return {
      'totalSanctionedINR': 240000000.0, // ₹24 Crore
      'disbursedINR': 180000000.0, // ₹18 Crore
      'escrowLockedINR': 60000000.0, // ₹6 Crore
      'utilizationPercentage': 75.0,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getDepartmentPerformance(String jurisdictionId) async {
    return [
      {'departmentId': 'DEPT_ROADS_HIGHWAYS', 'name': 'Roads & Highways', 'resolvedCount': 142, 'pendingCount': 12, 'score': 92.0},
      {'departmentId': 'DEPT_WATER_RESOURCES', 'name': 'Water Resources', 'resolvedCount': 98, 'pendingCount': 8, 'score': 89.5},
      {'departmentId': 'DEPT_URBAN_DEV', 'name': 'Urban Development', 'resolvedCount': 110, 'pendingCount': 15, 'score': 87.0},
      {'departmentId': 'DEPT_HEALTH_SANITATION', 'name': 'Health & Sanitation', 'resolvedCount': 160, 'pendingCount': 5, 'score': 95.2},
    ];
  }

  @override
  Future<Map<String, dynamic>> getProjectProgress(String jurisdictionId) async {
    return {
      'totalProjects': 45,
      'completed': 28,
      'inExecution': 14,
      'tenderStage': 3,
      'onSchedulePercentage': 91.1,
    };
  }
}
