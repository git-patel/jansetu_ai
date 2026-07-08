# ROLE

You are a Principal Data Architect, Enterprise Solution Architect, Firebase Architect, AI System Designer, and Government Digital Platform Expert.

Your responsibility is NOT to write application code.

Your responsibility is to design the complete data foundation of JanSetu AI.

Everything in the platform must be based on this architecture.

Think like you are designing a national-scale digital governance platform that will eventually support every parliamentary constituency in India.

---

# IMPORTANT

Before starting, read these documents carefully.

docs/00_PROJECT_CONTEXT.md

docs/01_PRODUCT_REQUIREMENTS.md

Use them as the source of truth.

Never contradict them.

Only improve them.

---

# OBJECTIVE

Design the complete data architecture for JanSetu AI.

This architecture will become the foundation for

- Flutter Mobile App
- Flutter Admin Dashboard
- AI Engine
- Firebase
- Firestore
- Cloud Functions
- Analytics
- Future Integrations

Do NOT generate Flutter UI.

Do NOT generate backend APIs.

Only design the data layer.

---

# STEP 1 - IDENTIFY ALL ENTITIES

Identify every entity required by the platform.

Examples include (but are not limited to):

Country

State

District

Parliamentary Constituency

Assembly Constituency

Taluka

Municipality

Ward

Village

Area

Citizen

MP

Government Officer

Contractor

Government Department

Development Need

Development Category

Support

Comment

Attachment

Notification

Project

Project Milestone

Budget

Funding Source

Government Asset

Infrastructure

Survey

Poll

Future Development Plan

AI Recommendation

Audit Log

System Settings

Role

Permission

Analytics

Dashboard Metrics

Digital Twin

Infrastructure Gap

Maintenance Record

Inspection

Verification

Issue History

Risk Assessment

---

# STEP 2 - ENTITY DETAILS

For EVERY entity define

Purpose

Description

Fields

Field Types

Validation

Relationships

Indexes

Future Scope

Example Data

Firestore Collection Name

Document Structure

Naming Convention

---

# STEP 3 - FIRESTORE COLLECTIONS

Design a scalable Firestore database.

Support

Millions of users

Millions of development needs

Thousands of MPs

Offline synchronization

Fast search

Filtering

Role-based access

Minimal duplication

Low read costs

High scalability

---

# STEP 4 - RELATIONSHIPS

Design relationships between all entities.

Generate

Entity Relationship Diagram (ERD)

Mermaid ER Diagram

Relationship Tables

Parent-Child Mapping

Foreign Key Strategy (logical references)

Reference IDs

Denormalization strategy where appropriate

---

# STEP 5 - MASTER LOCATION MODEL

Design India's complete geographic hierarchy.

India

↓

State

↓

District

↓

Parliamentary Constituency

↓

Assembly Constituency

↓

Municipality / Taluka

↓

Ward

↓

Village / Area

↓

Street / Landmark

Every entity must contain

Unique ID

Parent ID

GPS Boundary (future)

Latitude

Longitude

Population

Metadata

---

# STEP 6 - USER MODEL

Design user models for

Citizen

MP

Government Officer

Contractor

District Admin

State Admin

National Admin

Super Admin

Each user should contain

Profile

Verification

Address

Role

Permissions

Home Constituency

Current Location

Department

Assigned Regions

Notification Preferences

Activity History

AI Usage

Security Metadata

---

# STEP 7 - DEVELOPMENT NEED MODEL

Design the most detailed Development Need schema possible.

Include

Title

Description

AI Summary

Original Text

Voice Recording

Images

Videos

PDFs

Category

Subcategory

Priority

Severity

Status

Location

Department

Community Support

Comments

AI Confidence

Duplicate Score

Estimated Cost

Expected Beneficiaries

Impact Score

Responsible MP

Responsible Officer

Responsible Department

Timeline

Audit Trail

History

Tags

Sentiment

Language

Translation

Geo Coordinates

Risk Level

Evidence

Verification Status

Created By

Created Date

Updated Date

---

# STEP 8 - PROJECT MODEL

Design a complete project lifecycle.

Need

↓

Verification

↓

Approval

↓

Funding

↓

Tender

↓

Contract

↓

Execution

↓

Milestones

↓

Inspection

↓

Completion

↓

Maintenance

Include every required field.

---

# STEP 9 - DIGITAL TWIN MODEL

Each constituency should maintain

Population

Road Network

Schools

Hospitals

Water Supply

Electricity

Public Buildings

Government Assets

Projects

Maintenance

AI Development Score

Citizen Satisfaction Score

Infrastructure Score

Risk Index

Environmental Score

Everything should be extensible.

---

# STEP 10 - GOVERNMENT DEPARTMENTS

Generate master department list.

Each department should contain

ID

Name

Description

Responsibilities

Officer Types

Project Types

Priority Rules

AI Keywords

Examples

---

# STEP 11 - AI MASTER DATA

Design master AI models for

Categories

Subcategories

Priority Rules

Impact Rules

Duplicate Detection

Recommendation Engine

Infrastructure Gap Engine

Budget Estimation

Heatmap Engine

Trend Analysis

Sentiment Analysis

Translation

Knowledge Base

Prompt Templates

Confidence Score

AI Feedback Loop

---

# STEP 12 - RBAC

Design enterprise Role-Based Access Control.

For every role define

Permissions

Allowed Screens

Allowed APIs

Allowed Collections

Read

Write

Update

Delete

Approval Rights

Analytics Access

Export Rights

Administration Rights

---

# STEP 13 - DUMMY DATA

Generate realistic Gujarat demo data.

State

Gujarat

Districts

Ahmedabad

Surat

Vadodara

Rajkot

Gandhinagar

5 Parliamentary Constituencies

10 Government Departments

50 Villages

500 Citizens

50 Officers

20 Contractors

300 Development Needs

75 Projects

100 Government Assets

Generate realistic relationships between every entity.

---

# STEP 14 - FIREBASE SECURITY

Recommend

Firestore Security Rules

Authentication Strategy

Role Validation

Collection Access

File Upload Rules

Storage Structure

Indexes

Cloud Functions Triggers

---

# STEP 15 - DOCUMENTATION

Generate professional Markdown documentation.

Include

Tables

ER Diagrams

Mermaid Diagrams

Examples

Architecture Notes

Best Practices

Scalability Notes

Performance Notes

Future Scope

---

# OUTPUT

Generate a complete enterprise-grade data architecture.

Do not write Flutter code.

Do not write APIs.

Do not generate UI.

Focus only on designing the complete database and master data model that every future module will use.