# JanSetu AI — Scalable NoSQL Firestore Database Schema
> **AI-Powered Government Digital Ecosystem & Constituency Development Intelligence Platform**
>
> **Version:** 2.0 (Enterprise Ecosystem Edition)
>
> **Document Type:** Database Architecture & NoSQL Schema Specification
>
> **Purpose:** This document defines the normalized JSON document schemas, indexing strategies, and relational modeling principles for Cloud Firestore to support hundreds of millions of citizens across India without data duplication or read contention.

---

## 1. Enterprise NoSQL Scalability & Modeling Principles

To scale JanSetu AI nationwide across all 543 Parliamentary Constituencies, the database architecture follows rigid NoSQL engineering rules:
1. **No Deep Nested Subcollections for Analytics**: Root collections (`/locations`, `/users`, `/needs`, `/projects`, `/digital_twins`) are maintained at the top level to enable cross-constituency horizontal queries without unbounded collection group scans.
2. **Denormalized Spatial Lineage (Ancestor Arrays)**: Instead of performing recursive SQL-style relational joins across the 11-tier location hierarchy, every document stores an immutable `ancestries` array containing the IDs of all parent administrative tiers. This allows single-query filtering at any level (National, State, District, PC, Ward).
3. **Optimized Deduplication Indexing**: All geospatial entities store standardized **Geohashes** (precision 4 through 9) to enable bounding box spatial queries within a 500-meter radius without scanning the entire database.
4. **Separation of High-Frequency Writes**: Live metrics are decoupled from immutable historical ledgers. Instantaneous counters are updated in `/digital_twins`, while immutable compliance events append to `/audit_logs`.

---

## 2. Master Collection Schemas

### 2.1 `/locations/{locationId}` (11-Tier Spatial Hierarchy)
Stores every administrative node from India (Tier 1) down to Street/Locality (Tier 11).

```json
{
  "locationId": "WRD-GUJ-SRT-0014",
  "name": "Ward 14 - Adajan / Pal",
  "tier": 10,
  "tierName": "WARD",
  "parentId": "CIT-GUJ-SRT-0001",
  "ancestries": [
    "IND-ROOT",
    "STA-GUJ-0001",
    "DIS-GUJ-SRT-0001",
    "PC-GUJ-SRT-0001",
    "AC-GUJ-SRT-0003",
    "MC-GUJ-SRT-0001",
    "CIT-GUJ-SRT-0001"
  ],
  "geospatial": {
    "center": { "latitude": 21.1888, "longitude": 72.7933 },
    "geohash": "tsje9q2m",
    "boundingBoxGeoJson": {
      "type": "Polygon",
      "coordinates": [[[72.7800, 21.1800], [72.8050, 21.1800], [72.8050, 21.1980], [72.7800, 21.1980], [72.7800, 21.1800]]]
    }
  },
  "administrativeMetadata": {
    "mpUserId": "USR-MP-SRT-0001",
    "mlaUserId": "USR-MLA-SRT-0003",
    "municipalCommissionerId": "USR-OFF-SRT-8891",
    "totalPopulation": 142500,
    "areaSqKm": 12.4
  },
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-07-03T18:30:00.000Z"
}
```

---

### 2.2 `/users/{userId}` (Dual-Identity & RBAC Profile Registry)
Stores all 12 user roles, enforcing separation between voting residency and reporting GPS coordinates.

```json
{
  "userId": "USR-OFF-SRT-4402",
  "aadhaarHash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  "phoneNumber": "+919876543210",
  "fullName": "Rajeshwar Patel",
  "primaryRole": "GOVERNMENT_OFFICER",
  "secondaryRoles": ["CITIZEN"],
  "languagePreference": "gu",
  "citizenIdentity": {
    "verifiedHomePcId": "PC-GUJ-SRT-0001",
    "verifiedHomeWardId": "WRD-GUJ-SRT-0014",
    "voterIdHash": "8f14e45fceea167a5a36dedd4bea2543",
    "lastGpsReportingLocation": { "latitude": 21.1702, "longitude": 72.8311, "timestamp": 1783189200 }
  },
  "officerProfile": {
    "employeeId": "EMP-SMC-2019-882",
    "designation": "Executive Engineer (Hydraulics & Water Supply)",
    "departmentId": "DEPT_WATER_SUPPLY",
    "jurisdictionTier": 10,
    "jurisdictionLocationId": "WRD-GUJ-SRT-0014",
    "allowedActions": ["VERIFY_NEED", "INSPECT_MILESTONE", "ISSUE_COMPLETION_CERTIFICATE"]
  },
  "contractorProfile": null,
  "isActive": true,
  "createdAt": "2025-11-15T10:00:00.000Z"
}
```

