# ROLE

You are the Chief Product Officer (CPO), Senior Mobile UX Designer, Flutter UI Architect, Material 3 Expert, Human-Centered Design Specialist, and Hackathon Judge.

Your responsibility is NOT to add more features.

Your responsibility is to completely redesign the existing JanSetu AI application to become a beautiful, mobile-first, user-friendly application while preserving all existing functionality.

Think like you are redesigning Google Pay, Instagram, and Google Maps for Government Development.

The application should be usable by every citizen, including elderly users and people with limited digital literacy.

---

# IMPORTANT

DO NOT create new screens unless absolutely necessary.

DO NOT remove functionality.

DO NOT remove business logic.

Refactor the existing implementation.

Improve the UI.

Improve UX.

Improve interactions.

Improve layouts.

Improve responsiveness.

Improve readability.

---

# FIRST TASK

Review the entire Flutter application.

Audit every screen.

Identify

• Complex layouts
• Poor spacing
• Too much text
• Poor typography
• Small buttons
• Overflow issues
• Bad scrolling
• Mixed widgets
• Crowded cards
• Non-responsive layouts
• Poor tablet behaviour
• Poor Flutter Web responsiveness
• Missing animations
• Missing feedback
• Poor accessibility

Fix everything.

---

# MOBILE FIRST

The Citizen App is MOBILE FIRST.

Every screen should be designed for

Android

iPhone

Small Screens

Only afterwards adapt for Tablet and Flutter Web.

Never design desktop layouts first.

---

# HOME SCREEN

Current home screen contains too much information.

Redesign it.

Citizen should immediately understand

Good Morning Harsh 👋

How can we improve your area today?

Large Primary Button

Report Development Need

Below it

Nearby Active Projects

Nearby High Priority Needs

Community Updates

Upcoming Development Plans

My Requests

Nothing else.

Remove unnecessary statistics.

Reduce text.

Use illustrations where appropriate.

---

# COMMUNITY FEED

Current feed looks like a report.

Redesign it.

Each card should be clean.

Example

----------------------------------

🚧 Road Repair Needed

📍 Adajan Ward

👍 235 Citizens Support

🏛 Roads Department

⏳ Under Review

AI Summary

"Potholes causing traffic and safety issues near school."

----------------------------------

Buttons

👍 Support

💬 Comment

↗ Share

📍 Track

----------------------------------

Only show summary.

No metadata.

No audit logs.

No contractor IDs.

No GPS coordinates.

Metadata belongs only inside Detail Page.

---

# SUPPORT SYSTEM

Current implementation is incorrect.

Fix it.

Rules

One authenticated citizen can support a Development Need only once.

Pressing Support again removes support.

Support count updates immediately.

Store supporter IDs.

Prevent duplicate supports.

Synchronize counters correctly.

Display

"You already support this Development Need."

when applicable.

---

# COMMENT SYSTEM

Current implementation is incomplete.

Bottom sheet must become a real discussion area.

Requirements

View all comments

Write comment

Reply to comment

Edit own comment

Delete own comment

Mention another user

Time ago formatting

Like comment

Report comment

Lazy loading

Auto scroll to latest

Comment counter updates dynamically.

No fake placeholder sheet.

---

# SHARE

Implement meaningful share preview.

Generate share card

Title

Location

AI Summary

Status

Support Count

Deep Link placeholder

---

# DETAIL PAGE

Every card opens Detail Page.

Only here display

Timeline

AI Reasoning

Budget

Department

Officer

MP

Documents

Photos

Videos

Inspection Reports

Nearby Similar Needs

History

Audit Trail

Everything grouped into expandable sections.

---

# PROFILE

Redesign completely.

Tabs

My Profile

My Requests

Supported Needs

Comments

Saved

Notifications

My Area

Settings

Simple.

Beautiful.

Modern.

---

# MY AREA

Redesign visually.

Use cards.

Progress Rings.

Icons.

Development Score.

Population.

Schools.

Hospitals.

Roads.

Water.

Internet.

Current Projects.

Upcoming Projects.

MP Contact.

Officer Contact.

Emergency Numbers.

Avoid tables.

---

# MP DASHBOARD

Current dashboard contains too much data.

Simplify.

Question answered

"What needs my attention today?"

Top cards

Critical Needs

Pending Approvals

Delayed Projects

Budget Remaining

Citizen Satisfaction

AI Recommendation

Everything else behind drill-down.

---

# ADMIN DASHBOARD

Question answered

"Is Gujarat improving?"

Top cards

Development Score

District Ranking

Budget Usage

Projects

Departments

AI Alerts

Everything else secondary.

---

# DESIGN RULES

Material 3

8dp spacing

Rounded corners

Large touch targets

Readable typography

Minimal colors

Soft shadows

Premium animations

No information overload

Maximum 5 actions per screen

Maximum 2 CTA buttons

Large whitespace

Simple language

Gujarati + English labels where appropriate

---

# RESPONSIVENESS

Every screen must work perfectly on

Android

iPhone

Tablet

Flutter Web

Desktop

Ultra Wide

No RenderFlex overflow.

No clipped widgets.

No hidden content.

Adaptive layouts required.

---

# PERFORMANCE

Optimize

Scrolling

Image loading

Animations

Navigation

State updates

Large lists

Widget rebuilds

---

# ACCESSIBILITY

Large fonts

Voice friendly

High contrast

Large buttons

Readable colors

Screen reader friendly

---

# HACKATHON REVIEW

After redesigning every screen ask

Would a first-time user understand this within 10 seconds?

Would a non-technical citizen feel comfortable?

Would a judge immediately understand the value?

Would this look like a production app?

If the answer is NO,

redesign again.

---

# OUTPUT

Do not generate new documentation.

Refactor the existing Flutter project.

Improve every screen.

Improve every interaction.

Improve every layout.

Improve every animation.

Improve every button.

Improve every card.

Improve every responsive layout.

Improve every CRUD flow.

Keep business logic unchanged.

Deliver a polished, mobile-first, production-quality application that feels like a premium product rather than a generated prototype.