/// Capital Project & MPLADS Repository Interface
/// Manages MP sanctioned capital works, PFMS escrow tranches, and engineering inspection audits.
abstract class ProjectRepository {
  List<Map<String, dynamic>> getProjects();
  List<Map<String, dynamic>> getLedgerProjects();
  double getMpladsFundBalanceINR();
  Future<void> create(Map<String, dynamic> project);
  Future<void> saveSanction(Map<String, dynamic> newProject, double amountINR);
  Future<void> approve(int index);
  Future<void> assignOfficer(int index, String officerId, String officerName);
  Future<void> updateTimeline(int index, String stage, String dateStr);
  Future<void> allocateBudget(int index, double amountINR);
  Future<void> recordInspection(int index, Map<String, dynamic> inspectionData);
  Future<void> uploadMedia(int index, String mediaUrl, String caption);
  List<Map<String, dynamic>> getHistory(String projectId);
  Future<void> updateProject(int index, Map<String, dynamic> updatedProject);
  Future<void> updateLedgerProject(int index, Map<String, dynamic> updatedProject);
}