---

### 2.3 `/departments/{departmentId}` (Government Department Taxonomy)
Defines the 21+ official departments, SLA timelines, and budget heads.

```json
{
  "departmentId": "DEPT_WATER_SUPPLY",
  "officialName": "Department of Water Supply & Municipal Hydraulics",
  "shortCode": "WATSUP",
  "description": "Responsible for potable water distribution grids, overhead tanks, pipeline leakages, and water quality testing.",
  "slaConfiguration": {
    "maxVerificationHours": 48,
    "maxTenderFloatDays": 15,
    "defaultWarrantyMonths": 36
  },
  "activeBudgetCodes": [
    "MPLADS_WATER_2026",
    "AMRUT_2.0_GUJ",
    "SMC_GENERAL_HYD_2026"
  ],
  "subcategories": [
    "Burst Pipeline Leakage",
    "Overhead Storage Tank Construction",
    "Contaminated Drinking Water",
    "Tube-well & Pump Motor Failure",
    "Low Hydraulic Water Pressure"
  ]
}
```

---

### 2.4 `/needs/{needId}` (Multimodal Citizen Development Requests)
Stores raw citizen submissions and the automated AI routing intelligence generated by Gemini 2.5 Pro.

```json
{
  "needId": "NED-GUJ-SRT-2026-0941",
  "creatorUserId": "USR-CIT-SRT-1102",
  "aiIntelligence": {
    "title": "Severe Potable Water Pipeline Burst and Contamination in Adajan Ward",
    "summary": "High-pressure municipal potable water main ruptured near Star Galaxy apartments, causing street flooding and sewage cross-contamination affecting 450 residential households.",
    "departmentId": "DEPT_WATER_SUPPLY",
    "subcategory": "Burst Pipeline Leakage",
    "priorityScore": 92.5,
    "severityClass": "CRITICAL",
    "estimatedBeneficiaries": 2250,
    "estimatedBudgetINR": 185000,
    "geminiConfidence": 0.994,
    "translatedFromLanguage": "gu"
  },
  "location": {
    "latitude": 21.1889,
    "longitude": 72.7935,
    "geohash": "tsje9q2t",
    "localityName": "Star Galaxy Street Cluster, Adajan",
    "wardId": "WRD-GUJ-SRT-0014",
    "pcId": "PC-GUJ-SRT-0001",
    "districtId": "DIS-GUJ-SRT-0001",
    "stateId": "STA-GUJ-0001",
    "ancestries": ["IND-ROOT", "STA-GUJ-0001", "DIS-GUJ-SRT-0001", "PC-GUJ-SRT-0001", "AC-GUJ-SRT-0003", "MC-GUJ-SRT-0001", "CIT-GUJ-SRT-0001", "WRD-GUJ-SRT-0014"]
  },
  "mediaEvidence": [
    { "type": "AUDIO_VOICE", "uri": "gs://jansetu-evidence/voice/2026-07/ned-0941-voice.mp3", "durationSec": 18 },
    { "type": "PHOTO", "uri": "gs://jansetu-evidence/photos/2026-07/ned-0941-img1.jpg", "exifGps": { "lat": 21.1889, "lng": 72.7935 } }
  ],
  "routing": {
    "assignedOfficerId": "USR-OFF-SRT-4402",
    "assignedMpId": "USR-MP-SRT-0001",
    "deduplicationClusterId": "CLUS-WATER-SRT-8821"
  },
  "communityEngagement": {
    "upvoteCount": 142,
    "commentCount": 18,
    "corroboratingWitnessIds": ["USR-CIT-SRT-1109", "USR-CIT-SRT-3321"]
  },
  "status": "OFFICER_VERIFIED",
  "verificationDetails": {
    "verifiedByOfficerId": "USR-OFF-SRT-4402",
    "verifiedAt": "2026-07-03T14:20:00.000Z",
    "officerGeofenceVerified": true,
    "geotechnicalNotes": "Verified 200mm DI pipe rupture under main asphalt road. Excavation and sleeve replacement required urgently."
  },
  "linkedProjectId": "PRJ-GUJ-SRT-2026-0112",
  "createdAt": "2026-07-03T11:05:00.000Z",
  "updatedAt": "2026-07-03T16:00:00.000Z"
}
```

