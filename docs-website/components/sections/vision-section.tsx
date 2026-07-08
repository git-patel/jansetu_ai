"use client";

import React from "react";
import { motion } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import {
  AlertTriangle,
  CheckCircle2,
  Sparkles,
  Target,
  Eye,
  ShieldAlert,
  HelpCircle,
  FileSpreadsheet,
  TrendingUp,
  BrainCircuit,
  MessageSquare,
} from "lucide-react";

export function VisionSection() {
  const problems = [
    {
      title: "Scattered & Unstructured Feedback",
      desc: "Traditional systems rely on rigid government forms where citizens must guess technical departments and legal categories.",
      icon: FileSpreadsheet,
    },
    {
      title: "Duplicate & Redundant Complaints",
      desc: "Thousands of citizens report the exact same pothole or water leak independently, overwhelming municipal databases.",
      icon: AlertTriangle,
    },
    {
      title: "Political Bias & Lack of Prioritization",
      desc: "Without automated severity scoring, development projects are often chosen by political influence rather than public urgency.",
      icon: ShieldAlert,
    },
    {
      title: "Zero Public Tracking & Transparency",
      desc: "Citizens rarely receive verification after submitting a grievance, leading to widespread cynicism and lack of community trust.",
      icon: HelpCircle,
    },
  ];

  const solutions = [
    {
      title: "AI-First Natural Language Intelligence",
      desc: "Citizens simply speak or upload photos in any Indian language. Gemini AI automatically categorizes, translates, and formats requests.",
      icon: BrainCircuit,
    },
    {
      title: "Automated Duplicate Aggregation",
      desc: "Spatial AI clusters identical local issues together, turning 500 individual complaints into 1 unified, highly-supported community project.",
      icon: CheckCircle2,
    },
    {
      title: "Evidence-Based Priority Engine",
      desc: "Projects are ranked on a 0-100 severity scale using demographic census data, infrastructure gap analysis, and community voting.",
      icon: TrendingUp,
    },
    {
      title: "End-to-End Living Digital Twin",
      desc: "Every approved project is publicly tracked from MP sanctioning to contractor milestone billing and GPS officer field verification.",
      icon: Eye,
    },
  ];

  return (
    <section id="vision" className="py-24 relative overflow-hidden bg-muted/20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Vision & Philosophy"
          title="Why Governance Needs Artificial Intelligence"
          subtitle="JanSetu AI is NOT a traditional complaint management ticket system. It is an intelligent Constituency Development Decision Support Platform."
        />

        {/* Core Philosophy Banner */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="glass-panel rounded-3xl p-8 md:p-12 mb-20 border border-primary/30 shadow-2xl relative overflow-hidden bg-gradient-to-br from-background via-background to-primary/5"
        >
          <div className="absolute top-0 right-0 w-80 h-80 bg-primary/10 rounded-full blur-3xl pointer-events-none" />
          
          <div className="max-w-3xl space-y-6">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-primary text-primary-foreground shadow-md">
              <Sparkles className="w-3.5 h-3.5" />
              <span>The Fundamental Law of JanSetu AI</span>
            </div>
            
            <h3 className="text-2xl md:text-3xl lg:text-4xl font-black text-foreground tracking-tight leading-snug">
              &quot;Citizens should never need to understand government departments.&quot;
            </h3>
            
            <p className="text-base md:text-lg text-muted-foreground leading-relaxed">
              Citizens simply describe what they see, what they experience, and what their neighborhood needs. Our automated AI engine is responsible for understanding everything else—mapping syntax to legal budgets, identifying municipal ward jurisdictions, estimating material costs, and generating executive summaries for elected representatives.
            </p>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-4">
              {[
                { label: "No Long Forms", value: "Voice & Photo First" },
                { label: "Community Driven", value: "Collaborative Voting" },
                { label: "Public Transparency", value: "100% Trackable Work" },
              ].map((item, idx) => (
                <div key={idx} className="p-4 rounded-2xl bg-background/80 border border-border/80 shadow-sm">
                  <span className="block text-xs font-semibold text-muted-foreground uppercase tracking-wider">{item.label}</span>
                  <span className="text-sm font-bold text-foreground mt-0.5 block">{item.value}</span>
                </div>
              ))}
            </div>
          </div>
        </motion.div>

        {/* Comparison Grid: Old vs New */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
          {/* Old Way */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="glass-card rounded-3xl p-8 border border-danger/20 bg-gradient-to-b from-background to-danger/[0.02]"
          >
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-border">
              <div className="p-3 rounded-2xl bg-danger/10 text-danger">
                <AlertTriangle className="w-6 h-6" />
              </div>
              <div>
                <h4 className="text-xl font-bold text-foreground">Traditional Governance Systems</h4>
                <p className="text-xs text-muted-foreground">Why existing portals fail citizen engagement</p>
              </div>
            </div>

            <div className="space-y-6">
              {problems.map((prob, idx) => {
                const Icon = prob.icon;
                return (
                  <div key={idx} className="flex gap-4">
                    <div className="mt-1 p-2 rounded-xl bg-danger/10 text-danger shrink-0 h-fit">
                      <Icon className="w-4 h-4" />
                    </div>
                    <div>
                      <h5 className="font-semibold text-foreground text-sm">{prob.title}</h5>
                      <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{prob.desc}</p>
                    </div>
                  </div>
                );
              })}
            </div>
          </motion.div>

          {/* JanSetu AI Way */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="glass-card rounded-3xl p-8 border border-primary/30 bg-gradient-to-b from-background via-background to-primary/[0.04] shadow-xl"
          >
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-border">
              <div className="p-3 rounded-2xl bg-primary/10 text-primary">
                <Sparkles className="w-6 h-6" />
              </div>
              <div>
                <h4 className="text-xl font-bold text-foreground">The JanSetu AI Intelligence Platform</h4>
                <p className="text-xs text-muted-foreground">How artificial intelligence enables smart democracy</p>
              </div>
            </div>

            <div className="space-y-6">
              {solutions.map((sol, idx) => {
                const Icon = sol.icon;
                return (
                  <div key={idx} className="flex gap-4">
                    <div className="mt-1 p-2 rounded-xl bg-primary/10 text-primary shrink-0 h-fit">
                      <Icon className="w-4 h-4" />
                    </div>
                    <div>
                      <h5 className="font-semibold text-foreground text-sm">{sol.title}</h5>
                      <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{sol.desc}</p>
                    </div>
                  </div>
                );
              })}
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
