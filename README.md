# JanSetu AI — Government Digital Ecosystem & Constituency Intelligence Platform
> **Empowering Citizens. Enabling Smarter Governance.**
>
> India's most trusted AI-powered Constituency Development Platform transforming unstructured citizen feedback into verified, data-driven capital expenditure execution.

---

## 🌟 Executive Overview

**JanSetu AI** is an enterprise-grade **Government Digital Ecosystem** operating across an 11-tier administrative hierarchy—from India (National Root) down to Parliamentary Constituencies, Municipal Wards, and Area Localities. 

Built on the fundamental law that **"Citizens should never need to understand government departments, legal classifications, or administrative boundaries,"** JanSetu AI enables citizens to report public infrastructure failures using spoken regional dialects, photos, and video. Google Gemini 2.5 Pro multimodal AI automatically performs speech translation, department routing across 21+ official domains, spatial deduplication within a 500-meter radius, and objective severity scoring (0–100).

---

## 🏗️ Enterprise Architectural Pillars

1. **11-Tier Real Government Location Hierarchy**: Normalized parent-child tree mapping all 543 Parliamentary Constituencies, municipal corporations, and gram panchayats with geohash spatial indexing.
2. **12 Role-Based Access Control (RBAC) Roles**: Cryptographic custom JWT authentication claims isolating permissions across Citizens, MPs, MLAs, District Collectors, State Admins, Department Heads, Field Officers, Contractors, Auditors, and Moderators.
3. **Universal Digital Twin Engine**: 18-parameter real-time living documents per ward/village tracking population demographics, school/healthcare density, water storage capacity, budget utilization, and algorithmic AI Development Scores.
4. **Offline-First Riverpod MVVM Clean Architecture**: Multi-platform Flutter client and Next.js 15 executive web dashboards with SQLite/Hive edge caching and background synchronization.
5. **Tamper-Proof Project Ownership Lifecycle**: 14 auditable lifecycle states governing MPLADS budget sanctioning, geofenced 50m officer site inspections, contractor milestone billing, and 3-year defect liability warranty tracking.

---

## 📚 Master Enterprise Documentation (`/docs`)

All architectural designs, database models, RBAC matrices, and synthetic data generation specifications are formally organized in the `docs/` directory:

