"use client";

import React from "react";
import { motion } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import {
  Globe,
  MapPin,
  Building2,
  Sparkles,
  CheckCircle2,
  Clock,
  ArrowRight,
  TrendingUp,
  Activity,
  ShieldAlert,
} from "lucide-react";

export function RoadmapSection() {
  const roadmapPhases = [
    {
      phase: "Phase 1: Hackathon & MVP Foundation",
      status: "COMPLETED",
      timeframe: "Q3 2026",
      color: "bg-success text-white",
      borderColor: "border-success/30 bg-success/[0.03]",
      items: [
        "Core Flutter Citizen App with 22-language voice and photo reporting",
        "Google Gemini 2.5 Pro integration for automatic title generation and categorization",
        "Geospatial 500m duplicate detection and community upvoting engine",
        "MP Decision Support Dashboard with objective 0-100 severity ranking",
      ],
    },
    {
      phase: "Phase 2: Municipal & Officer Portal Expansion",
      status: "IN PROGRESS",
      timeframe: "Q4 2026",
      color: "bg-primary text-white",
      borderColor: "border-primary/40 bg-primary/[0.04]",
      items: [
        "Government Officer verification portal with GPS geofenced site inspection rules",
        "Contractor milestone billing workflow tied to physical engineering sign-offs",
        "Offline-first SQLite/Hive caching for rural zero-connectivity field reporting",
        "Automated push notification engine keeping citizens informed at every step",
      ],
    },
    {
      phase: "Phase 3: National Scale & Dataset Integration",
      status: "PLANNED",
      timeframe: "Q1-Q2 2027",
      color: "bg-amber-500 text-white",
      borderColor: "border-amber-500/30 bg-amber-500/[0.03]",
      items: [
        "Ingestion of historical census data, PWD asset registries, and municipal budget sheets",
        "Onboarding of all 543 Indian Parliamentary Constituencies and state legislative assemblies",
        "Advanced predictive AI estimating infrastructure decay before citizen complaints occur",
        "Public blockchain audit ledger ensuring zero tampering with municipal project spending",
      ],
    },
    {
      phase: "Phase 4: Universal Constituency Digital Twin",
      status: "LONG TERM VISION",
      timeframe: "2027 - 2028+",
      color: "bg-purple-600 text-white",
      borderColor: "border-purple-500/30 bg-purple-500/[0.03]",
      items: [
        "Living 3D spatial digital representation of every Indian ward, village, town, and city",
        "Real-time sensor & citizen IoT integration monitoring water pressure, street lights, and drainage",
        "Automated AI Development Score calculated dynamically for every elected representative",
        "Simulated budget impact modeling allowing MPs to test 5-year development plans virtually",
      ],
    },
  ];

  const digitalTwinAssets = [
    "Population Demographics", "Road Network & Quality", "Primary & Secondary Schools",
    "Government Colleges", "Public Hospitals & PHCs", "Municipal Water Tanks",
    "Public Sanitation Units", "Electrical Sub-stations", "Fiber Internet Nodes",
    "Government Assets & Land", "Allocated Ward Budgets", "Ongoing Civil Projects",
    "Completed Work Archives", "Historical Maintenance Logs", "Citizen Satisfaction Score",
    "AI Development Score",
  ];

  return (
    <section id="roadmap" className="py-24 relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Future Roadmap & Expansion"
          title="The Universal Constituency Digital Twin"
          subtitle="Our long-term architectural vision: building a living, real-time digital representation of every infrastructure asset across all 543 Indian parliamentary constituencies."
        />

        {/* Digital Twin Showcase Grid */}
        <div className="glass-panel rounded-3xl p-8 lg:p-12 mb-20 border border-primary/30 shadow-2xl relative overflow-hidden bg-gradient-to-br from-background via-background to-primary/[0.05]">
          <div className="absolute top-0 right-0 w-96 h-96 bg-primary/10 rounded-full blur-3xl pointer-events-none" />

          <div className="max-w-3xl mb-8">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-primary/10 text-primary border border-primary/20 mb-3">
              <Activity className="w-3.5 h-3.5 animate-pulse" />
              <span>Living Infrastructure Intelligence</span>
            </div>
            <h3 className="text-2xl md:text-3xl font-black text-foreground tracking-tight">
              What is a Constituency Digital Twin?
            </h3>
            <p className="text-sm md:text-base text-muted-foreground mt-2 leading-relaxed">
              Instead of static annual government reports, JanSetu AI maintains a continuous, real-time database of every physical asset inside a constituency. When a citizen reports a broken water pipe, the AI immediately cross-references the pipeline&apos;s installation date, previous repair bills, and surrounding population density to formulate an objective recommendation.
            </p>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-8 gap-3">
            {digitalTwinAssets.map((asset, idx) => (
              <div
                key={idx}
                className="p-3 rounded-xl bg-background/90 border border-border/80 shadow-xs flex flex-col justify-center items-center text-center group hover:border-primary/50 transition-all"
              >
                <div className="w-2 h-2 rounded-full bg-primary mb-2 group-hover:scale-150 transition-transform" />
                <span className="text-[11px] font-semibold text-foreground leading-tight">
                  {asset}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Chronological Roadmap Timeline */}
        <div className="space-y-8 relative before:absolute before:inset-0 before:left-6 md:before:left-1/2 before:-translate-x-px before:h-full before:w-0.5 before:bg-gradient-to-b before:from-primary before:via-accent before:to-transparent">
          {roadmapPhases.map((phase, idx) => {
            const isEven = idx % 2 === 0;
            return (
              <motion.div
                key={idx}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.1 }}
                className={`relative flex items-start md:justify-between gap-6 ${
                  isEven ? "md:flex-row" : "md:flex-row-reverse"
                }`}
              >
                {/* Center Timeline Node */}
                <div className="absolute left-6 md:left-1/2 -translate-x-1/2 w-8 h-8 rounded-full bg-background border-4 border-primary shadow-lg z-10 flex items-center justify-center">
                  <div className="w-2.5 h-2.5 rounded-full bg-primary animate-ping" />
                </div>

                {/* Content Card */}
                <div className={`w-full md:w-[46%] pl-14 md:pl-0 ${isEven ? "md:pr-12 text-left" : "md:pl-12 text-left"}`}>
                  <div className={`glass-card rounded-3xl p-8 border shadow-lg ${phase.borderColor}`}>
                    <div className="flex flex-wrap items-center justify-between gap-2 mb-4 pb-4 border-b border-border/60">
                      <span className="text-xs font-mono font-bold text-muted-foreground">
                        {phase.timeframe}
                      </span>
                      <span className={`px-3 py-1 rounded-full text-[10px] font-black tracking-wider ${phase.color} shadow-xs`}>
                        {phase.status}
                      </span>
                    </div>

                    <h4 className="text-xl font-bold text-foreground mb-4">
                      {phase.phase}
                    </h4>

                    <ul className="space-y-2.5">
                      {phase.items.map((item, iIdx) => (
                        <li key={iIdx} className="flex items-start gap-2.5 text-xs sm:text-sm text-foreground font-medium">
                          <CheckCircle2 className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                          <span>{item}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>

                {/* Empty Spacer for alternating layout */}
                <div className="hidden md:block md:w-[46%]" />
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
