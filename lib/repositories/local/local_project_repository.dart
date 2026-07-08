import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/synthetic_gujarat_data.dart';
import '../../core/utils/logger.dart';
import '../interfaces/project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  static const String _projectsKey = 'jansetu_projects_cache_v1';
  static const String _mpladsKey = 'jansetu_mplads_balance_v1';
  static const String _ledgerKey = 'jansetu_ledger_cache_v1';

  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _ledgerProjects = [];
  double _mpladsFundBalanceINR = SyntheticGujaratData.defaultMpladsFundINR;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_mpladsKey)) {
      _mpladsFundBalanceINR = prefs.getDouble(_mpladsKey) ?? SyntheticGujaratData.defaultMpladsFundINR;
    } else {
      _mpladsFundBalanceINR = SyntheticGujaratData.defaultMpladsFundINR;
    }

    if (prefs.containsKey(_projectsKey)) {
      try {
        final raw = prefs.getString(_projectsKey);
        if (raw != null) {
          final decoded = json.decode(raw) as List<dynamic>;
          _projects = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode cached projects', e, null, 'LocalProjectRepo');
      }
    }
    if (_projects.isEmpty) {
      _projects = List.from(SyntheticGujaratData.fallbackProjects.map((e) => Map<String, dynamic>.from(e)));
    }

    if (prefs.containsKey(_ledgerKey)) {
      try {
        final raw = prefs.getString(_ledgerKey);
        if (raw != null) {
          final decoded = json.decode(raw) as List<dynamic>;
          _ledgerProjects = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      } catch (e) {
        JanSetuLogger.error('Failed to decode cached ledger projects', e, null, 'LocalProjectRepo');
      }
    }
    if (_ledgerProjects.isEmpty) {
      _ledgerProjects = List.from(SyntheticGujaratData.fallbackLedger.map((e) => Map<String, dynamic>.from(e)));
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_mpladsKey, _mpladsFundBalanceINR);
    await prefs.setString(_projectsKey, json.encode(_projects));
    await prefs.setString(_ledgerKey, json.encode(_ledgerProjects));
  }

  @override
  List<Map<String, dynamic>> getProjects() => _projects;

  @override
  List<Map<String, dynamic>> getLedgerProjects() => _ledgerProjects;

  @override
  double getMpladsFundBalanceINR() => _mpladsFundBalanceINR;

  @override
  Future<void> create(Map<String, dynamic> project) async {
    _projects.insert(0, project);
    await _saveToPrefs();
  }

  @override
  Future<void> saveSanction(Map<String, dynamic> newProject, double amountINR) async {
    _mpladsFundBalanceINR = (_mpladsFundBalanceINR - amountINR).clamp(0.0, double.infinity);
    _projects.insert(0, newProject);
    await _saveToPrefs();
    JanSetuLogger.success('Sanctioned project ${newProject['projectId']} for ₹$amountINR', 'LocalProjectRepo');
  }

  @override
  Future<void> approve(int index) async {
    if (index >= 0 && index < _projects.length) {
      _projects[index]['currentStatus'] = 'APPROVED';
      await _saveToPrefs();
    }
  }

  @override
  Future<void> assignOfficer(int index, String officerId, String officerName) async {
    if (index >= 0 && index < _projects.length) {
      final ownership = Map<String, dynamic>.from(_projects[index]['ownership'] ?? {});
      ownership['responsibleOfficerId'] = officerId;
      ownership['officerName'] = officerName;
      _projects[index]['ownership'] = ownership;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> updateTimeline(int index, String stage, String dateStr) async {
    if (index >= 0 && index < _projects.length) {
      final timeline = Map<String, dynamic>.from(_projects[index]['timeline'] ?? {});
      timeline[stage] = dateStr;
      _projects[index]['timeline'] = timeline;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> allocateBudget(int index, double amountINR) async {
    if (index >= 0 && index < _projects.length) {
      final financials = Map<String, dynamic>.from(_projects[index]['financials'] ?? {});
      financials['sanctionedBudgetINR'] = amountINR;
      _projects[index]['financials'] = financials;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> recordInspection(int index, Map<String, dynamic> inspectionData) async {
    if (index >= 0 && index < _projects.length) {
      final inspections = List<Map<String, dynamic>>.from(_projects[index]['inspections'] ?? []);
      inspections.add(inspectionData);
      _projects[index]['inspections'] = inspections;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> uploadMedia(int index, String mediaUrl, String caption) async {
    if (index >= 0 && index < _projects.length) {
      final media = List<Map<String, dynamic>>.from(_projects[index]['media'] ?? []);
      media.add({'url': mediaUrl, 'caption': caption, 'timestamp': DateTime.now().toIso8601String()});
      _projects[index]['media'] = media;
      await _saveToPrefs();
    }
  }

  @override
  List<Map<String, dynamic>> getHistory(String projectId) {
    return _projects.where((p) => p['projectId'] == projectId).toList();
  }

  @override
  Future<void> updateProject(int index, Map<String, dynamic> updatedProject) async {
    if (index >= 0 && index < _projects.length) {
      _projects[index] = updatedProject;
      await _saveToPrefs();
    }
  }

  @override
  Future<void> updateLedgerProject(int index, Map<String, dynamic> updatedProject) async {
    if (index >= 0 && index < _ledgerProjects.length) {
      _ledgerProjects[index] = updatedProject;
      await _saveToPrefs();
    }
  }
}