| Document Path | Specification Title & Description |
| :--- | :--- |
| **[docs/00_PROJECT_CONTEXT.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/00_PROJECT_CONTEXT.md)** | **Master Project Context & Vision**: Authoritative source of truth defining the core philosophy, 11-tier location hierarchy, 12 user roles, 21+ departments, and coding standards. |
| **[docs/01_PRODUCT_REQUIREMENTS.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/01_PRODUCT_REQUIREMENTS.md)** | **Complete Product Requirements (PRD)**: Functional specifications for all 9 stakeholder dashboards, project lifecycle milestones, 10 analytical dimensions, and offline requirements. |
| **[docs/02_ARCHITECTURE_AND_SYSTEM_DESIGN.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/02_ARCHITECTURE_AND_SYSTEM_DESIGN.md)** | **System Architecture & AI Routing Blueprint**: Complete Mermaid diagrams, Gemini 2.5 Pro routing pseudo-code, reactive Digital Twin triggers, and clean architecture layers. |
| **[docs/03_FIRESTORE_DATABASE_SCHEMA.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/03_FIRESTORE_DATABASE_SCHEMA.md)** | **Scalable NoSQL Firestore Database Schema**: Normalized JSON schemas for `/locations`, `/users`, `/departments`, `/needs`, `/projects`, `/assets`, `/digital_twins`, and `/audit_logs`. |
| **[docs/04_RBAC_AND_GOVERNANCE_MODEL.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/04_RBAC_AND_GOVERNANCE_MODEL.md)** | **RBAC & Governance Security Model**: 12-role permission matrix, officer horizontal/vertical jurisdiction rules, 50m hardware shutter locks, and production `firestore.rules`. |
| **[docs/05_DUMMY_DATA_GENERATION_SPEC.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/05_DUMMY_DATA_GENERATION_SPEC.md)** | **Realistic Gujarat Dummy Data Spec**: Seeding architecture for State: Gujarat across 5 districts, 5 PCs, 50 villages, 500 citizens, 300 needs, 75 projects, and 30 officers. |
| **[docs/06_FUTURE_INTEGRATIONS_ROADMAP.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/06_FUTURE_INTEGRATIONS_ROADMAP.md)** | **Future Integrations Roadmap**: Architectural blueprints for PM Gati Shakti, Bharat Maps GIS, municipal IoT sensors, orbital drone change detection, and AI predictive maintenance. |
| **[docs/07_MASTER_DATA_MODEL_AND_DATABASE_ARCHITECTURE.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/07_MASTER_DATA_MODEL_AND_DATABASE_ARCHITECTURE.md)** | **Master Data Model & Database Architecture**: The definitive, exhaustive NoSQL data architecture covering all 44+ platform entities, 11-stage project lifecycle, 16 AI master data models, ERDs, and zero-trust security rules. |
| **[docs/08_UI_UX_AND_PRODUCT_BLUEPRINT.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/08_UI_UX_AND_PRODUCT_BLUEPRINT.md)** | **UI/UX & Product Blueprint Architecture**: Definitive UI/UX source of truth across all 4 apps, featuring Material 3 tokens, 30+ Citizen App wireframes, MP/Admin workspaces, 20+ components, and 10-state UX rules. |
| **[docs/09_PRODUCT_REDESIGN_AND_COMPLETE_USER_FLOW.md](file:///c:/Users/patel/AndroidStudioProjects/JanSetu_Ai/docs/09_PRODUCT_REDESIGN_AND_COMPLETE_USER_FLOW.md)** | **Role-Driven Authentication Portal & Automated Routing Architecture**: Defines the unified zero-trust login portal, dynamic role detection, auto-workspace mounting, and hidden hackathon dev-mode persona switcher. |

---

## 💻 Repository Structure

```text
c:\Users\patel\AndroidStudioProjects\JanSetu_Ai\
├── docs/                      # Master Enterprise Architecture Specifications
│   ├── 00_PROJECT_CONTEXT.md
│   ├── 01_PRODUCT_REQUIREMENTS.md
│   ├── 02_ARCHITECTURE_AND_SYSTEM_DESIGN.md
│   ├── 03_FIRESTORE_DATABASE_SCHEMA.md
│   ├── 04_RBAC_AND_GOVERNANCE_MODEL.md
│   ├── 05_DUMMY_DATA_GENERATION_SPEC.md
│   ├── 06_FUTURE_INTEGRATIONS_ROADMAP.md
│   ├── 07_MASTER_DATA_MODEL_AND_DATABASE_ARCHITECTURE.md
│   ├── 08_UI_UX_AND_PRODUCT_BLUEPRINT.md
│   └── 09_PRODUCT_REDESIGN_AND_COMPLETE_USER_FLOW.md
├── docs-website/              # Next.js 15 Tailwind v4 Interactive Architecture Website
│   ├── app/                   # App Router landing pages & /docs portal
│   └── components/            # Interactive showcase widgets & Mermaid diagram rendering
├── lib/                       # Flutter Mobile Client (Clean MVVM Architecture)
├── test/                      # Unit, Widget & Architectural Integration Tests
└── 00_PROJECT_CONTEXT.md      # Root Source of Truth Mirror
```

---

## 🚀 Getting Started & Hackathon Demo Guide

### 1. Launch the Next.js Architecture Website Locally
To view the interactive system architecture, diagrams, and developer documentation hub:
```powershell
cd c:\Users\patel\AndroidStudioProjects\JanSetu_Ai\docs-website
& "C:\Program Files\nodejs\npm.cmd" run dev
```
Navigate to `http://localhost:3000` in your browser.

### 2. Flutter Enterprise Role-Driven Portal Setup
To run the unified zero-trust digital ecosystem:
```powershell
flutter pub get
flutter run
```

### 3. Hackathon Evaluation & Live Demo Switching Guide
When demonstrating JanSetu AI to judges or product evaluators:
- **Instant Authentication**: The application boots directly into the **JanSetu AI Security & Authentication Gate**. Click any of the 3 **Quick-Login Demo Cards** (Citizen Rajesh Bhai, MP Hon. C.R. Patil, or State Admin Shri K.L. Mehta) to immediately authenticate and auto-route to that persona's workspace!
- **⚡ Dev-Mode Persona Switcher**: Once inside any workspace, look for the `[ ⚡ Dev: Switch Persona ▾ ]` action pill in the top right header bar. Clicking this opens a hidden modal allowing you to instantaneously switch between Citizen, MP, and State Admin workspaces in <100ms without logging out!
- **🔄 Live Demo Reset**: Use the `[ 🔄 Reset Demo Data ]` button inside the dev switcher to restore all sample Gujarat datasets back to initial state between pitch sessions.

---

## 🛡️ License & Governance
Designed and architected for participative democratic governance across India. All specifications and code patterns follow strict enterprise compliance and transparent audit standards.
