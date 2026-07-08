"use client";

import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import { demoUrl } from "../../lib/constants";
import { Smartphone, Layout, UserCheck, Sparkles, CheckCircle2, ChevronRight } from "lucide-react";

export function ShowcaseSection() {
  const [activeGalleryTab, setActiveGalleryTab] = useState<string>("citizen");

  const suites = [
    {
      title: "Citizen Engagement Mobile App",
      role: "CITIZEN INTERFACE",
      description: "Voice-first reporting application allowing constituents to bypass administrative hurdles. Translates local Gujarati/Hindi dialects, validates GPS boundaries, and visualizes milestone progression.",
      icon: Smartphone,
      link: demoUrl,
      features: [
        "Language Localization (English, Gujarati, Hindi)",
        "Voice Recorder Intake & Live Translation Pipeline",
        "Geofenced Ward GIS & Digital Twin Twin View",
        "Interactive upvotes (1-support-per-user constraint)",
        "Nested Comments & real-time milestone notifications"
      ]
    },
    {
      title: "MP Executive Command Center",
      role: "REPRESENTATIVE INTERFACE",
      description: "Interactive dashboard providing constituency representatives with objective, AI-sorted severity metrics. Helps track fund allocations, assign executing municipal departments, and sanction projects instantly.",
      icon: Layout,
      link: demoUrl,
      features: [
        "Dynamic Morning Briefing AI summaries",
        "1-Click MPLADS Budget Sanctioning (₹5Cr allocation)",
        "AI Priority Queue (Demographic severity calculation)",
        "GPS Officer/Department inspection assignment",
        "Constituency Deficit Score Analytics"
      ]
    },
    {
      title: "State Administration Panel",
      role: "OFFICER & ADMIN INTERFACE",
      description: "An audit-ready oversight portal for department supervisors. Tracks contractor milestones, compares municipal SLA averages, and manages budget releases transparently.",
      icon: UserCheck,
      link: demoUrl,
      features: [
        "State-wide aggregate statistics cards",
        "Staggered Escrow Tranche releases (Milestone verification)",
        "Interactive department performance SLA rankings",
        "District deficiency maps & risk alert registries",
        "Cryptographic token authorization logs"
      ]
    }
  ];

  const galleryTabs = [
    { id: "citizen", label: "Citizen Feed" },
    { id: "mp", label: "MP Workspace" },
    { id: "admin", label: "Admin Panel" },
    { id: "ai", label: "AI Assistant" },
    { id: "timeline", label: "Project Timeline" },
  ];

  const galleryContent: Record<string, { title: string; desc: string; details: string[]; mock: string }> = {
    citizen: {
      title: "Constituency Needs Feed",
      desc: "Real-time, duplicate-deduplicated feed of citizen reports, featuring SLA warnings, budget approximations, and support counts.",
      details: ["1-click upvote validation", "Visual status tags", "Ward target identifiers"],
      mock: "┌──────────────────────────────────────────┐\n│ 👤 Rajesh Bhai • SLA Adajan: 94.2%       │\n├──────────────────────────────────────────┤\n│ ⚠️ Potholes near Navyug College          │\n│ Category: Roads • AI Priority: 84.5      │\n│ Estimated Cost: ₹15L                     │\n│ [Supports: 17]        [Comments: 2]      │\n└──────────────────────────────────────────┘",
    },
    mp: {
      title: "MP Command Board",
      desc: "An overview of active MPLADS allocations, displaying priority indices and one-click sanctioning workflows.",
      details: ["Active allocation: ₹3.50 Crore", "Geospatial deficit heatmaps", "Interactive priority queue"],
      mock: "┌──────────────────────────────────────────┐\n│ 🏛️ Hon. C.R. Patil • Remaining: ₹3.50Cr  │\n├──────────────────────────────────────────┤\n│ URGENT NEEDS QUEUE                       │\n│ 1. Gaurav Path Potholes (Score: 84.5)     │\n│    [Assign PWD]       [Approve ₹15L]     │\n└──────────────────────────────────────────┘",
    },
    admin: {
      title: "State Admin Dashboard",
      desc: "Oversight and auditing metrics detailing department SLA rankings and milestone release schedules.",
      details: ["Escrow budget tranche management", "SLA compliance averages", "Audit registries"],
      mock: "┌──────────────────────────────────────────┐\n│ ⚙️ State Administration Workspace        │\n├──────────────────────────────────────────┤\n│ Department SLA Rankings                  │\n│ 🥇 PWD: 94.2%  🥈 Health: 91.8%          │\n│ [Active Projects: 42] [Tranche Queue: 3] │\n└──────────────────────────────────────────┘",
    },
    ai: {
      title: "Gemini AI Copilot",
      desc: "Centralized AI model supporting automatic translation, OCR check, priority calculation, and conversational chat.",
      details: ["Voice translations using Gemini Flash", "OCR validation reports", "0-100 severity index calculations"],
      mock: "┌──────────────────────────────────────────┐\n│ ✨ Gemini AI Copilot                     │\n├──────────────────────────────────────────┤\n│ Citizen Input: \"Potholes near school...\" │\n│ AI Action: Translating to Gujarati...     │\n│ Est. Budget: ₹15,00,000 | Department: PWD │\n└──────────────────────────────────────────┘",
    },
    timeline: {
      title: "Milestone Tracking Engine",
      desc: "6-stage timeline tracking civil works transparently from citizen submission to final completion check.",
      details: ["Submissions, approvals, audits", "Geotagged milestone photo requirements", "Direct contractor feedback loops"],
      mock: "┌──────────────────────────────────────────┐\n│ 📈 Need: ND-2026-SRT-116 Timeline        │\n├──────────────────────────────────────────┤\n│ [●] Submitted -> [●] Sanctioned          │\n│ -> [●] Contractor Assigned                │\n│ -> [○] Work In Progress -> [○] Completed │\n└──────────────────────────────────────────┘",
    },
  };

  return (
    <section id="showcase" className="py-24 relative overflow-hidden bg-background">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Product Showcase"
          title="Designed for Public Excellence"
          subtitle="Explore the interactive stakeholder environments tailored to citizens, public representatives, and administrative authorities."
        />

        {/* Showcase Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-24">
          {suites.map((suite, idx) => {
            const Icon = suite.icon;
            return (
              <motion.div
                key={suite.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.1 }}
                className="glass-card rounded-3xl p-8 border border-border/80 hover:border-primary/50 transition-all duration-300 flex flex-col justify-between group bg-gradient-to-b from-muted/20 to-transparent"
              >
                <div className="space-y-6">
                  <div className="flex items-center gap-3">
                    <div className="p-3 rounded-2xl bg-primary/10 text-primary group-hover:scale-110 transition-transform duration-300">
                      <Icon className="w-6 h-6" />
                    </div>
                    <div>
                      <span className="text-[10px] font-mono font-bold text-primary uppercase tracking-wider block">
                        {suite.role}
                      </span>
                      <h3 className="text-xl font-bold text-foreground group-hover:text-primary transition-colors">
                        {suite.title}
                      </h3>
                    </div>
                  </div>

                  <p className="text-sm text-muted-foreground leading-relaxed">
                    {suite.description}
                  </p>

                  <div className="space-y-2.5 pt-4 border-t border-border/50">
                    <span className="text-xs font-mono font-bold text-foreground block">KEY IMPLEMENTED FEATURES</span>
                    {suite.features.map((feat) => (
                      <div key={feat} className="flex items-start gap-2.5 text-xs text-muted-foreground leading-relaxed">
                        <CheckCircle2 className="w-4 h-4 text-success shrink-0 mt-0.5" />
                        <span>{feat}</span>
                      </div>
                    ))}
                  </div>
                </div>

                <a
                  href={suite.link}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-8 flex items-center justify-between px-5 py-3 rounded-xl bg-muted/80 hover:bg-primary hover:text-primary-foreground border border-border transition-all duration-300 text-xs font-bold text-foreground"
                >
                  <span>Open Live Demo</span>
                  <ChevronRight className="w-4 h-4" />
                </a>
              </motion.div>
            );
          })}
        </div>

        {/* Interactive Screenshot Gallery */}
        <div className="border border-border/80 rounded-3xl p-8 lg:p-12 bg-muted/10 relative overflow-hidden">
          <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6 mb-12 border-b border-border/60 pb-8">
            <div>
              <span className="text-xs font-mono font-bold text-primary uppercase tracking-widest block mb-2">INTERFACE MAPS</span>
              <h3 className="text-2xl sm:text-3xl font-extrabold text-foreground tracking-tight">
                Screenshot Gallery
              </h3>
            </div>
            
            <div className="flex flex-wrap gap-2">
              {galleryTabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveGalleryTab(tab.id)}
                  className={`px-4 py-2 rounded-xl text-xs font-bold border transition-all duration-200 ${
                    activeGalleryTab === tab.id
                      ? "bg-primary border-primary text-primary-foreground shadow-md shadow-primary/20"
                      : "bg-background border-border text-muted-foreground hover:text-foreground"
                  }`}
                >
                  {tab.label}
                </button>
              ))}
            </div>
          </div>

          <AnimatePresence mode="wait">
            <motion.div
              key={activeGalleryTab}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.25 }}
              className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center"
            >
              <div className="lg:col-span-5 space-y-6">
                <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-primary/10 text-primary border border-primary/20">
                  <Sparkles className="w-3.5 h-3.5" />
                  <span>Feature Mockup Map</span>
                </div>
                
                <h4 className="text-2xl font-black text-foreground">
                  {galleryContent[activeGalleryTab].title}
                </h4>
                
                <p className="text-sm sm:text-base text-muted-foreground leading-relaxed">
                  {galleryContent[activeGalleryTab].desc}
                </p>

                <div className="space-y-2.5 pt-4 border-t border-border">
                  {galleryContent[activeGalleryTab].details.map((det) => (
                    <div key={det} className="flex items-center gap-2.5 text-xs text-muted-foreground">
                      <CheckCircle2 className="w-4 h-4 text-success" />
                      <span>{det}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Wireframe Mockup Visual Terminal */}
              <div className="lg:col-span-7 bg-black rounded-2xl border border-border p-6 shadow-2xl overflow-x-auto">
                <pre className="font-mono text-xs text-primary leading-relaxed select-none">
                  <code>{galleryContent[activeGalleryTab].mock}</code>
                </pre>
              </div>
            </motion.div>
          </AnimatePresence>
        </div>
      </div>
    </section>
  );
}
