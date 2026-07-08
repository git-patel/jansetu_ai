# ROLE

You are the Chief Product Officer, Senior Flutter Architect, UX Designer, Security Architect, Firebase Authentication Expert, Material 3 Designer, and Hackathon Judge.

Your responsibility is to completely redesign the application entry experience.

The application should feel like a real production product.

Currently the application immediately shows three persona cards:

• Citizen
• MP
• Admin

This is NOT acceptable.

This screen must be removed from production.

The application should instead follow a professional authentication flow similar to Google Pay, DigiLocker, Aarogya Setu or MyGov.

Read the complete project before making changes.

Reuse the existing architecture.

Do not duplicate code.

---

# OBJECTIVE

Build a complete authentication and onboarding experience.

The application should automatically determine which dashboard to open based on the authenticated user's role.

The user should NEVER manually choose Citizen / MP / Admin in production.

---

# APPLICATION FLOW

The application must follow this exact flow.

Splash Screen

↓

Language Selection (First Launch Only)

↓

Welcome Screen

↓

Login

↓

Authentication

↓

Role Detection

↓

Dashboard

Citizen → Citizen App

MP → MP Dashboard

Admin → State Admin Dashboard

---

# SPLASH SCREEN

Create a premium splash screen.

Show

JanSetu AI Logo

Government of India inspired branding

Tagline

"AI should think. Humans should decide."

Smooth fade animation.

App Version

Loading indicator.

Automatically navigate.

---

# LANGUAGE SELECTION

Only first launch.

Support

English

ગુજરાતી

हिन्दी

Save preference locally.

Allow changing language later in Settings.

---

# WELCOME SCREEN

Beautiful onboarding.

3 pages.

Page 1

Report Development Needs with AI.

Page 2

Track Projects Transparently.

Page 3

Build Better Communities Together.

Buttons

Skip

Next

Get Started

Modern illustrations.

---

# LOGIN SCREEN

Professional design.

Dark Theme.

Large Government Branding.

Options

Mobile Number

OTP

Continue

OR

Demo Login

Footer

Privacy Policy

Terms

App Version

Help

---

# OTP FLOW

OTP architecture should exist.

Since Hackathon uses demo mode,

generate local mock OTP.

Example

999999

Show success animation.

Store session.

---

# DEMO MODE

Very important.

Hackathon judges should not need OTP.

Add a dedicated button.

"Continue in Demo Mode"

On click

Open persona selection.

Citizen Demo

MP Demo

State Admin Demo

Each profile contains realistic Gujarat data.

Display DEMO badge throughout the app.

This screen must only appear when Demo Mode is selected.

In production, this screen is hidden.

---

# ROLE DETECTION

Never ask users which dashboard they want.

Role comes from authenticated account.

Citizen

↓

Citizen App

MP

↓

MP Dashboard

Admin

↓

State Dashboard

Role should be stored locally for demo.

Architecture should support Firebase later.

---

# SESSION MANAGEMENT

Implement

Remember Login

Auto Login

Logout

Session Restore

Session Expiry Placeholder

---

# USER PROFILE

Every authenticated user has

User ID

Name

Photo

Phone

Role

District

Constituency

Ward

Language

Permissions

Profile Completion

---

# NAVIGATION

Protected Routes.

Unauthenticated users cannot access dashboards.

Logout returns to Login.

Back button should never bypass authentication.

---

# DEBUG MODE

Developer Persona Switcher.

IMPORTANT

Only available when

kDebugMode == true

Never visible in Release Mode.

Developer Menu

Switch Citizen

Switch MP

Switch Admin

Reset Local Database

Reset Session

Generate Demo Data

View Logs

This menu must never appear for judges.

---

# SECURITY

Prepare architecture for

Firebase Authentication

OTP

Role Based Access Control

Session Tokens

Refresh Tokens Placeholder

Secure Local Storage

Do not implement production backend.

Only prepare clean architecture.

---

# ERROR HANDLING

Invalid OTP

No Internet

Session Expired

Unauthorized

Unknown Role

Loading

Retry

Beautiful state pages.

---

# ANIMATIONS

Splash Fade

Logo Animation

Page Transition

OTP Success

Button Animation

Loading

Smooth Navigation

---

# RESPONSIVENESS

Perfect on

Android

iPhone

Tablet

Flutter Web

Desktop

---

# DARK MODE

Entire authentication module uses Dark Mode.

Premium Material 3 styling.

---

# QA

Verify

First Launch

Second Launch

Language Saved

Session Saved

Logout

Demo Login

Role Routing

Back Navigation

No dead buttons.

No placeholder dialogs.

No broken navigation.

---

# FINAL USER FLOW

Citizen

Open App

↓

Splash

↓

Language

↓

Welcome

↓

Login

↓

Demo Login

↓

Citizen Dashboard

MP

Open App

↓

Splash

↓

Login

↓

Demo Login

↓

MP Dashboard

Admin

Open App

↓

Splash

↓

Login

↓

Demo Login

↓

State Dashboard

Everything should function correctly using local demo data.

The application should feel like a polished production mobile application rather than a development prototype.