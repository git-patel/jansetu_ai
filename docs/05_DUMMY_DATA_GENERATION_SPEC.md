# JanSetu AI — Realistic Gujarat Dummy Data Generation Specification
> **AI-Powered Government Digital Ecosystem & Constituency Development Intelligence Platform**
>
> **Version:** 2.0 (Enterprise Ecosystem Edition)
>
> **Document Type:** Data Seeding Specification & Synthetic Generation Architecture
>
> **Purpose:** This document specifies the synthetic data generation schemas, relational bindings, and seeding algorithms required to generate a high-fidelity, enterprise-scale dataset for the **State of Gujarat** across 11 administrative tiers and 12 RBAC roles.

---

## 1. Synthetic Seeding Scope & Scale

To rigorously test enterprise dashboards, AI routing accuracy, and geospatial deficit heatmaps without violating citizen privacy, the seeding engine will generate realistic synthetic data for **State: Gujarat (`STA-GUJ-0001`)** conforming exactly to the following numerical distribution:

| Entity Type | Target Count | Primary Seeding Scope & Distribution Pattern |
| :--- | :---: | :--- |
| **State / UT** | **1** | Gujarat State Root (`STA-GUJ-0001`). |
| **Districts** | **5** | Ahmedabad, Surat, Rajkot, Vadodara, and Gandhinagar. |
| **Parliamentary Constituencies (PC)** | **5** | 1 PC per District (e.g., Ahmedabad West, Surat PC, Rajkot PC, Vadodara PC, Gandhinagar PC). |
| **Villages / Municipal Wards** | **50** | 10 Wards/Villages distributed evenly across each of the 5 PCs. |
| **Verified Citizens** | **500** | 100 citizens per PC, with Gujarati surnames and dual-identity GPS coordinates. |
| **Development Needs** | **300** | 60 needs per PC distributed across all 21+ government departments. |
| **Government Assets** | **100** | 20 physical infrastructure assets per PC (Water tanks, PHCs, Schools, Sub-stations). |
| **Sanctioned Projects** | **75** | 15 active capital works per PC at various lifecycle milestone stages. |
| **Government Field Officers** | **30** | 6 executive engineers/inspectors per PC assigned to distinct departmental domains. |
| **Civil Contractors** | **20** | 4 construction firms per PC with valid GSTINs and performance ratings. |
| **Members of Parliament (MPs)** | **5** | 1 elected representative profile per Parliamentary Constituency. |

---

## 2. Administrative Hierarchy Seeding Taxonomy (Gujarat)

### 2.1 The 5 Target Districts & Parliamentary Constituencies
1. **Ahmedabad District (`DIS-GUJ-AHM-0001`)**:
   - **PC**: Ahmedabad West (`PC-GUJ-AHM-0001`) | **MP**: Hon. Kirit Solanki (`USR-MP-AHM-001`)
   - **Sample Wards/Villages**: Navrangpura (`WRD-AHM-01`), Paldi (`WRD-AHM-02`), Satellite (`WRD-AHM-03`), Sanand Village (`VIL-AHM-04`), Bavla Village (`VIL-AHM-05`).
2. **Surat District (`DIS-GUJ-SRT-0001`)**:
   - **PC**: Surat PC (`PC-GUJ-SRT-0001`) | **MP**: Hon. C. R. Patil (`USR-MP-SRT-001`)
   - **Sample Wards/Villages**: Adajan Ward 14 (`WRD-SRT-14`), Pal Ward 15 (`WRD-SRT-15`), Varachha (`WRD-SRT-16`), Bhatha Village (`VIL-SRT-17`), Kamrej Village (`VIL-SRT-18`).
3. **Rajkot District (`DIS-GUJ-RAK-0001`)**:
   - **PC**: Rajkot PC (`PC-GUJ-RAK-0001`) | **MP**: Hon. Mohan Kundariya (`USR-MP-RAK-001`)
   - **Sample Wards/Villages**: Amin Marg Ward (`WRD-RAK-01`), Kalavad Road (`WRD-RAK-02`), Gondal Town (`VIL-RAK-03`), Jasdan Village (`VIL-RAK-04`), Lodhika Village (`VIL-RAK-05`).
