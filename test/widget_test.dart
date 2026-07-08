import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jansetu_ai/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'jansetu_onboarding_completed_v1': true,
    });
  });

  testWidgets('Phase 10: CTO Onboarding Flow & Language Selection Test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify Onboarding Welcome slide is shown
    expect(find.textContaining('AI Should Think.'), findsOneWidget);
    expect(find.textContaining('Skip to Login →'), findsOneWidget);

    // Tap Skip to Login
    await tester.tap(find.textContaining('Skip to Login →'));
    await tester.pumpAndSettle();

    // Verify transition to Zero-Trust Security Gateway
    expect(find.textContaining('JANSETU ZERO-TRUST CRYPTOGRAPHIC SECURITY GATEWAY'), findsOneWidget);
  });

  testWidgets('Phase 10: Role-Driven Security Gateway Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify that the zero-trust authentication portal is presented on fresh launch.
    expect(find.textContaining('JANSETU ZERO-TRUST CRYPTOGRAPHIC SECURITY GATEWAY'), findsOneWidget);
    expect(find.textContaining('JanSetu AI — Enterprise Governance Ecosystem'), findsOneWidget);
    expect(find.textContaining('Continue in Demo Mode'), findsOneWidget);

    // Tap Continue in Demo Mode to reveal the 3 Quick-Login Demo Cards
    final demoBtn1 = find.textContaining('Continue in Demo Mode');
    await tester.ensureVisible(demoBtn1);
    await tester.tap(demoBtn1);
    await tester.pumpAndSettle();

    expect(find.textContaining('Hackathon Evaluation Mode: 1-Tap Quick-Login Active'), findsOneWidget);

    // Verify all 3 Quick-Login Demo Cards are present.
    expect(find.textContaining('Rajesh Bhai Patel'), findsOneWidget);
    expect(find.textContaining('Hon. C.R. Patil'), findsOneWidget);
    expect(find.textContaining('Shri K.L. Mehta, IAS'), findsOneWidget);
  });

  testWidgets('Phase 10: Citizen 1-Tap Quick-Login & AI Grievance Reporting E2E Test', (WidgetTester tester) async {
    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Tap Continue in Demo Mode to reveal demo personas
    final demoBtn2 = find.textContaining('Continue in Demo Mode');
    await tester.ensureVisible(demoBtn2);
    await tester.tap(demoBtn2);
    await tester.pumpAndSettle();

    // Tap on Rajesh Bhai Patel (Citizen Persona) card
    final citizenCard = find.textContaining('Rajesh Bhai Patel');
    await tester.ensureVisible(citizenCard);
    await tester.tap(citizenCard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify zero-trust token verification interstitial is shown
    expect(find.textContaining('Verifying Zero-Trust Identity Token'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we auto-routed into CitizenAppModule and top Enterprise Header shows citizen session
    expect(find.textContaining('JanSetu AI Enterprise Portal'), findsOneWidget);
    expect(find.textContaining('Adajan Ward 14, Surat'), findsOneWidget);
    expect(find.textContaining('Rajesh Bhai Patel'), findsWidgets);
    expect(find.textContaining('⚡ Dev: Switch Persona ▾'), findsOneWidget);

    // Verify 1-Tap Report Issue FAB is present and tap it
    final fabFinder = find.textContaining('1-Tap Report Issue');
    expect(fabFinder, findsOneWidget);
    await tester.tap(fabFinder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify AI Intake modal is shown with Mode Selector options
    expect(find.textContaining('1-Tap AI Intake Hub'), findsOneWidget);
    expect(find.textContaining('Voice Recording'), findsOneWidget);

    // Tap on Voice Recording mode
    await tester.tap(find.textContaining('Voice Recording'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tap Stop & Process AI
    await tester.tap(find.textContaining('Stop & Process AI'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tap Skip Animation (Test Mode) if still present (fast async completion may auto-advance)
    final skipBtn = find.textContaining('Skip Animation');
    if (skipBtn.evaluate().isNotEmpty) {
      await tester.tap(skipBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    } else {
      await tester.pump(const Duration(milliseconds: 500));
    }

    // Verify AI confirmation checkpoint is displayed
    expect(find.textContaining('AI CONFIRMATION CHECKPOINT'), findsOneWidget);

    // Ensure Confirm & Submit button is visible before tapping
    final confirmBtn = find.textContaining('Confirm & Submit');
    await tester.ensureVisible(confirmBtn);
    await tester.pump();
    await tester.tap(confirmBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify the newly submitted grievance is added to the live feed!
    expect(find.textContaining('Gaurav Path'), findsWidgets);
    expect(find.textContaining('AI Verified'), findsWidgets);
  });

  testWidgets('Phase 10: CTO Citizen Community Engagement, 6-Stage Timeline & My Area Twin Test', (WidgetTester tester) async {
    // Pre-seed session as Citizen
    SharedPreferences.setMockInitialValues({
      'jansetu_active_role_v1': 'CITIZEN',
      'jansetu_user_profile_v1': '{"name":"Rajesh Bhai Patel","id":"USR-CTZ-7721","role":"CITIZEN"}',
      'jansetu_onboarding_completed_v1': true,
    });

    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify LinkedIn-style social buttons are visible on feed cards
    expect(find.textContaining('Support (235)'), findsWidgets);
    expect(find.textContaining('Comments (18)'), findsWidgets);

    // Tap View Timeline to open EntityDetailModal
    final timelineBtn = find.textContaining('View Timeline ➔').first;
    await tester.ensureVisible(timelineBtn);
    await tester.tap(timelineBtn);
    await tester.pumpAndSettle();

    // Verify 6-Stage Timeline and AI intelligence metadata inside modal
    expect(find.textContaining('6-Stage Visual Progress Timeline'), findsOneWidget);
    expect(find.textContaining('Gemini 2.5 Pro — Complete Civic Metadata Analysis'), findsOneWidget);
    expect(find.textContaining('11-Tier Spatial Lineage'), findsOneWidget);

    // Close modal
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Switch to My Area tab
    final myAreaTab = find.textContaining('My Area');
    await tester.ensureVisible(myAreaTab);
    await tester.tap(myAreaTab);
    await tester.pumpAndSettle();

    // Verify ward digital twin stats and hotlines
    expect(find.textContaining('Adajan Ward 14, Surat West'), findsOneWidget);
    expect(find.textContaining('AI Score: 84.2/100'), findsWidgets);
    expect(find.textContaining('Emergency Civic Hotlines'), findsOneWidget);
  });

  testWidgets('Phase 10: Hackathon Dev-Mode Switcher to MP Command Center & 1-Tap Sanction E2E Test', (WidgetTester tester) async {
    // Pre-seed session as Citizen
    SharedPreferences.setMockInitialValues({
      'jansetu_active_role_v1': 'CITIZEN',
      'jansetu_user_profile_v1': '{"name":"Rajesh Bhai Patel","id":"CIT-SRT-8841","role":"CITIZEN"}',
    });

    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we start inside Citizen workspace
    expect(find.textContaining('Adajan Ward 14, Surat'), findsOneWidget);

    // Tap on [ ⚡ Dev: Switch Persona ▾ ] button in top header
    final devBtn1 = find.textContaining('⚡ Dev: Switch Persona ▾');
    await tester.ensureVisible(devBtn1);
    await tester.tap(devBtn1);
    await tester.pumpAndSettle();

    // Verify hidden switcher bottom sheet opens
    expect(find.textContaining('Dev-Mode Persona Switcher'), findsOneWidget);
    expect(find.textContaining('MP Executive — Hon. C.R. Patil'), findsOneWidget);

    // Tap on MP Executive option
    final mpOption = find.textContaining('MP Executive — Hon. C.R. Patil');
    await tester.ensureVisible(mpOption);
    await tester.tap(mpOption);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we instantaneously switched into MP Command Center workspace!
    expect(find.textContaining('Surat Constituency'), findsOneWidget);
    expect(find.textContaining('₹5.00 Cr Active'), findsOneWidget);
    expect(find.textContaining('Hon. C.R. Patil'), findsWidgets);

    // Sanction ₹50 Lakhs for Varachha emergency works
    final sanctionBtn = find.textContaining('Sanction ₹50 Lakhs');
    expect(sanctionBtn, findsOneWidget);
    await tester.ensureVisible(sanctionBtn);
    await tester.pumpAndSettle();
    await tester.tap(sanctionBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify MPLADS fund balance dropped to ₹4.50 Cr Active
    expect(find.textContaining('₹4.50 Cr Active'), findsOneWidget);
    expect(find.textContaining('SANCTIONED CONSTITUENCY PROJECTS QUEUE'), findsOneWidget);
  });

  testWidgets('Phase 10: Hackathon Dev-Mode Switcher to State Admin Panel & Tranche Release E2E Test', (WidgetTester tester) async {
    // Pre-seed session as MP
    SharedPreferences.setMockInitialValues({
      'jansetu_active_role_v1': 'MP',
      'jansetu_user_profile_v1': '{"name":"Hon. C.R. Patil","id":"MP-GUJ-SRT-01","role":"MP"}',
    });

    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we start in MP workspace
    expect(find.textContaining('Surat Constituency'), findsOneWidget);

    // Tap on [ ⚡ Dev: Switch Persona ▾ ] in top header
    final devBtn2 = find.textContaining('⚡ Dev: Switch Persona ▾');
    await tester.ensureVisible(devBtn2);
    await tester.tap(devBtn2);
    await tester.pumpAndSettle();

    // Tap on State Admin option
    final adminOption = find.textContaining('State Admin — Shri K.L. Mehta, IAS');
    await tester.ensureVisible(adminOption);
    await tester.tap(adminOption);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we instantaneously switched into State Admin Panel workspace!
    expect(find.textContaining('11-TIER SPATIAL HIERARCHY'), findsOneWidget);
    expect(find.textContaining('PFMS SMART ESCROW AUDIT LEDGER'), findsOneWidget);
    expect(find.textContaining('Shri K.L. Mehta, IAS'), findsWidgets);

    // Authorize Tranche Release for flyover project
    final authorizeBtn = find.textContaining('Authorize Tranche Release').first;
    await tester.ensureVisible(authorizeBtn);
    await tester.pumpAndSettle();
    await tester.tap(authorizeBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify status upgraded to MILESTONE_VERIFIED!
    expect(find.textContaining('MILESTONE_VERIFIED'), findsWidgets);
  });

  testWidgets('Phase 10: Hackathon Demo Reset and Logout & Lock Portal E2E Test', (WidgetTester tester) async {
    // Pre-seed session as Admin
    SharedPreferences.setMockInitialValues({
      'jansetu_active_role_v1': 'ADMIN',
      'jansetu_user_profile_v1': '{"name":"Shri K.L. Mehta, IAS","id":"ADM-GUJ-HQ-001","role":"ADMIN"}',
      'jansetu_onboarding_completed_v1': true,
    });

    await tester.pumpWidget(const JanSetuEnterpriseHub());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify inside Admin workspace
    expect(find.textContaining('11-TIER SPATIAL HIERARCHY'), findsOneWidget);

    // Open Dev Switcher modal
    final devBtn3 = find.textContaining('⚡ Dev: Switch Persona ▾');
    await tester.ensureVisible(devBtn3);
    await tester.tap(devBtn3);
    await tester.pumpAndSettle();

    // Click Reset Demo Data
    final resetBtn = find.textContaining('Reset Demo Data');
    await tester.ensureVisible(resetBtn);
    await tester.tap(resetBtn);
    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.textContaining('Demo data reset').evaluate().isNotEmpty) {
        break;
      }
    }

    // Verify reset snackbar and that we returned to unauthenticated zero-trust security gate!
    expect(find.textContaining('Demo data reset'), findsWidgets);
    expect(find.textContaining('JANSETU ZERO-TRUST CRYPTOGRAPHIC SECURITY GATEWAY'), findsOneWidget);
  });
}
