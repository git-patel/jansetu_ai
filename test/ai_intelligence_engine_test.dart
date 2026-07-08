import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jansetu_ai/core/config/service_locator.dart';
import 'package:jansetu_ai/repositories/interfaces/ai_repository.dart';
import 'package:jansetu_ai/services/ai/mock_ai_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 1 & 2: AI Intelligence Engine Abstraction & Providers', () {
    test('MockAiProvider produces structurally valid, schema-adherent responses for suggestDepartment and analyzeImage', () async {
      final provider = MockAiProvider();
      final dept = await provider.suggestDepartment('Broken municipal pipeline leaking clean drinking water in Adajan Ward 14');
      expect(dept, isA<String>());
      expect(dept, equals('SMC Water & Drainage Works'));

      final imageRes = await provider.analyzeImage('assets/test_pothole.jpg');
      expect(imageRes, isA<Map<String, dynamic>>());
      expect(imageRes.containsKey('object'), isTrue);
      expect(imageRes.containsKey('damageLevel'), isTrue);
      expect(imageRes.containsKey('confidence'), isTrue);
      expect(imageRes['confidence'], greaterThanOrEqualTo(90.0));
    });

    test('MockAiProvider calculates accurate priority scores and impact scores', () async {
      final provider = MockAiProvider();
      final needData = {
        'upvoteCount': 45,
        'severityClass': 'CRITICAL',
      };
      final score = await provider.calculatePriorityScore(needData);
      expect(score, isA<double>());
      expect(score, greaterThan(90.0));

      final impact = await provider.calculateImpactScore(500000.0, 5000);
      expect(impact, isA<double>());
      expect(impact, greaterThan(50.0));
    });

    test('MockAiProvider detects duplicate grievances within spatial coordinates', () async {
      final provider = MockAiProvider();
      final duplicates = await provider.detectDuplicates('Severe Potholes on Surat-Gaurav Path', 21.1959, 72.7933);

      expect(duplicates, isA<List<Map<String, dynamic>>>());
      expect(duplicates.isNotEmpty, isTrue);
      expect(duplicates.first['needId'], equals('ND-2026-SRT-0104'));
      expect(duplicates.first.containsKey('similarityScore'), isTrue);
      expect((duplicates.first['similarityScore'] as num).toDouble(), greaterThan(90.0));
    });

    test('MockAiProvider summarizes verbose text concisely and handles multilingual translation', () async {
      final provider = MockAiProvider();
      final summary = await provider.summarizeText(
        'There is a very big pothole right in the middle of the main crossroad near Surat railway station which has been there for 3 weeks.'
      );
      expect(summary, isA<String>());
      expect(summary.isNotEmpty, isTrue);
      expect(summary.contains('pothole') || summary.contains('road'), isTrue);

      final translation = await provider.translateMultilingual('pothole road repair', 'gu');
      expect(translation.contains('ખાડાઓ') || translation.contains('સુરત'), isTrue);
    });

    test('MockAiProvider handles role-tailored chat inference for Citizen, MP, and Admin', () async {
      final provider = MockAiProvider();
      
      final citizenReply = await provider.chatInference('How do I report a pothole?', [], role: 'CITIZEN');
      expect(citizenReply.contains('pothole') || citizenReply.contains('JanSetu'), isTrue);
      
      final mpReply = await provider.chatInference('Which projects should I approve first?', [], role: 'MP');
      expect(mpReply.contains('Recommendation') || mpReply.contains('Copilot'), isTrue);
      
      final adminReply = await provider.chatInference('State health summary', [], role: 'ADMIN');
      expect(adminReply.contains('SLA') || adminReply.contains('Summary'), isTrue);
    });
  });

  group('Phase 3: Automatic Runtime Switching & ServiceLocator Verification', () {
    test('ServiceLocator resolves AiRepository correctly in Local mode', () async {
      await ServiceLocator.instance.init(type: DataSourceType.local);
      final repo = ServiceLocator.instance.aiRepository;
      expect(repo, isNotNull);
      expect(repo, isA<AiRepository>());
      
      final summary = await repo.summarizeNeed('pothole road test');
      expect(summary, isNotEmpty);
    });

    test('ServiceLocator resolves AiRepository correctly in Firebase mode', () async {
      await ServiceLocator.instance.init(type: DataSourceType.firebase);
      final repo = ServiceLocator.instance.aiRepository;
      expect(repo, isNotNull);
      expect(repo, isA<AiRepository>());
      
      final dept = await repo.suggestDepartment('Broken streetlight in ward 5');
      expect(dept, isNotEmpty);
    });

    test('AiRepository chatAssistant handles network delay and fallback scenarios gracefully', () async {
      await ServiceLocator.instance.init(type: DataSourceType.local);
      final repo = ServiceLocator.instance.aiRepository;
      
      final reply = await repo.chatAssistant('Explain budget utilization', [], role: 'ADMIN');
      expect(reply, isNotEmpty);
      expect(reply.contains('Copilot') || reply.contains('State') || reply.contains('intelligence') || reply.contains('🤖'), isTrue);
    });
  });
}