---

### 2.5 `/projects/{projectId}` (Sanctioned Capital Works & Milestones)
Stores institutional public works projects, contractor billing, and warranty tracking.

```json
{
  "projectId": "PRJ-GUJ-SRT-2026-0112",
  "projectName": "Emergency RCC Sleeve Replacement and Asphalt Restoration for 200mm DI Water Main",
  "linkedNeedIds": ["NED-GUJ-SRT-2026-0941", "NED-GUJ-SRT-2026-0944"],
  "departmentId": "DEPT_WATER_SUPPLY",
  "ownership": {
    "sanctionedByAuthorityId": "USR-MP-SRT-0001",
    "sanctioningRole": "MEMBER_OF_PARLIAMENT",
    "responsibleOfficerId": "USR-OFF-SRT-4402",
    "assignedContractorId": "USR-CON-SRT-9901",
    "contractorCompanyName": "Gujarat Infra & Hydraulics Pvt Ltd",
    "contractorGstin": "24AAACG1234F1Z8"
  },
  "financials": {
    "fundingSource": "MPLADS_2026_27",
    "sanctionedBudgetINR": 225000.00,
    "disbursedAmountINR": 90000.00,
    "bankEscrowAccountHash": "4491029981230091"
  },
  "timeline": {
    "sanctionedDate": "2026-07-03T17:00:00.000Z",
    "tenderAwardedDate": "2026-07-05T10:00:00.000Z",
    "contractualStartDate": "2026-07-06T08:00:00.000Z",
    "estimatedCompletionDate": "2026-07-12T18:00:00.000Z",
    "actualCompletionDate": null,
    "defectLiabilityExpiryDate": "2029-07-12T18:00:00.000Z"
  },
  "currentStatus": "IN_PROGRESS",
  "progressPercentage": 40,
  "milestones": [
    {
      "milestoneIndex": 1,
      "title": "Road Excavation & Debris Clearance",
      "weightagePercent": 40,
      "status": "VERIFIED_AND_PAID",
      "contractorSubmittedAt": "2026-07-07T14:00:00.000Z",
      "evidencePhotos": ["gs://jansetu-evidence/projects/prj-0112/m1-excavation.jpg"],
      "officerVerifiedBy": "USR-OFF-SRT-4402",
      "officerVerifiedAt": "2026-07-07T16:30:00.000Z",
      "paymentTrancheINR": 90000.00
    },
    {
      "milestoneIndex": 2,
      "title": "200mm DI Pipe Joint Sleeve Welding & Hydro-Test",
      "weightagePercent": 40,
      "status": "IN_PROGRESS",
      "contractorSubmittedAt": null,
      "evidencePhotos": [],
      "officerVerifiedBy": null,
      "officerVerifiedAt": null,
      "paymentTrancheINR": 90000.00
    },
    {
      "milestoneIndex": 3,
      "title": "Backfilling & M30 Grade Concrete Resurfacing",
      "weightagePercent": 20,
      "status": "PENDING",
      "contractorSubmittedAt": null,
      "evidencePhotos": [],
      "officerVerifiedBy": null,
      "officerVerifiedAt": null,
      "paymentTrancheINR": 45000.00
    }
  ],
  "location": {
    "wardId": "WRD-GUJ-SRT-0014",
    "pcId": "PC-GUJ-SRT-0001",
    "gpsBoundaryGeoJson": {
      "type": "Polygon",
      "coordinates": [[[72.7930, 21.1885], [72.7940, 21.1885], [72.7940, 21.1895], [72.7930, 21.1895], [72.7930, 21.1885]]]
    }
  },
  "qualityAssurance": {
    "citizenSatisfactionScore": null,
    "completionCertificateUri": null,
    "inspectionReportUris": ["gs://jansetu-evidence/reports/prj-0112-initial-insp.pdf"]
  },
  "createdAt": "2026-07-03T17:00:00.000Z",
  "updatedAt": "2026-07-07T16:30:00.000Z"
}
```

---

### 2.6 `/assets/{assetId}` (Public Infrastructure Asset Registry)
Stores permanent government infrastructure assets and their maintenance logs.

