# JanSetu AI — RBAC & Governance Security Model
> **AI-Powered Government Digital Ecosystem & Constituency Development Intelligence Platform**
>
> **Version:** 2.0 (Enterprise Ecosystem Edition)
>
> **Document Type:** Governance, Access Control & Security Rules Specification
>
> **Purpose:** This document specifies the Role-Based Access Control (RBAC) matrix across all 12 enterprise user roles, formalizes officer spatial jurisdiction isolation rules, and provides the production Cloud Firestore Security Rules blueprint.

---

## 1. Enterprise RBAC Permission Matrix

JanSetu AI enforces least-privilege access control across 12 distinct stakeholder roles. Permissions are evaluated against Custom JWT Auth Claims embedded in Firebase ID tokens.

| System Action | Citizen | MP | MLA | DM/Collector | State/Nat Admin | Super Admin | Dept Head | Field Officer | Contractor | Auditor | Moderator |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Submit Multimodal Need** | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Upvote / Corroborate (500m)**| 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Sanction Project Budget** | 🔴 | 🟢* | 🟢* | 🟢* | 🟢* | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Float Public Tender** | 🔴 | 🔴 | 🔴 | 🟢 | 🟢 | 🔴 | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Award Contract Order** | 🔴 | 🔴 | 🔴 | 🟢 | 🟢 | 🔴 | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Log Execution Milestone** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢* | 🔴 | 🔴 |
| **Verify Milestone (50m GPS)** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢* | 🔴 | 🔴 | 🔴 |
| **Issue Completion Cert.** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 | 🟢* | 🔴 | 🔴 | 🔴 |
| **View Immutable Audit Log** | 🔴 | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🟢 | 🔴 |
| **Mod Feed & Remove Spam** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 |
| **Ingest Master Datasets** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |

*(Legend: 🟢 = Permitted, 🔴 = Denied, 🟢\* = Permitted strictly within assigned spatial/departmental jurisdiction or awarded contract scope).*

---

## 2. Officer Jurisdiction Isolation Rules

To prevent corruption and unauthorized cross-departmental overrides, the security model enforces three layers of isolation:

### 2.1 Spatial Geofence Isolation (Horizontal Fencing)
- A **Municipal Field Officer** assigned to `WRD-GUJ-SRT-0014` (Ward 14) has their read/write scope dynamically restricted to documents where `location.wardId == "WRD-GUJ-SRT-0014"`.
- If the officer attempts to query or mutate a grievance in Ward 15 (`WRD-GUJ-SRT-0015`), the Firestore Security Rules terminate the transaction with a `403 Permission Denied` exception.

### 2.2 Departmental Taxonomy Isolation (Vertical Fencing)
- An officer whose profile stores `departmentId: "DEPT_WATER_SUPPLY"` can only access needs and projects tagged with `DEPT_WATER_SUPPLY`.
- A Water Supply Engineer cannot approve milestone payments for a `DEPT_ROADS_HIGHWAYS` project occurring within the exact same physical ward.

### 2.3 Physical Presence Hardware Lock (50-Meter Geofence)
When a Field Officer conducts an engineering inspection or milestone sign-off:
1. The mobile client requests high-accuracy GPS coordinates from the device hardware.
2. The distance between the officer's physical coordinate and the asset's polygon centroid is calculated using the Haversine formula.
3. **Hardware Interlock**: If the computed distance exceeds **50.0 meters**, the mobile application programmatically disables camera shutter access, locks form submission buttons, and displays a red warning banner: *"Access Denied: You must be physically present at the asset site (Current offset: 184m)"*.
4. **Server-Side Validation**: Even if a malicious user bypasses the client UI, the Cloud Function endpoint `verifyMilestone()` validates the cryptographic EXIF GPS timestamp before committing to Firestore.

---

## 3. Production Cloud Firestore Security Rules (`firestore.rules`)

