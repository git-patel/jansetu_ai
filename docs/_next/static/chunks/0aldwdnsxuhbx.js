(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,67927,e=>{"use strict";let t=(0,e.i(56420).default)("chevron-right",[["path",{d:"m9 18 6-6-6-6",key:"mthhwq"}]]);e.s(["ChevronRight",0,t],67927)},18566,(e,t,i)=>{t.exports=e.r(76562)},76070,e=>{"use strict";let t={overview:{slug:"overview",title:"Platform Overview & Master Context",category:"Getting Started",lastUpdated:"July 2026",summary:"JanSetu AI is an AI-powered digital governance platform designed to bridge the gap between citizens and elected representatives by transforming unstructured citizen feedback into structured development intelligence.",content:[{heading:"1. The Fundamental Problem in Governance",body:"In traditional governance systems, citizen feedback is scattered across redundant paper forms, social media complaints, and isolated municipal portals. Citizens are forced to understand complex government departmental hierarchies and legal jargon just to report a broken street lamp or leaking water pipe. Because there is no automated deduplication or severity scoring, thousands of identical complaints flood the databases, while political favoritism dictates which projects get funded.",callout:{type:"important",text:"JanSetu AI is NOT a complaint management ticket system or social media feed. It is a Constituency Development Intelligence Platform and AI Decision Support System."}},{heading:"2. The JanSetu AI Core Philosophy",body:"Our guiding design law is simple: Citizens should never need to understand government departments. A citizen simply describes what they see, what they experience, and what their community needs using spoken voice, photos, or text in any Indian language. Artificial Intelligence performs all technical engineering analysis behind the scenes—categorizing the domain, estimating required material budgets, checking maintenance history, and presenting a ranked intelligence feed to the Member of Parliament."},{heading:"3. Primary Stakeholders in the Ecosystem",body:"The platform creates a transparent loop connecting five primary user roles:\n\n• Citizens: Raise development needs, upload multimodal evidence, vote on proposals, and track public execution.\n• Members of Parliament (MPs): Receive ranked AI priorities, analyze heatmap deficits, sanction projects, and publish future plans.\n• Government Officers: Conduct GPS-verified physical field inspections, upload geotechnical reports, and issue completion certificates.\n• Contractors: Execute sanctioned civil works, log milestone progress photos, and submit verifiable material invoices.\n• Super Admins: Manage platform health, monitor Gemini AI accuracy, and ingest municipal census datasets."},{heading:"4. Long-Term Vision: The Constituency Digital Twin",body:"Every village, ward, town, and constituency in India will have a living Digital Twin tracking 16 core infrastructure parameters: Population, Roads, Schools, Colleges, Hospitals, Water Tanks, Toilets, Electricity, Internet, Government Buildings, Assets, Allocated Budget, Ongoing Projects, Completed Archives, Maintenance Logs, and Citizen Satisfaction Scores. This digital representation allows AI to predict infrastructure failures before they occur."}]},"quick-start":{slug:"quick-start",title:"Developer Quick Start & Setup",category:"Getting Started",lastUpdated:"July 2026",summary:"Complete guide to setting up the local Flutter development environment, Firebase emulators, and Google Gemini API keys.",content:[{heading:"1. Prerequisites & System Requirements",body:"To build and run JanSetu AI locally, ensure your development workstation has the following SDKs installed:\n\n• Flutter SDK (v3.27.0 or higher) with Dart 3.6+\n• Node.js (LTS v24+) & npm for Firebase Cloud Functions\n• Java JDK 17 & Android Studio / Xcode for mobile compilation\n• Firebase CLI (`npm install -g firebase-tools`)",callout:{type:"tip",text:"We strongly recommend running the Firebase Local Emulator Suite during development to test offline sync and Cloud Functions without consuming cloud billing credits."}},{heading:"2. Clone & Bootstrap Flutter Project",body:"Clone the master repository and install all Flutter pub dependencies including Riverpod, Firebase Core, and Google Maps:",code:{language:"bash",caption:"Terminal - Flutter Project Setup",snippet:`git clone https://github.com/jansetu-ai/jansetu_ai.git
cd jansetu_ai
flutter pub get
flutter analyze`}},{heading:"3. Environment Configuration",body:"Create an `.env` file in the root of the Flutter project to store your Google Gemini API key and Google Maps SDK token. Never commit API keys to public version control.",code:{language:"properties",caption:".env - Local Environment Secrets",snippet:`GEMINI_API_KEY="AIzaSy...YourGeminiProToken"
GOOGLE_MAPS_API_KEY="AIzaSy...YourMapsToken"
FIREBASE_PROJECT_ID="jansetu-ai-prod"
USE_FIREBASE_EMULATOR=true`}},{heading:"4. Launching Firebase Emulators & Cloud Functions",body:"Navigate to the cloud functions directory, install Node dependencies, and start the local emulator suite:",code:{language:"bash",caption:"Terminal - Start Backend Emulators",snippet:`cd functions
npm install
npm run build
firebase emulators:start --only firestore,functions,auth,storage`}}]},architecture:{slug:"architecture",title:"Clean Architecture & Offline-First Strategy",category:"Core Architecture",lastUpdated:"July 2026",summary:"Technical deep-dive into our MVVM layered Flutter architecture, Riverpod reactive state management, and robust offline sync engine.",content:[{heading:"1. Principles of Clean Architecture",body:"JanSetu AI strictly enforces separation of concerns across three independent layers. The presentation layer never communicates directly with external APIs or Firebase databases. All data mutations pass through domain interfaces and repository implementations.",mermaid:`
graph LR
    subgraph Presentation ["Presentation Layer"]
        UI["Flutter UI Screens / Widgets"]
        VM["Riverpod State Notifiers / ViewModels"]
    end

    subgraph Domain ["Domain Layer (Pure Dart)"]
        UC["Use Cases / Interactors"]
        ENT["Domain Entities"]
        REP_INT["Repository Interfaces"]
    end

    subgraph Data ["Data Layer"]
        REP_IMP["Repository Implementations"]
        LOCAL["Local SQLite / Hive Cache"]
        REMOTE["Firebase / Gemini Cloud Data Sources"]
    end

    UI --> VM
    VM --> UC
    UC --> REP_INT
    REP_IMP -.->|Implements| REP_INT
    REP_IMP --> LOCAL
    REP_IMP --> REMOTE
        `},{heading:"2. Riverpod State Management Implementation",body:"We utilize `@riverpod` code generation to ensure compile-safe dependency injection and reactive UI updates. Below is the standard pattern for a development need feed ViewModel:",code:{language:"typescript",caption:"lib/features/feed/presentation/providers/feed_provider.dart",snippet:`@riverpod
class DevelopmentFeedNotifier extends _$DevelopmentFeedNotifier {
  @override
  FutureOr<List<DevelopmentNeed>> build(String constituencyId) async {
    // 1. Return cached local data immediately for offline-first responsiveness
    final localData = await ref.read(feedRepositoryProvider).getCachedNeeds(constituencyId);
    
    // 2. Trigger background cloud sync if online
    _syncWithCloud(constituencyId);
    
    return localData;
  }

  Future<void> _syncWithCloud(String constituencyId) async {
    try {
      final remoteData = await ref.read(feedRepositoryProvider).fetchRemoteNeeds(constituencyId);
      state = AsyncValue.data(remoteData);
    } catch (e) {
      // Retain local offline state if network fails
      print("Offline mode active: Retaining SQLite cache.");
    }
  }
}`}},{heading:"3. Offline-First Sync & Conflict Resolution",body:"In rural agricultural constituencies, cellular connectivity is frequently intermittent. Our offline-first synchronization engine guarantees zero data loss:\n\n• Local Write Queue: When a citizen submits a voice report offline, the audio blob and metadata are serialized into local SQLite tables marked with `sync_status = pending`.\n• Connectivity Listener: Background WorkManager tasks monitor network availability.\n• Exponential Backoff: When internet restores, queued payloads upload sequentially. If an upload fails due to packet loss, it retries with exponential backoff.\n• Server Timestamp Authoritative: To prevent timestamp manipulation, Firestore server-side timestamps override local client clocks upon ingestion."}]},"data-models":{slug:"data-models",title:"JSON Data Models & Firestore Schemas",category:"Core Architecture",lastUpdated:"July 2026",summary:"Complete reference for the NoSQL document collections powering Citizen Needs, MP Sanctions, and Constituency Digital Twins.",content:[{heading:"1. Development Need Document Schema (`/needs/{needId}`)",body:"Every citizen submission is stored as an enriched document in Cloud Firestore containing raw evidence, AI classification outputs, and real-time project status.",code:{language:"json",caption:"Firestore Document - /needs/need_8921a",snippet:`{
  "id": "need_8921a",
  "constituencyId": "const_up_varanasi_63",
  "creator": {
    "citizenId": "usr_99201",
    "verifiedHomeConstituency": "const_up_varanasi_63",
    "isLocalConstituent": true
  },
  "rawInput": {
    "inputType": "VOICE_AND_PHOTO",
    "originalLanguage": "hi-IN",
    "transcript": "वार्ड 14 में प्राथमिक विद्यालय के सामने पानी की पाइपलाइन फट गई है जिससे रास्ता बंद है।",
    "translatedText": "The water pipeline has burst in front of the primary school in Ward 14, blocking the road.",
    "mediaUrls": [
      "gs://jansetu-prod.appspot.com/evidence/2026/07/img_01.jpg",
      "gs://jansetu-prod.appspot.com/evidence/2026/07/audio_01.aac"
    ]
  },
  "aiAnalysis": {
    "generatedTitle": "Emergency Water Pipeline Repair Near Ward 14 Primary School",
    "executiveSummary": "Burst municipal potable water main flooding school access road in Ward 14. High safety and hygiene hazard for 450+ students.",
    "domain": "WATER_SUPPLY",
    "subcategory": "PIPELINE_LEAKAGE",
    "priorityScore": 92.5,
    "priorityLevel": "CRITICAL",
    "estimatedBudgetINR": 350000,
    "expectedBeneficiaries": 1400,
    "duplicateClusterId": "cluster_varanasi_water_09",
    "confidenceScore": 0.984
  },
  "location": {
    "latitude": 25.3176,
    "longitude": 83.0062,
    "wardNumber": "14",
    "address": "Near Government Primary School, Lahurabir, Varanasi"
  },
  "communityStats": {
    "supportCount": 184,
    "commentCount": 32,
    "uniqueHouseholdSupporters": 142
  },
  "status": "APPROVED_FOR_TENDER",
  "projectLifecycle": {
    "submittedAt": "2026-07-03T10:15:00Z",
    "aiProcessedAt": "2026-07-03T10:15:12Z",
    "officerVerifiedAt": "2026-07-04T14:20:00Z",
    "mpApprovedAt": "2026-07-05T09:30:00Z",
    "tenderAwardedAt": null,
    "completedAt": null
  }
}`}},{heading:"2. Citizen User Schema (`/users/{userId}`)",body:"Reflects the Citizen Dual-Identity Model, separating permanent voter constituency verification from dynamic GPS physical coordinates.",code:{language:"json",caption:"Firestore Document - /users/usr_99201",snippet:`{
  "uid": "usr_99201",
  "phoneNumber": "+919876543210",
  "fullName": "Rajesh Kumar Patel",
  "preferredLanguage": "hi-IN",
  "identities": {
    "homeConstituency": {
      "id": "const_up_varanasi_63",
      "name": "Varanasi Parliamentary Constituency",
      "state": "Uttar Pradesh",
      "isVerifiedByVoterId": true,
      "verifiedAt": "2026-01-15T08:00:00Z"
    },
    "currentGpsLocation": {
      "lastLatitude": 25.3176,
      "lastLongitude": 83.0062,
      "lastUpdated": "2026-07-03T10:14:55Z"
    }
  },
  "roles": ["CITIZEN"],
  "reputationScore": 85,
  "createdAt": "2026-01-15T08:00:00Z"
}`}}]},"ai-engine":{slug:"ai-engine",title:"Google Gemini AI Pipeline & Priority Engine",category:"Artificial Intelligence",lastUpdated:"July 2026",summary:"Architectural specification of the 9-stage multimodal processing pipeline, zero-shot classification prompts, and severity scoring algorithm.",content:[{heading:"1. Multimodal Audio & Vision Ingestion",body:"When a citizen uploads voice audio in dialects such as Bhojpuri, Marathi, or Tamil, Firebase Cloud Functions stream the binary payload directly to Google Gemini 2.5 Pro. Unlike legacy pipelines that chain separate Speech-to-Text (Whisper) and Translation models, Gemini performs direct audio-to-structured-JSON reasoning, preserving acoustic emphasis and urgency.",callout:{type:"tip",text:"By passing audio blobs directly into Gemini's multimodal context window, our pipeline reduces transcription error rates by 34% in noisy outdoor traffic environments."}},{heading:"2. Zero-Shot Classification & System Prompting",body:"Below is the production system prompt used inside Cloud Functions to govern AI classification behavior and enforce objective government output format:",code:{language:"javascript",caption:"functions/src/ai/prompts/governanceSystemPrompt.ts",snippet:`export const GOVERNANCE_SYSTEM_PROMPT = \`
You are an experienced Principal Development Planning Officer and Chief Executive Engineer for Indian Parliamentary Governance.
Your objective is to analyze raw, unstructured citizen multimodal feedback and convert it into formal engineering intelligence.

RULES:
1. NEVER invent facts or hallucinate damage not visible in photos or mentioned in audio transcripts.
2. Translate all regional dialect input into formal English for official government archiving while preserving regional entity names.
3. Classify the request into exactly ONE of these domains: ROADS, BRIDGES, WATER_SUPPLY, DRAINAGE, STREET_LIGHTING, EDUCATION, HEALTHCARE, AGRICULTURE, EMPLOYMENT, WOMEN_SAFETY, DIGITAL_INFRA, ENVIRONMENT.
4. Calculate an objective Priority Score between 0.0 and 100.0 based on safety hazards, population impact, and infrastructure severity.
5. Provide your output strictly as valid JSON matching the JanSetuAiResponse schema.
\`;`}},{heading:"3. Mathematical Formulation of the Priority Engine",body:"To eliminate political bias, the AI Priority Engine calculates severity $S$ using a weighted multi-variable scoring function:\n\n$$Score = w_1(H_{cat}) + w_2(D_{pop}) + w_3(A_{gap}) + w_4(C_{supp})$$\n\nWhere:\n• $H_{cat}$: Hazard Category Weight (e.g., open electrical wire or contaminated water = 40 pts; cosmetic paint wear = 5 pts).\n• $D_{pop}$: Ward Population Density impact factor derived from census tables (max 25 pts).\n• $A_{gap}$: Asset Deficit Score from the Digital Twin maintenance logs (max 20 pts).\n• $C_{supp}$: Verified Community Support Density within a 1km radius (max 15 pts).\n\nRequests scoring above 85.0 are flagged as **CRITICAL** and generate instant SMS alerts to the constituency MP."}]},"citizen-app":{slug:"citizen-app",title:"Citizen App & Dual-Identity GPS Model",category:"Product Modules",lastUpdated:"July 2026",summary:"Detailed breakdown of the citizen user journey, multimodal reporting interface, and GPS geofencing rules.",content:[{heading:"1. The Citizen Dual-Identity Architecture",body:"A core innovation of JanSetu AI is solving the migrant worker and traveler reporting dilemma through the Dual-Identity Model:\n\n1. Verified Home Constituency: Established during onboarding via Voter ID or Aadhaar demographic check. Citizens can only vote on MP proposals, participate in development surveys, and endorse major budget spending within their verified home constituency.\n2. Current Physical GPS Location: Real-time coordinate tracking. Citizens can report infrastructure emergencies (such as highway potholes, bridge cracks, or station sanitation issues) anywhere they are physically present in India.",callout:{type:"important",text:"If a citizen reports an issue outside their verified home constituency, the report is routed instantly to the local MP of that physical GPS coordinate, but the reporter cannot vote on that MP's policy polls."}},{heading:"2. 60-Second Grievance Submission Flow",body:"To achieve our core success criterion of '< 60 seconds submission time', the UI eliminates all manual typing requirements:\n\n• Step 1: Citizen taps the prominent blue 'Speak Need' floating action button.\n• Step 2: Citizen speaks naturally for 10–30 seconds and snaps a photo of the damaged infrastructure.\n• Step 3: App displays the 'AI Confirmation Screen' showing the auto-generated engineering title, detected category, and estimated severity.\n• Step 4: Citizen taps 'Confirm & Submit'. GPS geochash coordinates are automatically appended."}]},"mp-dashboard":{slug:"mp-dashboard",title:"MP Decision Support Dashboard",category:"Product Modules",lastUpdated:"July 2026",summary:"Architectural capabilities of the parliamentary web dashboard, GIS heatmap rendering, and one-click sanctioning.",content:[{heading:"1. Constituency Overview & GIS Heatmaps",body:"The MP Dashboard renders a high-definition interactive Google Maps interface overlaid with real-time infrastructure deficit heatmaps. Red zones indicate high clusters of unresolved critical citizen needs, allowing elected representatives to identify neglected municipal wards instantly before attending district development council meetings."},{heading:"2. One-Click Sanctioning & Verification Dispatch",body:"When reviewing an AI-recommended development project, the MP has three explicit executive actions:\n\n• Sanction & Approve: Allocates proposed funds from the MPLADS (MP Local Area Development Scheme) or municipal budget, immediately changing project status to `TENDER_READY`.\n• Dispatch Field Verification: Assigns an on-site physical inspection order to a specific municipal junior engineer, setting a mandatory 48-hour SLA.\n• Reject with Explanation: Rejects the request. To maintain total transparency, the MP must select a reason (e.g., 'Already covered under State NHAI pipeline', 'Budget exceeded for current fiscal year'), which is published directly to the Citizen App."}]},"officer-portal":{slug:"officer-portal",title:"Government Officer & Contractor Portals",category:"Product Modules",lastUpdated:"July 2026",summary:"Specifications for GPS geofenced physical inspections, milestone billing, and contractor auditing.",content:[{heading:"1. GPS Geofenced Field Inspection Rules",body:"To eliminate remote armchair sign-offs and fraudulent inspection certificates, the Government Officer Portal enforces strict spatial geofencing:\n\n• The field officer must physically travel within 50 meters of the reported issue's GPS coordinate.\n• The app uses OS-level geofence verification before enabling the 'Upload Inspection Report' camera shutter button.\n• All inspection photos contain tamper-proof EXIF metadata including cryptographic SHA-256 hashes, GPS timestamps, and device IMEI signatures."},{heading:"2. Contractor Milestone Billing Workflow",body:"Once a contract is awarded, contractors manage execution through structured milestone check-ins:\n\n1. Site Excavation / Foundation: Contractor uploads live site photos. 20% mobilization advance released.\n2. Structural Completion: Contractor logs exact material specifications (e.g., cement grade, steel tonnage). Officer conducts physical inspection.\n3. Final Completion Certificate: AI computer vision compares before-and-after photos to verify work completion before final bill release."}]},security:{slug:"security",title:"Security Rules, RBAC & Privacy",category:"Security & Governance",lastUpdated:"July 2026",summary:"Enterprise security architecture covering Firebase Auth, Role-Based Access Control, and Firestore Security Rules.",content:[{heading:"1. Authentication & Role-Based Access Control (RBAC)",body:"All user sessions are authenticated via Firebase Phone OTP verification, preventing automated bot spam. Upon verification, custom JWT claims assign strict role permissions: `CITIZEN`, `MP`, `OFFICER`, `CONTRACTOR`, or `SUPER_ADMIN`."},{heading:"2. Production Firestore Security Rules",body:"Our database security rules prevent unauthorized data tampering while ensuring public transparency for approved development projects:",code:{language:"javascript",caption:"firestore.rules - Production Database Rules",snippet:`rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper Functions
    function isAuthenticated() {
      return request.auth != null;
    }
    function hasRole(role) {
      return isAuthenticated() && request.auth.token.role == role;
    }
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Citizen Needs Collection Rules
    match /needs/{needId} {
      // Anyone can read public development needs for transparency
      allow read: if true;
      
      // Only authenticated citizens can submit new needs
      allow create: if isAuthenticated() && 
                    request.resource.data.creator.citizenId == request.auth.uid &&
                    request.resource.data.status == 'SUBMITTED';
                    
      // Citizens can only update their own draft needs; MPs and Officers can update status
      allow update: if (isOwner(resource.data.creator.citizenId) && resource.data.status == 'SUBMITTED') ||
                    hasRole('MP') || hasRole('OFFICER') || hasRole('SUPER_ADMIN');
                    
      allow delete: if hasRole('SUPER_ADMIN');
    }

    // User Profiles Collection Rules
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId) || hasRole('SUPER_ADMIN');
    }
  }
}`}}]}};e.s(["DOCS_ARTICLES",0,t,"DOCS_NAVIGATION",0,[{title:"Getting Started",items:[{title:"Platform Overview",slug:"overview",summary:"Master vision, core philosophy, and primary objectives of JanSetu AI."},{title:"Quick Start & Setup",slug:"quick-start",summary:"Step-by-step developer setup for Flutter client and Firebase backend."}]},{title:"Core Architecture",items:[{title:"Clean Architecture & MVVM",slug:"architecture",summary:"Riverpod state management, Repository pattern, and offline-first strategy."},{title:"Data Models & Schemas",slug:"data-models",summary:"JSON document structures for Citizen Needs, Profiles, and Digital Twins."}]},{title:"Artificial Intelligence",items:[{title:"Gemini AI Pipeline & NLP",slug:"ai-engine",summary:"Multimodal audio/image processing, deduplication, and severity scoring engine."}]},{title:"Product Modules",items:[{title:"Citizen App & Identity Model",slug:"citizen-app",summary:"Dual-identity GPS rules: Home Constituency vs Physical GPS location."},{title:"MP Decision Dashboard",slug:"mp-dashboard",summary:"AI priority rankings, heatmaps, and project sanctioning workflows."},{title:"Officer & Contractor Portals",slug:"officer-portal",summary:"GPS geofenced site inspections and milestone billing verification."}]},{title:"Security & Governance",items:[{title:"Security Rules & Privacy",slug:"security",summary:"OTP authentication, Role-Based Access Control, and Firestore Security Rules."}]}]])},93649,e=>{"use strict";var t=e.i(43476),i=e.i(71645),n=e.i(22016),a=e.i(18566),r=e.i(76070);let o=(0,e.i(56420).default)("chevron-down",[["path",{d:"m6 9 6 6 6-6",key:"qrunsl"}]]);var s=e.i(67927),c=e.i(56423),l=e.i(66595),d=e.i(28623);e.s(["DocsSidebar",0,function(){let e=(0,a.usePathname)(),[u,p]=(0,i.useState)(""),[m,h]=(0,i.useState)({"Getting Started":!0,"Core Architecture":!0,"Artificial Intelligence":!0,"Product Modules":!0,"Security & Governance":!0}),g=r.DOCS_NAVIGATION.map(e=>({...e,items:e.items.filter(e=>e.title.toLowerCase().includes(u.toLowerCase())||e.summary.toLowerCase().includes(u.toLowerCase()))})).filter(e=>e.items.length>0);return(0,t.jsxs)("aside",{className:"w-full lg:w-72 shrink-0 border-r border-border bg-background/80 backdrop-blur-xl lg:sticky lg:top-20 lg:h-[calc(100vh-5rem)] overflow-y-auto p-6 custom-scrollbar",children:[(0,t.jsxs)("div",{className:"mb-6 space-y-4",children:[(0,t.jsxs)(n.default,{href:"/docs",className:"flex items-center gap-2 font-black text-lg text-foreground group",children:[(0,t.jsx)("div",{className:"p-2 rounded-xl bg-primary/10 text-primary group-hover:scale-105 transition-transform",children:(0,t.jsx)(c.BookOpen,{className:"w-5 h-5"})}),(0,t.jsx)("span",{children:"Documentation Hub"})]}),(0,t.jsxs)("div",{className:"relative",children:[(0,t.jsx)(l.Search,{className:"w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"}),(0,t.jsx)("input",{type:"text",placeholder:"Filter documentation...",value:u,onChange:e=>p(e.target.value),className:"w-full pl-9 pr-4 py-2 rounded-xl bg-muted/60 border border-border/60 text-xs text-foreground placeholder:text-muted-foreground focus:outline-none focus:border-primary transition-colors"})]})]}),(0,t.jsxs)("div",{className:"space-y-6",children:[g.map(i=>{let a=m[i.title];return(0,t.jsxs)("div",{className:"space-y-2",children:[(0,t.jsxs)("button",{onClick:()=>{var e;return e=i.title,void h(t=>({...t,[e]:!t[e]}))},className:"w-full flex items-center justify-between text-xs font-bold uppercase tracking-wider text-muted-foreground hover:text-foreground transition-colors py-1",children:[(0,t.jsx)("span",{children:i.title}),a?(0,t.jsx)(o,{className:"w-4 h-4 opacity-60"}):(0,t.jsx)(s.ChevronRight,{className:"w-4 h-4 opacity-60"})]}),a&&(0,t.jsx)("ul",{className:"space-y-1 pl-2 border-l border-border/80",children:i.items.map(i=>{let a=`/docs/${i.slug}`,r=e===a||"/docs"===e&&"overview"===i.slug;return(0,t.jsx)("li",{children:(0,t.jsx)(n.default,{href:a,className:`block px-3 py-2 rounded-xl text-xs sm:text-sm font-medium transition-all ${r?"bg-primary/10 text-primary font-bold shadow-xs translate-x-1":"text-muted-foreground hover:text-foreground hover:bg-muted/50 hover:translate-x-0.5"}`,children:i.title})},i.slug)})})]},i.title)}),0===g.length&&(0,t.jsxs)("div",{className:"py-8 text-center text-xs text-muted-foreground space-y-2",children:[(0,t.jsx)(d.Sparkles,{className:"w-6 h-6 mx-auto text-primary opacity-50 animate-pulse"}),(0,t.jsxs)("p",{children:['No matching docs found for "',u,'".']})]})]}),(0,t.jsxs)("div",{className:"mt-12 pt-6 border-t border-border/60 text-[11px] text-muted-foreground",children:[(0,t.jsx)("p",{className:"font-semibold text-foreground",children:"Need Technical Help?"}),(0,t.jsx)("p",{className:"mt-1",children:"Review the JanSetu AI repository guidelines or contact the architecture steering committee."})]})]})}],93649)}]);