```json
{
  "assetId": "AST-WATSUP-SRT-0042",
  "assetName": "Adajan Ward 14 Primary Overhead RCC Storage Tank",
  "departmentId": "DEPT_WATER_SUPPLY",
  "category": "Overhead Storage Tank",
  "specifications": {
    "capacityKL": 500,
    "constructionMaterial": "Reinforced Cement Concrete (RCC)",
    "yearCommissioned": 2018,
    "designLifeYears": 40
  },
  "location": {
    "wardId": "WRD-GUJ-SRT-0014",
    "pcId": "PC-GUJ-SRT-0001",
    "latitude": 21.1892,
    "longitude": 72.7941,
    "geohash": "tsje9q3b"
  },
  "structuralHealthRating": 88,
  "maintenanceHistory": [
    { "date": "2024-02-10", "type": "Internal Chlorination & Epoxy Waterproofing", "costINR": 120000, "contractorId": "USR-CON-SRT-7702" }
  ],
  "responsibleOfficerId": "USR-OFF-SRT-4402",
  "isOperational": true,
  "lastInspectedAt": "2026-05-15T10:00:00.000Z"
}
```

---

### 2.7 `/digital_twins/{twinId}` (18+ Parameter Living Metrics)
Stores aggregated, real-time civic intelligence per administrative tier.

```json
{
  "twinId": "WRD-GUJ-SRT-0014",
  "locationId": "WRD-GUJ-SRT-0014",
  "tier": 10,
  "demographics": { "population": 142500, "households": 31000, "literacyRate": 92.4 },
  "infrastructureMetrics": {
    "totalRoadLengthKm": 84.5,
    "potholeDensityPerKm": 1.2,
    "primarySchoolsCount": 18,
    "phcAndHospitalsCount": 4,
    "anganwadiCentersCount": 12,
    "waterStorageCapacityKL": 4500,
    "dailyWaterSupplyHours": 3.5,
    "drainageCoveragePercent": 94.0,
    "electricityReliabilityPercent": 99.2,
    "ofcFiberCoveragePercent": 88.5
  },
  "governanceAndFinance": {
    "allocatedWardBudgetINR": 25000000.00,
    "expendedWardBudgetINR": 18500000.00,
    "openNeedsCount": 24,
    "ongoingProjectsCount": 6,
    "completedProjectsCount10Yr": 142,
    "averageVerificationTimeHours": 18.4
  },
  "algorithmicScores": {
    "aiDevelopmentScore": 84.2,
    "citizenSatisfactionScore": 4.38,
    "infrastructureScore": 86.5,
    "environmentalGreenScore": 79.0
  },
  "lastCalculatedAt": "2026-07-03T18:00:00.000Z"
}
```

---

### 2.8 `/audit_logs/{logId}` (Immutable Governance Audit Trail)
Stores tamper-proof cryptographic ledgers of all platform mutations.

```json
{
  "logId": "AUD-20260703-9910283",
  "timestamp": "2026-07-03T17:00:05.120Z",
  "actor": {
    "userId": "USR-MP-SRT-0001",
    "role": "MEMBER_OF_PARLIAMENT",
    "ipAddress": "103.21.124.88",
    "authClaimHash": "a9f83b201c841838e1a2b3c4d5e6f7a8"
  },
  "actionType": "SANCTION_PROJECT_BUDGET",
  "targetResource": {
    "collection": "projects",
    "documentId": "PRJ-GUJ-SRT-2026-0112",
    "previousState": "NEED_RAISED",
    "newState": "SANCTIONED"
  },
  "financialTransaction": {
    "budgetHead": "MPLADS_2026_27",
    "amountINR": 225000.00,
    "beneficiaryWardId": "WRD-GUJ-SRT-0014"
  },
  "cryptographicVerification": {
    "previousLogHash": "b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6",
    "currentPayloadSha256": "f8e7d6c5b4a392817263544536271829304958675647382910"
  }
}
```

---

## 3. Mandatory Firestore Index Configurations (`firestore.indexes.json`)

To enable lightning-fast multi-field dashboard queries, the following composite indexes must be deployed to Google Cloud project:

```json
{
  "indexes": [
    {
      "collectionGroup": "needs",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "location.ancestries", "arrayConfig": "CONTAINS" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "aiIntelligence.priorityScore", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "needs",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "routing.assignedOfficerId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "projects",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "location.pcId", "order": "ASCENDING" },
        { "fieldPath": "currentStatus", "order": "ASCENDING" },
        { "fieldPath": "financials.sanctionedBudgetINR", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "audit_logs",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "targetResource.documentId", "order": "ASCENDING" },
        { "fieldPath": "timestamp", "order": "DESCENDING" }
      ]
    }
  ]
}
```
