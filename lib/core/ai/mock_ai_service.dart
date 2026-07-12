import 'ai_service.dart';

class MockAIService implements AIService {
  @override
  Future<AIResponse> generate(AIRequest request) async {
    // Emulate brief processing delay
    await Future.delayed(const Duration(milliseconds: 150));
    final lower = request.prompt.toLowerCase();

    // Check keywords to return matching mock content
    if (lower.contains('categorize') || lower.contains('category')) {
      return const AIResponse(
        text: '''
{
  "category": "Roads & Infrastructure",
  "department": "PWD/Municipal Corporation",
  "priorityScore": 84.5,
  "urgency": "HIGH",
  "summaryEn": "Potholes reported near school causing traffic safety concerns.",
  "suggestedActions": ["Patching potholes", "Erecting caution signs"]
}
''',
        isMock: true,
      );
    }

    if (lower.contains('damage level') || lower.contains('image analysis')) {
      return const AIResponse(
        text: '''
{
  "damageSeverity": "CRITICAL_DAMAGE",
  "structuralThreat": true,
  "confidenceScore": 0.98,
  "detectedObjects": ["Cracked Asphalt", "Exposed Subbase"]
}
''',
        isMock: true,
      );
    }

    if (lower.contains('mp copilot') || lower.contains('mp prompt') || lower.contains('mp recommendation')) {
      return const AIResponse(
        text: '🤖 **MP Recommendation:** Based on constituent feedback and a high priority rating of 84.5/100, we recommend approving the road resurfacing budget of ₹15,00,000 for Adajan Gaurav Path today to improve community safety.',
        isMock: true,
      );
    }

    if (lower.contains('admin copilot') || lower.contains('state status') || lower.contains('admin prompt')) {
      return const AIResponse(
        text: '🤖 **Admin Insight:** SLA compliance across all districts averages 91.4%. Surat Municipal Corporation is performing best at 96.2%, while Bharuch Rural requires intervention due to monsoon delays.',
        isMock: true,
      );
    }

    if (lower.contains('summarize') || lower.contains('summary prompt')) {
      return const AIResponse(
        text: 'Residents report severe potholes on Gaurav Path near Navyug College causing significant traffic delays and safety hazards.',
        isMock: true,
      );
    }

    if (lower.contains('encouraging') || lower.contains('citizen reply')) {
      return const AIResponse(
        text: 'Thank you for reporting this issue. Your report has been verified by our AI Engine and routed to the municipal department for resolution. You can track progress directly in the app.',
        isMock: true,
      );
    }

    if (lower.contains('state summary') || lower.contains('district-by-district')) {
      return const AIResponse(
        text: 'District-wise development report: Surat (Active: 12, Budget: ₹8.40 Cr, SLA: 96%), Vadodara (Active: 8, Budget: ₹5.10 Cr, SLA: 92%), Bharuch (Active: 4, Budget: ₹1.80 Cr, SLA: 78%).',
        isMock: true,
      );
    }

    return const AIResponse(
      text: '🤖 **Mock AI Service Response:** Active. Gemini engine is unconfigured or offline. Mocking output for demo consistency.',
      isMock: true,
    );
  }
}
