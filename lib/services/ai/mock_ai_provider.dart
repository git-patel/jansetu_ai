import 'dart:math' as math;
import '../../core/utils/logger.dart';
import 'ai_provider.dart';

/// Mock AI Provider Implementation (MockAiProvider)
/// Ensures 100% offline hackathon evaluation and demo reliability without internet or API keys.
/// Provides rich bilingual responses (Gujarati/Hindi/English), OCR parsing, image damage classification,
/// MP executive recommendations, and transparent reasoning per Prompt 16.
class MockAiProvider implements AiProvider {
  @override
  Future<String> summarizeText(String rawText) async {
    JanSetuLogger.info('Mock AI: Summarizing text offline...', 'MockAiProvider');
    if (rawText.contains('ખાડા') || rawText.toLowerCase().contains('pothole') || rawText.toLowerCase().contains('road')) {
      return 'Severe road surface deterioration on Gaurav Path causing traffic bottlenecks and safety risks.';
    }
    if (rawText.contains('પાણી') || rawText.toLowerCase().contains('water') || rawText.toLowerCase().contains('leak')) {
      return 'Main municipal pipeline leakage impacting drinking water supply in residential sectors.';
    }
    if (rawText.contains('વીજળી') || rawText.toLowerCase().contains('light') || rawText.toLowerCase().contains('electric')) {
      return 'Street lighting malfunction reported, raising nighttime public safety concerns.';
    }
    return 'Verified citizen grievance recorded for structural assessment and department routing.';
  }

  @override
  Future<String> categorizeIssue(String rawText, {bool hasImage = false}) async {
    final lower = rawText.toLowerCase();
    if (lower.contains('road') || lower.contains('pothole') || lower.contains('bridge') || rawText.contains('ખાડા') || rawText.contains('રસ્તો')) {
      return 'Roads & Infrastructure';
    }
    if (lower.contains('water') || lower.contains('pipe') || lower.contains('drain') || rawText.contains('પાણી') || rawText.contains('ગટર')) {
      return 'Water & Sanitation';
    }
    if (lower.contains('light') || lower.contains('electric') || lower.contains('lamp') || rawText.contains('વીજળી') || rawText.contains('લાઇટ')) {
      return 'Electricity & Lighting';
    }
    if (lower.contains('garbage') || lower.contains('waste') || lower.contains('health') || rawText.contains('કચરો')) {
      return 'Health & Sanitation';
    }
    return 'Urban Development & Public Works';
  }

  @override
  Future<double> calculatePriorityScore(Map<String, dynamic> data) async {
    final upvotes = ((data['upvoteCount'] as num?)?.toInt() ?? 10);
    final severity = data['severityClass'] as String? ?? 'MEDIUM';
    double base = 72.0;
    if (severity == 'CRITICAL') base = 91.5;
    if (severity == 'HIGH') base = 84.0;
    final bonus = math.min(8.0, upvotes * 0.15);
    return (base + bonus).clamp(10.0, 99.5);
  }