4. **Vadodara District (`DIS-GUJ-VAD-0001`)**:
   - **PC**: Vadodara PC (`PC-GUJ-VAD-0001`) | **MP**: Hon. Ranjanben Bhatt (`USR-MP-VAD-001`)
   - **Sample Wards/Villages**: Alkapuri (`WRD-VAD-01`), Sayajigunj (`WRD-VAD-02`), Gotri (`WRD-VAD-03`), Padra Village (`VIL-VAD-04`), Karjan Village (`VIL-VAD-05`).
5. **Gandhinagar District (`DIS-GUJ-GAN-0001`)**:
   - **PC**: Gandhinagar PC (`PC-GUJ-GAN-0001`) | **MP**: Hon. Amit Shah (`USR-MP-GAN-001`)
   - **Sample Wards/Villages**: Sector 15 Ward (`WRD-GAN-01`), Sector 21 Ward (`WRD-GAN-02`), Infocity Ward (`WRD-GAN-03`), Kalol Town (`VIL-GAN-04`), Dehgam Village (`VIL-GAN-05`).

---

## 3. Realistic Gujarati Demographic & Citizen Seeding

The seeding algorithm will generate 500 citizen documents in `/users` with authentic regional names and valid phone structures.

### 3.1 Name & Language Distribution Rule
- **Surnames**: Patel (30%), Shah (15%), Desai (10%), Mehta (8%), Joshi (7%), Jadeja (5%), Solanki (5%), Chauhan (5%), Trivedi (5%), Parmar (5%), Others (5%).
- **Language Preferences**: Gujarati (`gu` - 70%), Hindi (`hi` - 20%), English (`en` - 10%).

### 3.2 Citizen Seeding JSON Template
```json
{
  "userId": "USR-CIT-SRT-0142",
  "fullName": "Jigneshbhai Manubhai Patel",
  "phoneNumber": "+919825012345",
  "primaryRole": "CITIZEN",
  "secondaryRoles": [],
  "languagePreference": "gu",
  "citizenIdentity": {
    "verifiedHomePcId": "PC-GUJ-SRT-0001",
    "verifiedHomeWardId": "WRD-SRT-14",
    "voterIdHash": "c4ca4238a0b923820dcc509a6f75849b",
    "lastGpsReportingLocation": { "latitude": 21.1888, "longitude": 72.7933, "timestamp": 1783189200 }
  },
  "isActive": true
}
```

---

## 4. 300 Development Needs Seeding across 21 Departments

To test Gemini AI routing and deduplication clusters, the 300 needs must be generated with diverse multimodal transcripts and realistic engineering failures.

### 4.1 Sample Departmental Seed Templates
1. **Department: Water Supply (`DEPT_WATER_SUPPLY`) — Surat Adajan Ward**:
   - *Title*: "Ruptured 300mm Potable Water Main line near L.P. Savani School."
   - *Summary*: "High-pressure underground drinking water pipe has burst, causing severe street waterlogging and low water pressure in 300 surrounding apartments."
   - *Priority Score*: `94.5` (Critical) | *Estimated Cost*: `INR 2,40,000`.
2. **Department: Agriculture (`DEPT_AGRICULTURE`) — Rajkot Jasdan Village**:
   - *Title*: "Desilting and Repair of Sub-Minor Farm Irrigation Canal."
   - *Summary*: "Heavy silt accumulation and broken canal lining preventing Narmada canal irrigation water from reaching 150 acres of agricultural farmland."
   - *Priority Score*: `88.0` (High) | *Estimated Cost*: `INR 6,50,000`.
3. **Department: Digital Infrastructure (`DEPT_DIGITAL_INFRA`) — Gandhinagar Sector 21**:
   - *Title*: "Installation of High-Speed Public Wi-Fi Hotspot and OFC Maintenance."
   - *Summary*: "Public library and civic center lack reliable broadband access; underground optical fiber cable cut during recent road trenching."
   - *Priority Score*: `64.0` (Medium) | *Estimated Cost*: `INR 1,20,000`.
4. **Department: Roads & Highways (`DEPT_ROADS_HIGHWAYS`) — Ahmedabad Navrangpura**:
   - *Title*: "Severe Pothole Formation and Asphalt Degeneration on C.G. Road."
   - *Summary*: "Monsoon waterlogging has stripped top bitumen layer across a 500-meter stretch, creating deep dangerous potholes causing daily two-wheeler accidents."
   - *Priority Score*: `91.0` (Critical) | *Estimated Cost*: `INR 14,50,000`.

---

## 5. 75 Sanctioned Projects & 20 Contractors Seeding

