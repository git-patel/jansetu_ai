"use client";

import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import {
  Smartphone,
  LayoutDashboard,
  ShieldCheck,
  HardHat,
  Settings,
  Users,
  CheckCircle2,
  ArrowUpRight,
  MapPin,
  Sparkles,
  BarChart3,
  FileText,
  Activity,
} from "lucide-react";

export function ModulesSection() {
  const [activeTab, setActiveTab] = useState<number>(0);

  const modules = [
    {
      id: "citizen-app",
      title: "1. Citizen Mobile App",
      shortTitle: "Citizen App",
      icon: Smartphone,
      color: "text-blue-500 bg-blue-500/10 border-blue-500/20",
      desc: "The public entry point for Indian citizens. Powered by Flutter, offering zero-training voice and photo grievance submission with automatic GPS validation.",
      features: [
        "Dual-Identity Model: Home constituency voting vs current physical GPS location reporting",
        "Multimodal input: Spoken voice recording, photos, videos, and PDF evidence upload",
        "AI confirmation screen: Instant verification of generated technical titles and severity scores",
        "Community upvoting & comment discussion on existing neighborhood development needs",
        "Real-time push notifications tracking project milestones from tender to completion",
      ],
      stats: { primary: "22 Languages", secondary: "Voice-First NLP" },
    },
    {
      id: "community-hub",
      title: "2. Community Development Hub",
      shortTitle: "Community Hub",
      icon: Users,
      color: "text-teal-500 bg-teal-500/10 border-teal-500/20",
      desc: "Not a noisy social media feed—this is a structured development intelligence feed displaying vetted, deduplicated community priorities.",
      features: [
        "AI-Generated executive engineering titles and objective 30-word problem summaries",
        "Real-time severity ranking badge (Critical, High, Medium, Low) and infrastructure category",
        "Live community support counter showing verified neighborhood constituent endorsement",
        "Transparent government status badge (Under Review, Officer Dispatched, Approved, Tendered)",
        "AI-predicted estimated material budget and total expected household beneficiaries",
      ],
      stats: { primary: "87% Fewer Diffs", secondary: "Deduplicated Feed" },
    },
    {
      id: "mp-dashboard",
      title: "3. MP Decision Support Dashboard",
      shortTitle: "MP Dashboard",
      icon: LayoutDashboard,
      color: "text-indigo-500 bg-indigo-500/10 border-indigo-500/20",
      desc: "The command center for Members of Parliament. Replaces scattered paper complaints with ranked AI priorities and geospatial heatmaps.",
      features: [
        "Geospatial infrastructure heatmap highlighting urgent ward deficits across the constituency",
        "AI Priority Ranking table sorting proposals by objective census urgency and community support",
        "One-click project approval or rejection with mandatory public explanation log",
        "Direct field verification dispatch commanding local officers to conduct GPS site inspections",
        "Real-time budget allocation monitoring and monthly parliamentary progress reporting",
      ],
      stats: { primary: "100% Objective", secondary: "Zero Political Bias" },
    },
    {
      id: "officer-portal",
      title: "4. Government Officer Portal",
      shortTitle: "Officer Dashboard",
      icon: ShieldCheck,
      color: "text-purple-500 bg-purple-500/10 border-purple-500/20",
      desc: "Dedicated verification portal for municipal engineers and field inspection officers to ground-truth civic complaints before fund sanctioning.",
      features: [
        "Assigned verification queue sorted by geographic proximity and AI urgency score",
        "Mandatory GPS-verified on-site inspection rules preventing fraudulent remote sign-offs",
        "Geotagged before-and-after photo evidence upload with automated timestamp validation",
        "Formal verification engineering report generation and cost adjustment recommendations",
        "Final project completion certificate issuance triggering public community celebration",
      ],
      stats: { primary: "GPS Geofenced", secondary: "Zero Remote Fraud" },
    },
    {
      id: "contractor-portal",
      title: "5. Contractor Execution Portal",
      shortTitle: "Contractor Portal",
      icon: HardHat,
      color: "text-amber-500 bg-amber-500/10 border-amber-500/20",
      desc: "A transparent project execution dashboard for assigned government contractors to log milestones and request formal billing sign-offs.",
      features: [
        "Assigned infrastructure projects overview with contractual deadline countdowns",
        "Milestone-by-milestone work progress logging with mandatory live material photos",
        "Transparent bill upload and invoice verification tied to officer physical inspection",
        "Detailed raw material specification logging (grade of cement, pipeline dimensions)",
        "Automated completion inspection requests dispatching municipal engineers to site",
      ],
      stats: { primary: "Milestone Billing", secondary: "Auditable Ledger" },
    },
    {
      id: "admin-dashboard",
      title: "6. Super Admin & AI Monitoring",
      shortTitle: "Admin Dashboard",
      icon: Settings,
      color: "text-rose-500 bg-rose-500/10 border-rose-500/20",
      desc: "Platform management console for system administrators to oversee AI accuracy, ingest government datasets, and manage constituency mappings.",
      features: [
        "User role & constituency boundary management covering all 543 Indian parliamentary seats",
        "Public dataset ingestion (Census data, PWD asset registries, municipal budget sheets)",
        "Google Gemini AI model monitoring, prompt optimization, and classification accuracy logs",
        "Automated spam, duplicate, and abusive content moderation filters",
        "System-wide performance analytics, audit trails, and Firestore security rule compliance",
      ],
      stats: { primary: "99.9% Uptime", secondary: "Cloud Native Scaled" },
    },
  ];

  return (
    <section id="modules" className="py-24 relative overflow-hidden bg-muted/30">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Ecosystem Architecture"
          title="6 Comprehensive Product Modules"
          subtitle="A specialized interface designed for every stakeholder in the governance lifecycle—from citizens reporting potholes to MPs sanctioning multi-lakh budgets."
        />

        {/* Module Selection Navigation Tabs */}
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3 mb-12">
          {modules.map((mod, idx) => {
            const Icon = mod.icon;
            const isActive = activeTab === idx;
            return (
              <button
                key={mod.id}
                onClick={() => setActiveTab(idx)}
                className={`p-4 rounded-2xl border transition-all duration-300 text-left flex flex-col justify-between h-28 group ${
                  isActive
                    ? "glass-card border-primary shadow-lg bg-primary/[0.06] scale-[1.02]"
                    : "bg-background/70 border-border/70 hover:bg-background hover:border-border"
                }`}
              >
                <div className="flex items-center justify-between w-full">
                  <div className={`p-2 rounded-xl ${mod.color}`}>
                    <Icon className="w-5 h-5" />
                  </div>
                  <span className="text-[10px] font-mono font-bold text-muted-foreground">
                    0{idx + 1}
                  </span>
                </div>
                <span
                  className={`font-bold text-xs sm:text-sm tracking-tight block ${
                    isActive ? "text-primary" : "text-foreground"
                  }`}
                >
                  {mod.shortTitle}
                </span>
              </button>
            );
          })}
        </div>

        {/* Active Module Detailed Showcase Card */}
        <AnimatePresence mode="wait">
          {modules.map((mod, idx) => {
            if (idx !== activeTab) return null;
            const Icon = mod.icon;
            return (
              <motion.div
                key={mod.id}
                initial={{ opacity: 0, y: 15 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -15 }}
                transition={{ duration: 0.35, ease: "easeOut" }}
                className="glass-card rounded-3xl p-8 lg:p-12 border border-primary/30 shadow-2xl relative overflow-hidden bg-gradient-to-br from-background via-background to-primary/[0.04]"
              >
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
                  {/* Left Column: Descriptions and Stats */}
                  <div className="lg:col-span-7 space-y-6">
                    <div className="flex items-center gap-3">
                      <div className={`p-3.5 rounded-2xl ${mod.color} shadow-sm`}>
                        <Icon className="w-7 h-7" />
                      </div>
                      <div>
                        <span className="text-xs font-mono uppercase font-bold text-primary tracking-wider">
                          Module Specification
                        </span>
                        <h3 className="text-2xl sm:text-3xl font-black text-foreground">
                          {mod.title}
                        </h3>
                      </div>
                    </div>

                    <p className="text-base sm:text-lg text-muted-foreground leading-relaxed">
                      {mod.desc}
                    </p>

                    <div className="grid grid-cols-2 gap-4 pt-2">
                      <div className="p-4 rounded-2xl bg-background border border-border shadow-sm">
                        <span className="text-2xl font-extrabold text-foreground block">
                          {mod.stats.primary}
                        </span>
                        <span className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                          Capability Target
                        </span>
                      </div>
                      <div className="p-4 rounded-2xl bg-background border border-border shadow-sm">
                        <span className="text-2xl font-extrabold text-primary block">
                          {mod.stats.secondary}
                        </span>
                        <span className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                          Architectural Standard
                        </span>
                      </div>
                    </div>
                  </div>

                  {/* Right Column: Key Feature Specifications Check-list */}
                  <div className="lg:col-span-5 bg-background/80 rounded-2xl p-6 lg:p-8 border border-border/80 shadow-md space-y-4">
                    <h4 className="font-bold text-sm uppercase tracking-wider text-foreground flex items-center gap-2 pb-3 border-b border-border">
                      <Sparkles className="w-4 h-4 text-primary" />
                      <span>Key Architectural Features</span>
                    </h4>
                    <div className="space-y-3.5">
                      {mod.features.map((feat, fIdx) => (
                        <div key={fIdx} className="flex items-start gap-3">
                          <div className="p-1 rounded-md bg-success/15 text-success shrink-0 mt-0.5">
                            <CheckCircle2 className="w-3.5 h-3.5" />
                          </div>
                          <span className="text-xs sm:text-sm text-foreground font-medium leading-relaxed">
                            {feat}
                          </span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </motion.div>
            );
          })}
        </AnimatePresence>
      </div>
    </section>
  );
}