The following production-ready security rules enforce the RBAC matrix and jurisdiction isolation natively within Google Cloud:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // --- HELPER FUNCTIONS ---
    function isAuthenticated() {
      return request.auth != null;
    }

    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    function hasRole(targetRole) {
      return isAuthenticated() && (
        request.auth.token.role == targetRole ||
        targetRole in getUserData().secondaryRoles
      );
    }

    function isSuperAdmin() {
      return isAuthenticated() && request.auth.token.role == 'SUPER_ADMIN';
    }

    function matchesOfficerJurisdiction(resourceData) {
      let token = request.auth.token;
      return token.role == 'GOVERNMENT_OFFICER' &&
             token.departmentId == resourceData.departmentId &&
             (resourceData.location.wardId == token.jurisdictionLocationId ||
              resourceData.location.pcId == token.jurisdictionLocationId);
    }

    // --- COLLECTION RULES ---

    // 1. LOCATIONS & DIGITAL TWINS (Public Read, Admin Write)
    match /locations/{locationId} {
      allow read: if true;
      allow write: if isSuperAdmin() || hasRole('STATE_ADMIN') || hasRole('NATIONAL_ADMIN');
    }

    match /digital_twins/{twinId} {
      allow read: if true;
      allow write: if isSuperAdmin() || request.auth.token.isServiceAccount == true;
    }

    // 2. USERS (Users read/write own profile; Admins manage roles)
    match /users/{userId} {
      allow read: if isAuthenticated() && (request.auth.uid == userId || isSuperAdmin() || hasRole('DISTRICT_ADMIN'));
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isAuthenticated() && request.auth.uid == userId &&
                    // Prevent self-role elevation
                    request.resource.data.primaryRole == resource.data.primaryRole;
      allow delete: if isSuperAdmin();
    }

    // 3. DEPARTMENTS (Public Read, Admin Write)
    match /departments/{departmentId} {
      allow read: if true;
      allow write: if isSuperAdmin() || hasRole('NATIONAL_ADMIN');
    }

    // 4. DEVELOPMENT NEEDS (Citizens Submit; Officers & MPs Update within Jurisdiction)
    match /needs/{needId} {
      allow read: if true;
      allow create: if hasRole('CITIZEN') &&
                    request.resource.data.creatorUserId == request.auth.uid &&
                    request.resource.data.status == 'NEED_RAISED';
      allow update: if isSuperAdmin() ||
                    (hasRole('MEMBER_OF_PARLIAMENT') && resource.data.location.pcId == request.auth.token.jurisdictionLocationId) ||
                    matchesOfficerJurisdiction(resource.data) ||
                    (hasRole('MODERATOR') && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['isFlagged', 'moderatorNotes']));
      allow delete: if isSuperAdmin();
    }

    // 5. PROJECTS (Sanctioned by MPs/DMs; Milestones updated by Contractors & Officers)
    match /projects/{projectId} {
      allow read: if true;
      allow create: if isSuperAdmin() ||
                    (hasRole('MEMBER_OF_PARLIAMENT') && request.resource.data.location.pcId == request.auth.token.jurisdictionLocationId) ||
                    (hasRole('DISTRICT_ADMIN') && request.resource.data.location.districtId == request.auth.token.jurisdictionLocationId);
      allow update: if isSuperAdmin() ||
                    // Contractor updating progress photos and invoices for their awarded contract
                    (hasRole('CONTRACTOR') && resource.data.ownership.assignedContractorId == request.auth.uid &&
                     request.resource.data.diff(resource.data).affectedKeys().hasOnly(['milestones', 'progressPercentage', 'updatedAt'])) ||
                    // Officer verifying milestones within their jurisdiction
                    matchesOfficerJurisdiction(resource.data);
      allow delete: if isSuperAdmin();
    }

    // 6. ASSETS (Public Read; Officers & Dept Heads maintain within domain)
    match /assets/{assetId} {
      allow read: if true;
      allow write: if isSuperAdmin() || matchesOfficerJurisdiction(request.resource.data) || hasRole('DEPARTMENT_HEAD');
    }

    // 7. AUDIT LOGS (Strictly Read-Only for Auditors & Admins; Append-Only by Service Accounts)
    match /audit_logs/{logId} {
      allow read: if isSuperAdmin() || hasRole('AUDITOR') || hasRole('DISTRICT_ADMIN') || hasRole('STATE_ADMIN') || hasRole('NATIONAL_ADMIN');
      allow write: if false; // Mutated strictly via backend Cloud Functions / Service Accounts
    }

  }
}
```
