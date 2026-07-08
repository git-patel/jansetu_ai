# ROLE

You are a Principal Product Architect, Zero-Trust Security Expert, Enterprise User Experience Designer, and Flutter Systems Engineer for the JanSetu AI Enterprise Government Ecosystem.

Your task is to redesign the application launch experience and user flow to eliminate standalone entry points and replace them with a unified, role-driven enterprise authentication portal.

---

# IMPORTANT

Before starting, read these documents carefully:
- `docs/00_PROJECT_CONTEXT.md`
- `docs/01_PRODUCT_REQUIREMENTS.md`
- `docs/04_RBAC_AND_GOVERNANCE_MODEL.md`
- `docs/08_UI_UX_AND_PRODUCT_BLUEPRINT.md`

Use them as the source of truth for all 12 governance roles, boundary hierarchies, and design tokens.

---

# ARCHITECTURAL MANDATE: ROLE-DRIVEN STARTUP VS. SEPARATE APPS

In a production government ecosystem, citizens, Members of Parliament, and State Principal Secretaries do not open separate branded mobile applications or navigate through a static landing page grid. Instead, the entire platform operates as a unified, zero-trust **National Digital Twin Portal**.

You must implement the following unified user flow:
1. **Unified Launch**: When the user launches the application, they land on the **JanSetu AI Security & Authentication Gate (`JanSetuLoginScreen`)**.
2. **Enterprise Login & Cryptographic Token Verification**: The user enters or selects their credentials. The system verifies their identity and issues a simulated zero-trust cryptographic session token.
3. **Automated Role Detection**: The system inspects the user's role (`CITIZEN`, `MP_CONSTITUENCY`, or `STATE_ADMIN`).
4. **Automated Interface Mounting**: Based on the detected role, the application automatically mounts the exact workspace module required for their responsibilities:
   - `CITIZEN` $\rightarrow$ `CitizenAppModule` (1-Tap AI Intake Hub, Multilingual Voice Reporting, Ward Development Feed).
   - `MP_CONSTITUENCY` $\rightarrow$ `MpDashboardModule` (GIS Ward Heatmap, MPLADS Financial Burn Ledger, Capital Works Sanctioning).
   - `STATE_ADMIN` $\rightarrow$ `AdminPanelModule` (11-Tier Spatial Tree Navigator, Officer Inspection Queues, PFMS Escrow Audit Ledger).

---

# HACKATHON DEMO & EVALUATION REQUIREMENTS

During live hackathon evaluations and product demonstrations, presenters must be able to showcase the full end-to-end multi-persona ecosystem smoothly without friction or awkward login/logout cycles.

To support this without compromising the production architecture, implement two specialized developer tools:
1. **Quick-Login Demo Accounts on Authentication Portal**:
   Provide 1-tap demo credential cards on the login screen:
   - **Citizen Account**: Rajesh Bhai Patel (`CIT-SRT-8841`, Adajan Ward 14, Surat).
   - **MP Account**: Hon. C.R. Patil (`MP-GUJ-SRT-01`, Surat Constituency).
   - **State Admin Account**: Shri K.L. Mehta, IAS (`ADM-GUJ-HQ-001`, Principal Secretary / Chief Engineer).
2. **Hidden Dev-Mode Persona Switcher**:
   When running in development/debug mode, integrate a subtle header control `[ ⚡ Dev: Switch Persona ▾ ]` inside the active workspace. When tapped, it opens an immediate modal sheet allowing the presenter to switch directly between Citizen, MP, and State Admin personas in real time, alongside the `[ 🔄 Reset Demo Data ]` action.

---

# DELIVERABLES

1. Create comprehensive technical documentation in `docs/09_PRODUCT_REDESIGN_AND_COMPLETE_USER_FLOW.md` detailing the zero-trust authentication architecture, auto-routing algorithm, and hackathon demo instructions.
2. Extend `lib/services/local_persistence_service.dart` to persist session role and profile across app reloads using `shared_preferences`.
3. Build the Enterprise Authentication Gate (`lib/apps/auth/login_screen.dart`) and the Dev-Mode Persona Switcher modal (`lib/apps/auth/dev_persona_switcher_modal.dart`).
4. Refactor `lib/main.dart` into `JanSetuRoleRouter` to enforce automated role mounting and render the unified ecosystem header.
5. Engineer comprehensive E2E automated widget tests in `test/widget_test.dart` and verify clean build with `flutter analyze` and `flutter test`.