  @override
  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    JanSetuLogger.info('Mock AI: Analyzing civic image damage classification...', 'MockAiProvider');
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'object': 'Bituminous Road Surface & Pavement',
      'condition': 'Severely Eraded with Deep Crater Potholes',
      'damageLevel': 'CRITICAL_DAMAGE (Depth > 4 inches)',
      'suggestedDepartment': 'Roads & Buildings Department (R&B)',
      'estimatedSeverity': 'CRITICAL',
      'confidence': 98.4,
    };
  }

  @override
  Future<Map<String, dynamic>> parseOcrDocument(String documentPath) async {
    JanSetuLogger.info('Mock AI: Running OCR parser on document/bill...', 'MockAiProvider');
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'address': 'Gaurav Path Road, Opp. Navyug College, Adajan, Surat-395009',
      'roadName': 'Adajan Gaurav Path Highway',
      'governmentBoard': 'Surat Municipal Corporation (West Zone-B)',
      'surveyNumber': 'SRV-GUJ-SRT-2026/8841',
      'landmark': 'Near L&T Metro Pillar 42',
      'rawText': 'SURAT MUNICIPAL CORPORATION - WEST ZONE B - SURVEY 8841 - GAURAV PATH ROAD WORK ORDER',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> detectDuplicates(String title, double lat, double lng) async {
    JanSetuLogger.info('Mock AI: Checking nearby spatial/semantic duplicates...', 'MockAiProvider');
    // Emulate a duplicate suggestion for common pothole reports to demonstrate the support prompt
    if (title.toLowerCase().contains('pothole') || title.contains('ખાડા') || title.toLowerCase().contains('gaurav')) {
      return [
        {
          'needId': 'ND-2026-SRT-0104',
          'titleEnglish': 'Severe Potholes on Surat-Gaurav Path',
          'titleVernacular': 'સુરત ગૌરવ પથ પર ગંભીર ખાડાઓ',
          'departmentId': 'DEPT_ROADS_HIGHWAYS',
          'priorityScore': 94.5,
          'status': 'VERIFIED_AI',
          'upvoteCount': 235,
          'geospatial': {'lat': 21.1959, 'lng': 72.7933},
          'similarityScore': 92.0,
        }
      ];
    }
    return [];
  }

  @override
  Future<String> translateMultilingual(String text, String targetLang) async {
    JanSetuLogger.info('Mock AI: Translating text to $targetLang...', 'MockAiProvider');
    if (targetLang.toLowerCase() == 'gu' || targetLang.toLowerCase() == 'gujarati') {
      if (text.toLowerCase().contains('pothole') || text.toLowerCase().contains('road')) {
        return 'સુરત ગૌરવ પથ પર ગંભીર ખાડાઓ અને ટ્રાફિક સમસ્યા. તાત્કાલિક સમારકામ જરૂરી છે.';
      }
      return 'નાગરિક ફરિયાદની ખરાઈ કરવામાં આવી છે અને સંબંધિત વિભાગને મોકલવામાં આવી છે.';
    }
    if (targetLang.toLowerCase() == 'hi' || targetLang.toLowerCase() == 'hindi') {
      if (text.toLowerCase().contains('pothole') || text.toLowerCase().contains('road')) {
        return 'सूरत गौरव पथ पर गंभीर गड्ढे और भारी यातायात जाम। तत्काल सड़क मरम्मत की आवश्यकता है।';
      }
      return 'नागरिक शिकायत का सत्यापन किया गया है और संबंधित विभाग को अग्रेषित किया गया है।';
    }
    // Default English
    return 'Severe road surface potholes reported on Adajan Gaurav Path. Immediate municipal intervention requested.';
  }

  @override
  Future<String> detectLanguage(String text) async {
    if (text.contains('અ') || text.contains('ક') || text.contains('ખાડા') || text.contains('પાણી')) return 'gu';
    if (text.contains('अ') || text.contains('क') || text.contains('गड्ढे') || text.contains('सड़क')) return 'hi';
    return 'en';
  }

  @override
  Future<String> correctGrammar(String text) async {
    return text.trim().replaceAll('  ', ' ');
  }

  @override
  Future<String> suggestDepartment(String rawText) async {
    final cat = await categorizeIssue(rawText);
    if (cat == 'Roads & Infrastructure') return 'Roads & Building Department (R&B)';
    if (cat == 'Water & Sanitation') return 'SMC Water & Drainage Works';
    if (cat == 'Electricity & Lighting') return 'PGVCL Power Distribution';
    if (cat == 'Health & Sanitation') return 'Municipal Solid Waste Management';
    return 'District Collectorate / Urban Development';
  }

  @override
  Future<double> calculateImpactScore(double estimatedCost, int beneficiaries) async {
    if (beneficiaries <= 0) return 50.0;
    double ratio = beneficiaries / (estimatedCost / 100000.0);
    double score = (ratio * 3.0) + 45.0;
    return score.clamp(25.0, 99.0);
  }

  @override
  Future<String> chatInference(String prompt, List<Map<String, dynamic>> history, {required String role}) async {
    JanSetuLogger.info('Mock AI Chat Inference for role [$role]: $prompt', 'MockAiProvider');
    final lower = prompt.toLowerCase();

    if (lower.contains('mplads') || lower.contains('utilization') || lower.contains('fund') || lower.contains('બજેટ')) {
      return '🤖 **Parliamentary Fund Transparency Report:**\n\n* **Sanctioned Budget:** ₹5.00 Crore\n* **Disbursed Amount:** ₹3.50 Crore\n* **Current Utilization Rate:** 70% (Ranked top 5 in Gujarat)\n* **Active Works:** 42 development projects across 14 municipal wards.';
    }

    if (role.toUpperCase() == 'MP' || role.toUpperCase() == 'MLA') {
      if (lower.contains('approve') || lower.contains('what') || lower.contains('today') || lower.contains('priority')) {
        return '🤖 **MP Executive Copilot Recommendation:**\n\nI recommend approving **Project PRJ-2026-SRT-8841** (4-Lane Elevated Flyover at Adajan Patia) today.\n\n* **Why?** It addresses grievance **ND-2026-SRT-0104** (235 citizen upvotes, Priority 94.5/100).\n* **Budget Impact:** Sanctioning ₹1.50 Crore from your ₹3.50 Crore MPLADS Escrow Balance will leave ₹2.00 Crore reserve.\n* **Citizen Sentiment:** 88% positive sentiment boost projected across Adajan Ward 14.';
      }
      if (lower.contains('delay') || lower.contains('why') || lower.contains('stalled')) {
        return '🤖 **AI Project Delay Analysis:**\n\nProject **PRJ-2026-SRT-8841** is currently flagged for **Tranche 2 Audit Verification**.\n\n* **Root Cause:** Monsoon surface drainage inspection pending from executive engineer.\n* **Recommendation:** Tap "Assign Officer" to expedite onsite quality certification by Executive Engineer Off. R.K. Patel.';
      }
      if (lower.contains('report') || lower.contains('constituency') || lower.contains('progress')) {
        return '🤖 **Surat Parliamentary Constituency Daily Briefing:**\n\n* **Active Sanctions:** 12 Capital Works in execution (Total Val: ₹8.40 Cr).\n* **MPLADS Utilization Rate:** 76.5% (Ranked #1 in Gujarat).\n* **Top Citizen Request:** Drainage line upgrade in Varachha North (142 upvotes).';
      }
      return '🤖 **MP Executive Copilot:** I am ready to generate meeting notes, analyze ward heatmaps, or recommend MPLADS fund sanctions. Ask me: *"What should I approve today?"* or *"Which wards need immediate attention?"*';
    }

    if (role.toUpperCase() == 'ADMIN' || role.toUpperCase() == 'OFFICER') {
      if (lower.contains('health') || lower.contains('state') || lower.contains('summary')) {
        return '🤖 **Gujarat State Intelligence Health Summary:**\n\n* **State SLA Velocity:** 91.4% grievances resolved within statutory 48-hour timeline.\n* **Top Performing District:** Surat Municipal Corporation (96.2% score).\n* **District Requiring Attention:** Bharuch Rural (SLA drop to 78% due to monsoon road repairs).\n* **Escrow Liquidity:** ₹450 Crore active in PFMS Tranche accounts.';
      }
      if (lower.contains('risk') || lower.contains('delay') || lower.contains('prediction')) {
        return '🤖 **AI Risk & Delay Prediction Heatmap:**\n\n* **High Risk Zone:** South Gujarat coastal bridge projects (Predicted 14-day delay due to heavy rainfall alerts).\n* **Financial Risk:** 3 contractor escrow accounts in Vadodara pending utilization certificates for over 30 days.\n* **Policy Suggestion:** Auto-trigger SMS alerts to Executive Engineers for pending Phase 2 audits.';
      }
      return '🤖 **State Admin Intelligence Copilot:** I am monitoring 33 districts across Gujarat. Ask me: *"State Health Summary"*, *"Department SLA Rankings"*, or *"Predict budget risks for next quarter"*';
    }

    // Default Citizen Role
    if (lower.contains('road') || lower.contains('pothole') || lower.contains('work') || lower.contains('ખાડા')) {
      return '🤖 **JanSetu Civic Helper:**\n\nRegarding road works in **Adajan Ward 14**: The municipal engineering department has verified grievance **ND-2026-SRT-0104**. Hon. MP C.R. Patil has sanctioned ₹1.50 Crore for resurfacing and elevated flyover construction. Tranche 1 has been disbursed, and construction is **40% complete**!';
    }
    if (lower.contains('water') || lower.contains('pipe') || lower.contains('પાણી')) {
      return '🤖 **JanSetu Civic Helper:**\n\nThe 24x7 Surface Water Treatment Plant in Rander Ward is currently at **75% completion**. Water pressure in elevated blocks is expected to normalize by Friday.';
    }
    return '🤖 **Namaste! I am your JanSetu AI Civic Helper.**\n\nYou can report any civic issue by tapping the "Report Development Need" button. I can understand Gujarati, Hindi, or English! How may I assist you today?';
  }

  @override
  Future<String> generateRoleInsights(String promptType, Map<String, dynamic> context, {required String role}) async {
    return chatInference(promptType, [], role: role);
  }

  @override
  Future<Map<String, dynamic>> naturalLanguageSearchToFilters(String query) async {
    final lower = query.toLowerCase();
    String category = 'ALL';
    String status = 'ALL';
    if (lower.contains('road') || lower.contains('pothole') || lower.contains('bridge')) category = 'Roads & Infrastructure';
    if (lower.contains('water') || lower.contains('drain') || lower.contains('pipe')) category = 'Water & Sanitation';
    if (lower.contains('approved') || lower.contains('sanctioned') || lower.contains('active')) status = 'SANCTIONED';
    if (lower.contains('completed') || lower.contains('done')) status = 'COMPLETED';
    return {'category': category, 'status': status, 'query': query};
  }

  @override
  Future<String> generateReasoning(String decisionType, Map<String, dynamic> data) async {
    JanSetuLogger.info('Mock AI: Generating transparent AI reasoning...', 'MockAiProvider');
    final dept = data['departmentId'] ?? 'Roads & Buildings Dept';
    final pri = data['priorityScore'] ?? 88.5;
    return 'Why this category? AI identified keyword patterns indicating severe pavement degradation.\nWhy this department? Statutory jurisdiction for municipal roads belongs to $dept.\nWhy this priority ($pri/100)? High citizen corroboration (235 upvotes) combined with critical traffic safety risks.';
  }
}
