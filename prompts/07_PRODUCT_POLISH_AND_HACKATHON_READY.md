# ROLE

You are the Chief Product Officer (CPO), Senior UX Designer, Flutter Tech Lead, Enterprise Product Architect, and Hackathon Judge.

Your responsibility is NOT to generate random UI screens.

Your responsibility is to review the ENTIRE JanSetu AI application, identify weaknesses, and transform it into a polished, production-quality AI Governance Platform suitable for a national-level hackathon demonstration.

You must think like both a product company and a hackathon judge.

The application should be understandable within 30 seconds by a first-time user.

---

# IMPORTANT

Before making any changes:

Read the entire codebase.

Read all documentation.

Read all design system files.

Read all generated architecture.

Read all screens.

Read all widgets.

Read all routes.

Read all models.

Read all dummy datasets.

Understand the complete application before modifying anything.

Never duplicate functionality.

Prefer refactoring over adding duplicate screens.

---

# PRIMARY OBJECTIVE

Transform the current application into a complete product.

The current implementation contains many screens but lacks a complete user experience.

Fix that.

---

# REVIEW THE CURRENT APPLICATION

Perform a complete audit.

Review

Navigation

Information hierarchy

User journeys

Authentication

Dashboard UX

Accessibility

Responsiveness

Animations

Component consistency

Typography

Spacing

Icons

Data visualization

Loading states

Error states

Offline states

Role management

Community interactions

Metadata visibility

CRUD workflows

Search experience

Filter experience

Overall product experience

List all issues before making improvements.

---

# AUTHENTICATION

Authentication must become the first experience.

Required flow:

Splash

↓

Language Selection

↓

Welcome Screen

↓

Login

↓

OTP Verification

↓

Role Detection

↓

Profile Completion (only first login)

↓

Role Based Dashboard

Citizen

MP

Admin

Support

Remember Login

Logout

Session Restore

Unauthorized Access

Role Validation

Developer Persona Switcher (Development mode only)

Never show Citizen / MP / Admin selection in production.

---

# GLOBAL PRODUCT PRINCIPLES

Simple.

Friendly.

Modern.

Minimal.

Professional.

Government Friendly.

AI First.

No information overload.

Large typography.

Large touch targets.

Meaningful icons.

Material 3.

Responsive.

Multilingual.

Accessibility first.

Maximum 5 primary actions on every screen.

Maximum 3 navigation levels.

Every screen should answer ONE question.

---

# CITIZEN APPLICATION

Redesign completely.

Citizen Home should answer:

What is happening in my area?

What can I do today?

Home should contain:

Greeting

Area name

Quick Report button

Development Score

Nearby Active Projects

High Priority Needs

Community Updates

Upcoming Development Plans

MP Announcements

Officer Announcements

My Requests

Needs I Support

AI Assistant

Nothing more.

Avoid clutter.

---

# REPORT DEVELOPMENT NEED

This is the core feature.

Citizen can submit

Voice

Text

Images

Videos

Documents

GPS

AI should

Summarize

Translate

Categorize

Estimate Priority

Detect Duplicate

Identify Department

Estimate Impact

Recommend Solution

Estimate Cost

Identify Responsible Officer

Identify Responsible MP

Before publishing

Show AI Summary

Ask

"Is this correct?"

Citizen confirms

Publish

---

# COMMUNITY FEED

Completely redesign.

Each post should feel modern.

Every card should contain

Photo (if available)

Category

Priority

Department

Location

AI Summary

Support Count

Comment Count

Status

Progress

Estimated Timeline

Buttons

Support

Comment

Share

Track

View Details

Large CTA buttons.

Friendly UI.

No long paragraphs.

---

# COMMUNITY INTERACTION

Citizen must be able to

Support Development Need

Comment

Reply

Mention

Share

Bookmark

Follow Progress

Receive Notifications

Report Duplicate

Suggest Improvement

Everything should update engagement counters.

---

# DETAIL PAGE

Metadata should NEVER appear on feed cards.

Metadata belongs here.

Include

Timeline

Audit History

Officer

Department

MP

Budget

Documents

Photos

Videos

Inspection Reports

AI Analysis

Impact Score

Nearby Similar Needs

Map

Community Discussion

Supporters

Verification History

Expandable sections only.

---

# PROFILE

Every role should have a professional profile.

Citizen Profile

Profile Information

Verification

Languages

Notifications

Privacy

Address

My Village

Ward

District

Constituency

Assigned MP

Assigned Officer

Emergency Contacts

Settings

Dark Mode

Logout

Support

---

# PROFILE MODULES

Citizen must manage

My Development Needs

My Supported Needs

My Comments

Saved Posts

Uploaded Media

Notifications

Activity History

Achievements (Future)

Everything should support CRUD where applicable.

---

# MY AREA

Citizen should see

Area Development Score

Population

Schools

Hospitals

Roads

Water

Electricity

Internet

Current Projects

Upcoming Projects

MP Details

Officer Details

Department Contacts

Emergency Numbers

Everything should be visual.

---

# MP DASHBOARD

The dashboard should answer

"What needs my attention today?"

Top KPI Cards

High Priority Needs

Pending Approvals

Delayed Projects

Budget Utilization

Population Covered

Citizen Satisfaction

Infrastructure Score

Department Performance

AI Recommendations

Upcoming Plans

Do NOT overload the screen.

Everything should be actionable.

---

# MP DETAILS

Provide

Constituency Overview

Population

Schools

Hospitals

Road Length

Water Supply

Government Buildings

Current Projects

Future Plans

Budget

Department Health

Development Score

Trend Charts

Maps

Everything should support drill-down.

---

# ADMIN DASHBOARD

Focus on governance.

Top KPIs

Total Citizens

Total MPs

Total Officers

Departments

Projects

Budgets

Assets

AI Insights

District Performance

State Development Score

Charts first.

Tables only when necessary.

---

# SEARCH

Every application should include

Global Search

AI Search

Advanced Filters

Voice Search (future)

Saved Filters

Recent Searches

---

# AI ASSISTANT

Available everywhere.

Citizens ask

Show nearby road issues

Track my request

Explain project status

Find water projects

MP asks

Show urgent villages

Pending approvals

Delayed projects

Budget utilization

Admin asks

Compare districts

Generate reports

State analytics

Natural language only.

---

# VISUAL DESIGN

Reduce text.

Increase visual communication.

Use

Cards

Icons

Charts

Progress Rings

Timelines

Maps

Status Chips

Badges

Illustrations

Only show detailed metadata when users request it.

---

# RESPONSIVE DESIGN

Citizen App

Android

iOS

Tablet

Flutter Web

MP Dashboard

Desktop

Laptop

Large Screens

Admin Dashboard

Desktop First

Responsive

Ensure nothing is clipped or hidden on Flutter Web.

---

# PERFORMANCE

Optimize

Scrolling

Animations

Lazy Loading

Image Loading

Search

Navigation

State Management

Widget Reuse

---

# FINAL REVIEW

Review every screen as if you are a hackathon judge.

Ask:

Can a first-time user understand this within 30 seconds?

Does every role have a complete workflow?

Is the UI clean?

Is the data meaningful?

Is AI clearly adding value?

Would this impress judges?

If not, improve it.

---

# OUTPUT

Refactor the application.

Improve existing code.

Reuse existing components.

Do not create unnecessary screens.

Deliver a polished, modern, production-quality application that clearly demonstrates AI-powered constituency development planning.

The final result should feel like a premium product built by an experienced product company rather than a collection of generated Flutter screens.