# ROLE

You are the Chief Software Architect, Principal Flutter Engineer, Firebase Architect, Backend Engineer, Security Engineer, DevOps Engineer, AI Systems Architect, and Hackathon Judge.

Your responsibility is to transform the current JanSetu AI backend into a production-grade architecture.

IMPORTANT

Do NOT tightly couple the application to Firebase.

Instead build a scalable architecture where the data source can be changed without modifying UI or business logic.

The current local demo implementation must continue working.

Firebase will simply become another implementation of the repository layer.

Follow Clean Architecture.

Follow SOLID Principles.

Follow Repository Pattern.

Follow Dependency Injection.

---

# OBJECTIVE

Refactor the backend architecture.

The UI should never know where the data comes from.

Whether data comes from

Local JSON

Hive

SQLite

Firebase

REST API

Government APIs

The UI should never change.

---

# PROJECT STRUCTURE

Create a clean structure.

lib/

core/

config/

constants/

errors/

extensions/

network/

utils/

services/

repositories/

models/

features/

shared/

Every feature should contain

data/

domain/

presentation/

Use dependency injection.

Avoid singleton abuse.

---

# REPOSITORY PATTERN

Every module must have interfaces.

Example

AuthRepository

CitizenRepository

NeedRepository

ProjectRepository

CommentRepository

SupportRepository

NotificationRepository

AreaRepository

AnalyticsRepository

AiRepository

No UI should directly access local persistence.

Everything goes through repositories.

---

# DATA SOURCES

Support multiple data sources.

Local Demo

Hive

SQLite

Firebase

REST API

Mock API

Government APIs

Switch through dependency injection.

No UI changes required.

---

# LOCAL DATABASE

Improve current local storage.

Support

CRUD

Caching

Offline Queue

Versioning

Migration

Relationships

Indexes

Search

Filtering

Sorting

Pagination

Soft Delete

Everything using demo data.

---

# FIREBASE READY

Prepare interfaces for

Firebase Authentication

Cloud Firestore

Cloud Storage

Firebase Messaging

Remote Config

Crashlytics

Analytics

App Check

Do not require Firebase to run.

Only prepare clean implementations.

---

# AUTHENTICATION

Repository

AuthRepository

Methods

Login

Logout

Refresh

Verify OTP

Demo Login

Current User

Session Restore

Role Detection

Everything interface driven.

---

# DEVELOPMENT NEEDS

Repository

NeedRepository

Methods

Create

Update

Delete

Publish

Save Draft

Search

Filter

Nearby

Trending

Duplicate Detection Placeholder

Support

Comment

Track

Everything local.

---

# PROJECTS

Repository

ProjectRepository

Methods

Create

Approve

Assign Officer

Update Timeline

Budget

Inspection

Media

History

Everything local.

---

# COMMENTS

Repository

CommentRepository

Methods

Add

Reply

Edit

Delete

Like

Report

Mention

Pagination

Lazy Loading

---

# SUPPORT

Repository

SupportRepository

Rules

One User

One Support

Toggle

Counter

Realtime Placeholder

---

# NOTIFICATIONS

Repository

NotificationRepository

Methods

Create

Read

Delete

Mark All

Filter

Search

Grouped

---

# USER

Repository

UserRepository

Profile

Area

Permissions

Language

Role

Settings

CRUD

---

# ANALYTICS

Repository

AnalyticsRepository

Development Score

Citizen Satisfaction

Budget

Department Performance

Project Progress

Everything calculated dynamically.

---

# AI

Repository

AiRepository

Methods

Summarize

Categorize

Priority

Duplicate Detection

Department Suggestion

Impact Score

Chat

Current implementation uses local mock responses.

Architecture should support Gemini later.

---

# CACHE

Implement

Memory Cache

Persistent Cache

TTL

Invalidation

Offline Queue

Retry

Background Sync Placeholder

---

# STATE MANAGEMENT

Review Riverpod implementation.

Remove duplicated providers.

Optimize rebuilds.

Use AsyncNotifier where appropriate.

Avoid unnecessary state.

---

# ERROR HANDLING

Create centralized error handling.

Network

Storage

Authentication

Permission

Validation

AI

Unknown

Friendly messages.

---

# LOGGING

Central logger.

Debug only.

Levels

Info

Warning

Error

Success

Never expose logs in Release.

---

# SECURITY

Prepare

Secure Storage

Encrypted Preferences Placeholder

Token Management

Role Validation

Permission Validation

No production secrets.

---

# PERFORMANCE

Optimize

Database

Search

Filtering

Pagination

Large Lists

Memory

Widget Rebuilds

Repository Calls

Caching

Lazy Loading

---

# TESTABILITY

Repositories must be mockable.

Dependency Injection everywhere.

No static business logic.

Prepare for unit testing.

---

# DEMO DATA

Improve demo data.

Realistic Gujarat

Citizens

MPs

Districts

Needs

Projects

Departments

Notifications

Comments

Supports

Media

Timeline

Everything interconnected.

---

# FINAL VALIDATION

Verify

UI does not directly access storage.

Repositories isolated.

Data source interchangeable.

No duplicated logic.

No hardcoded demo data inside UI.

Everything works offline.

Application behaves exactly as before.

Architecture is production-ready.

Future Firebase integration should only require replacing repository implementations.

No UI changes should be required.

The codebase should now be enterprise-grade while remaining simple enough for hackathon development.