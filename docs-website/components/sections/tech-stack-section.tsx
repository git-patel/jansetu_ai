"use client";

import React from "react";
import { motion } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import {
  Smartphone,
  Cloud,
  Brain,
  Database,
  Map,
  Layers,
  ShieldCheck,
  Zap,
  ArrowUpRight,
  Code2,
  Server,
  Lock,
} from "lucide-react";

export function TechStackSection() {
  const technologies = [
    {
      name: "Flutter & Dart",
      category: "Cross-Platform Frontend",
      icon: Smartphone,
      color: "from-blue-500 to-cyan-500",
      desc: "Delivers a native, high-performance 60 FPS user experience across Android, iOS, and Web from a single production codebase.",
      highlights: ["Material 3 Design", "Offline-First Caching", "Voice/Photo Recording"],
    },
    {
      name: "Google Gemini 2.5 Pro",
      category: "Artificial Intelligence Engine",
      icon: Brain,
      color: "from-purple-500 to-indigo-500",
      desc: "Multimodal large language model responsible for understanding citizen speech, translating dialects, entity extraction, and severity scoring.",
      highlights: ["Multimodal Vision NLP", "Zero-Shot Categorization", "0-100 Priority Engine"],
    },
    {
      name: "Firebase Cloud Functions",
      category: "Serverless Backend",
      icon: Cloud,
      color: "from-amber-500 to-orange-500",
      desc: "Event-driven TypeScript microservices handling asynchronous AI prompting, duplicate clustering algorithms, and notification dispatch.",
      highlights: ["Node.js Serverless", "Auto-Scaling Compute", "Audit Log Processing"],
    },
    {
      name: "Cloud Firestore",
      category: "Real-time NoSQL Database",
      icon: Database,
      color: "from-orange-500 to-red-500",
      desc: "Real-time document database structuring citizen profiles, development needs, contractor milestones, and constituency digital twins.",
      highlights: ["Real-time Data Sync", "Strict Security Rules", "Geospatial Queries"],
    },
    {
      name: "Google Maps Platform",
      category: "Geospatial Intelligence",
      icon: Map,
      color: "from-emerald-500 to-teal-500",
      desc: "Provides precision geofencing, municipal ward boundary mapping, spatial duplicate detection, and constituency infrastructure heatmaps.",
      highlights: ["Geofenced Inspections", "Heatmap Rendering", "Reverse Geocoding"],
    },
    {
      name: "Riverpod & MVVM",
      category: "Clean Architecture State",
      icon: Layers,
      color: "from-teal-500 to-blue-500",
      desc: "Strict adherence to Clean Architecture principles using Repository pattern, Dependency Injection, and reactive state management.",
      highlights: ["Compile-Safe DI", "MVVM Separation", "Testable Mock Layers"],
    },
  ];

  const architecturalPillars = [
    { title: "Offline-First Architecture", desc: "View cached feeds, save draft reports locally, queue uploads, and automatically retry sync when connection restores.", icon: Zap },
    { title: "Role-Based Access Control", desc: "Strict Firestore Security Rules isolating Citizen, MP, Officer, Contractor, and Admin data permissions.", icon: Lock },
    { title: "Production Ready SOLID Code", desc: "Zero demo shortcuts. Comprehensive loading, error, empty, offline, and success states across every screen.", icon: Code2 },
  ];

  return (
    <section className="py-24 relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Technology Stack"
          title="Engineered for Billion-Scale Governance"
          subtitle="Built on enterprise-grade cloud native infrastructure and modern mobile frameworks to ensure high availability, zero latency, and absolute data security."
        />

        {/* Tech Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
          {technologies.map((tech, idx) => {
            const Icon = tech.icon;
            return (
              <motion.div
                key={tech.name}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.1 }}
                className="glass-card rounded-3xl p-8 border border-border/80 hover:border-primary/50 transition-all duration-300 flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center justify-between mb-6">
                    <div className={`p-4 rounded-2xl bg-gradient-to-br ${tech.color} text-white shadow-lg group-hover:scale-110 transition-transform duration-300`}>
                      <Icon className="w-7 h-7" />
                    </div>
                    <span className="text-xs font-mono uppercase tracking-wider font-semibold px-3 py-1 rounded-full bg-muted text-muted-foreground border border-border">
                      {tech.category}
                    </span>
                  </div>

                  <h3 className="text-2xl font-bold text-foreground mb-3 tracking-tight group-hover:text-primary transition-colors">
                    {tech.name}
                  </h3>
                  <p className="text-sm text-muted-foreground leading-relaxed mb-6">
                    {tech.desc}
                  </p>
                </div>

                <div className="pt-6 border-t border-border/60 flex flex-wrap gap-2">
                  {tech.highlights.map((h, hIdx) => (
                    <span
                      key={hIdx}
                      className="px-2.5 py-1 rounded-lg bg-background/80 text-foreground text-xs font-medium border border-border/60 shadow-xs"
                    >
                      ✓ {h}
                    </span>
                  ))}
                </div>
              </motion.div>
            );
          })}
        </div>

        {/* Architectural Pillars Banner */}
        <div className="glass-panel rounded-3xl p-8 lg:p-12 border border-primary/30 shadow-xl bg-gradient-to-r from-background via-primary/[0.03] to-background">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {architecturalPillars.map((pillar, idx) => {
              const Icon = pillar.icon;
              return (
                <div key={idx} className="space-y-3">
                  <div className="flex items-center gap-3">
                    <div className="p-2.5 rounded-xl bg-primary/10 text-primary">
                      <Icon className="w-5 h-5" />
                    </div>
                    <h4 className="font-bold text-lg text-foreground tracking-tight">{pillar.title}</h4>
                  </div>
                  <p className="text-xs sm:text-sm text-muted-foreground leading-relaxed">
                    {pillar.desc}
                  </p>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}