The 75 projects must be distributed across the 14 lifecycle states to populate contractor billing and officer inspection queues.

### 5.1 Sample Contractor Profile Template
```json
{
  "userId": "USR-CON-AHM-0004",
  "fullName": "Sardar Construction & Infrastructure Pvt Ltd",
  "primaryRole": "CONTRACTOR",
  "contractorProfile": {
    "companyName": "Sardar Construction & Infrastructure Pvt Ltd",
    "gstin": "24AAACS8891H1Z2",
    "licenseGrade": "CLASS_A_PWD",
    "registeredAddress": "402, Titanium City Center, Satellite, Ahmedabad",
    "historicalPerformanceRating": 4.65,
    "activeProjectIds": ["PRJ-GUJ-AHM-0012", "PRJ-GUJ-AHM-0018"]
  }
}
```

### 5.2 Sample Sanctioned Project Milestone Seeding (`/projects`)
```json
{
  "projectId": "PRJ-GUJ-AHM-0012",
  "projectName": "Bituminous Resurfacing and Thermoplastic Paint Marking on C.G. Road",
  "departmentId": "DEPT_ROADS_HIGHWAYS",
  "location": { "wardId": "WRD-AHM-01", "pcId": "PC-GUJ-AHM-0001" },
  "ownership": {
    "sanctionedByAuthorityId": "USR-MP-AHM-001",
    "responsibleOfficerId": "USR-OFF-AHM-0002",
    "assignedContractorId": "USR-CON-AHM-0004"
  },
  "financials": { "sanctionedBudgetINR": 1450000.00, "disbursedAmountINR": 580000.00 },
  "currentStatus": "IN_PROGRESS",
  "progressPercentage": 40,
  "milestones": [
    { "milestoneIndex": 1, "title": "Milling of old asphalt & Tack Coat Application", "weightagePercent": 40, "status": "VERIFIED_AND_PAID", "paymentTrancheINR": 580000.00 },
    { "milestoneIndex": 2, "title": "40mm Bituminous Concrete Laying", "weightagePercent": 40, "status": "PENDING_INSPECTION", "paymentTrancheINR": 580000.00 },
    { "milestoneIndex": 3, "title": "Road Studs & Thermoplastic Lane Marking", "weightagePercent": 20, "status": "PENDING", "paymentTrancheINR": 290000.00 }
  ]
}
```

---

## 6. Synthetic Seeding Script Architecture (`scripts/seed_gujarat_ecosystem.ts`)

To execute this seeding deterministically, the backend administrative tooling will utilize a TypeScript Node.js seeder script that commits batch writes using the Firebase Admin SDK:

```typescript
import * as admin from 'firebase-admin';
import { gujaratDistricts, generateCitizens, generateNeeds, generateProjects } from './seed_data_banks';

admin.initializeApp();
const db = admin.firestore();

export async function seedGujaratEcosystem() {
  console.log("🚀 Starting Enterprise Seeding for State: Gujarat (STA-GUJ-0001)...");

  // 1. Seed 11-Tier Location Hierarchy (1 State -> 5 Districts -> 5 PCs -> 50 Wards)
  const locationBatch = db.batch();
  for (const ward of gujaratDistricts.flatMap(d => d.wards)) {
    const wardRef = db.collection('locations').doc(ward.locationId);
    locationBatch.set(wardRef, ward);
    
    // Seed initialized Digital Twin document
    const twinRef = db.collection('digital_twins').doc(ward.locationId);
    locationBatch.set(twinRef, ward.initialDigitalTwin);
  }
  await locationBatch.commit();
  console.log("✅ 50 Wards & Digital Twins Seeded.");

  // 2. Seed 500 Verified Citizens, 30 Officers, 20 Contractors, 5 MPs
  const users = generateCitizens(500);
  await commitInChunks('users', users, 100);
  console.log("✅ 555 Stakeholder User Profiles Seeded.");

  // 3. Seed 300 Multimodal Development Needs
  const needs = generateNeeds(300);
  await commitInChunks('needs', needs, 100);
  console.log("✅ 300 AI-Routed Development Needs Seeded.");

  // 4. Seed 100 Assets & 75 Sanctioned Projects
  const projects = generateProjects(75);
  await commitInChunks('projects', projects, 50);
  console.log("✅ 75 Capital Projects & Milestones Seeded.");

  console.log("🎉 Complete Gujarat Government Ecosystem Successfully Seeded!");
}
```
