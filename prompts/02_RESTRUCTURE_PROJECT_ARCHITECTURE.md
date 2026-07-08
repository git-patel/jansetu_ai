# ROLE

You are the Chief Software Architect and Principal Solution Engineer responsible for designing the complete architecture of JanSetu AI.

You are NOT generating feature code.

Your responsibility is to redesign the project architecture so every future module follows a single scalable structure.

This is a production-quality AI-powered governance platform, not a hackathon prototype.

---

# IMPORTANT

Read these documents before making any changes.

docs/00_PROJECT_CONTEXT.md

docs/01_PRODUCT_REQUIREMENTS.md

These documents are the source of truth.

Never contradict them.

---

# OBJECTIVE

Redesign the project architecture to support the complete governance hierarchy of India.

The architecture must be scalable enough to support every state, district, parliamentary constituency, village, and citizen.

Everything should be location-aware and role-based.

---

# GOVERNANCE HIERARCHY

The platform should support the following hierarchy.

India

↓

State

↓

District

↓

Parliamentary Constituency (Lok Sabha)

↓

Assembly Constituency (Future Ready)

↓

City / Town / Village

↓

Ward (Urban)

↓

Area / Locality

Every entity must maintain parent-child relationships.

---

# USER ROLES

Implement a scalable Role-Based Access Control (RBAC) system.

The platform must support the following roles.

1. Citizen

2. Member of Parliament (MP)

3. Government Officer

4. Contractor

5. District Admin

6. State Admin

7. National Admin

8. Super Admin

The RBAC system must be extensible for future roles.

---

# ACCESS MATRIX

Citizen

Can

- Create Development Needs
- Support Existing Needs
- Comment
- Track Projects
- Vote on MP Plans
- View Public Data

Cannot

- Access other constituencies' private dashboards
- Approve projects
- Manage budgets

---

MP

Can access ONLY their assigned parliamentary constituency.

Can

- Review AI priorities
- Approve projects
- Reject projects
- Publish future plans
- View analytics
- View budgets
- Monitor execution

Cannot

- Access other MPs' dashboards
- Modify state-level data
- Access national analytics

---

Government Officer

Can access ONLY assigned projects and assigned geographic regions.

Can

- Verify needs
- Upload inspections
- Update project progress
- Upload reports
- Close verification tasks

---

Contractor

Can

- Access only assigned projects
- Upload work progress
- Upload bills
- Upload completion photos

Cannot

- Approve projects
- View confidential analytics

---

District Admin

Can access all districts assigned.

Can

- Monitor officers
- View district analytics
- Review projects
- Assign officers

---

State Admin

Can access all constituencies within the assigned state.

Can

- View all MPs
- View state analytics
- Compare districts
- Compare constituencies
- Monitor budgets
- Export reports

Cannot

- Modify national settings

---

National Admin

Can access

All states

All districts

All constituencies

All MPs

All analytics

National reports

---

Super Admin

Complete platform access.

Can manage

Roles

Permissions

Datasets

AI Models

Platform Configuration

System Health

Security

Audit Logs

---

# LOCATION MODEL

Every citizen should have two locations.

Home Constituency

Used for

Voting

Supporting Needs

Community Participation

Current GPS Location

Used for

Reporting Development Needs

Uploading Evidence

Location Validation

AI should automatically map GPS coordinates to

State

District

Parliamentary Constituency

Ward

Village

Area

---

# AUTOMATIC ROUTING

The citizen should never manually choose an MP.

The AI must automatically determine

Responsible MP

Responsible Officer

Responsible Administrative Region

Based on

GPS

Address

Village

Constituency

---

# MASTER DATA MODEL

Generate scalable master models for

Country

State

District

Constituency

Village

Ward

Area

Public Assets

Projects

Development Needs

Infrastructure

Budgets

Government Offices

Schools

Hospitals

Roads

Water Supply

Public Utilities

All entities must support future expansion.

---

# DATABASE DESIGN

Update Firestore collections to support the hierarchy.

Example

countries

states

districts

constituencies

villages

areas

users

development_needs

projects

comments

supports

notifications

budgets

government_assets

public_infrastructure

Maintain proper references.

Avoid duplicated data.

Optimize for Firestore queries.

---

# DASHBOARD ACCESS

Citizen Dashboard

Shows

Own profile

Nearby development needs

Supported projects

Notifications

Community feed

---

MP Dashboard

Shows ONLY

Own constituency

Own analytics

Own projects

Own budgets

Own AI recommendations

Own citizen statistics

---

State Dashboard

Shows

State heatmap

District comparison

MP comparison

Budget utilization

Infrastructure score

---

National Dashboard

Shows

India overview

State comparison

Development index

Population coverage

AI recommendations

---

# DUMMY DATA

Generate realistic seed data.

Country

India

State

Gujarat

Districts

Ahmedabad

Surat

Rajkot

Vadodara

Constituencies

Minimum 5

Villages

Minimum 50

Citizens

500

Development Needs

300

Projects

75

Completed Projects

25

Government Officers

30

MPs

5

Contractors

20

---

# FUTURE READY

Architecture should support

MLA

Municipal Corporation

Panchayat

Smart Cities

State Schemes

Central Schemes

IoT Sensors

Digital Twin

Predictive Maintenance

Satellite Data

Open Government Data

---

# OUTPUT

Update the complete project architecture.

Update folder structure if required.

Update Firestore schema.

Update documentation.

Update navigation.

Update routing.

Update user permissions.

Generate Mermaid diagrams.

Generate professional architecture documentation.

Do not generate application feature code.

Only redesign the complete architecture for long-term scalability.