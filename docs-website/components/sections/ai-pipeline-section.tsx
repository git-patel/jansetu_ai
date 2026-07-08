"use client";

import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import {
  Mic,
  Brain,
  FileText,
  Layers,
  BarChart3,
  Lightbulb,
  CheckSquare,
  HardHat,
  Eye,
  ArrowRight,
  Sparkles,
  ShieldCheck,
  Zap,
} from "lucide-react";

export function AiPipelineSection() {
  const [activeStep, setActiveStep] = useState<number>(0);

  const steps = [
    {
      id: "citizen",
      title: "1. Citizen Multimodal Input",
      shortTitle: "Citizen Input",
      icon: Mic,
      color: "from-blue-500 to-indigo-500",
      badgeColor: "bg-blue-500/10 text-blue-500 border-blue-500/20",
      desc: "Citizens submit development requests using natural spoken voice, text, photos, or video in any of 22 official Indian languages without needing to select a government department.",
      details: [
        "Real-time Speech recognition & noise removal",
        "Automatic language detection & seamless dialect translation",
        "GPS validation matching verified home constituency identity",
      ],
    },
    {
      id: "ai-understanding",
      title: "2. Context Understanding & NLP",
      shortTitle: "AI Understanding",
      icon: Brain,
      color: "from-indigo-500 to-purple-500",
      badgeColor: "bg-indigo-500/10 text-indigo-500 border-indigo-500/20",
      desc: "Google Gemini AI analyzes the underlying sentiment, urgency, and civic infrastructure context of the report, filtering out spam or political trolling.",
      details: [
        "Entity extraction (landmarks, street names, school names)",
        "Image & video damage assessment using computer vision",
        "Geospatial coordinate mapping against municipal ward borders",
      ],
    },
    {
      id: "summarization",
      title: "3. Automated Summarization",
      shortTitle: "Summarization",
      icon: FileText,
      color: "from-purple-500 to-pink-500",
      badgeColor: "bg-purple-500/10 text-purple-500 border-purple-500/20",
      desc: "Raw, emotional citizen narratives are transformed into crisp, professional engineering titles and objective technical problem summaries.",
      details: [
        "Generates formal executive titles for parliamentary review",
        "Summarizes core problem statement in under 30 words",
        "Strips redundant emotional repetition while preserving facts",
      ],
    },
    {
      id: "classification",
      title: "4. Domain & Category Classification",
      shortTitle: "Classification",
      icon: Layers,
      color: "from-pink-500 to-rose-500",
      badgeColor: "bg-pink-500/10 text-pink-500 border-pink-500/20",
      desc: "The request is automatically tagged into one of 12 primary development domains (Roads, Water, Healthcare, Education) and 64 technical subcategories.",
      details: [
        "Maps direct responsibility to local municipal or state departments",
        "Checks for existing duplicate reports within a 500-meter radius",
        "Aggregates community upvotes onto primary master request",
      ],
    },
    {
      id: "priority-engine",
      title: "5. AI Priority Scoring Engine",
      shortTitle: "Priority Engine",
      icon: BarChart3,
      color: "from-rose-500 to-orange-500",
      badgeColor: "bg-rose-500/10 text-rose-500 border-rose-500/20",
      desc: "An objective 0-100 severity score is calculated based on historical census data, infrastructure deficit heatmaps, and community support density.",
      details: [
        "Cross-references local public asset age and maintenance logs",
        "Evaluates safety hazards (e.g., open drainage near primary schools)",
        "Eliminates political favoritism through transparent AI algorithm",
      ],
    },
    {
      id: "recommendation",
      title: "6. Budget & Impact Recommendation",
      shortTitle: "Recommendation",
      icon: Lightbulb,
      color: "from-orange-500 to-amber-500",
      badgeColor: "bg-orange-500/10 text-orange-500 border-orange-500/20",
      desc: "The AI acts as a senior development planning officer, predicting expected beneficiary counts and estimating required material budgets.",
      details: [
        "Estimates approximate cost based on historical regional tenders",
        "Predicts exact number of impacted households or school children",
        "Generates formal proposal ready for MP sanctioning",
      ],
    },
    {
      id: "mp-dashboard",
      title: "7. MP Sanction & Approval",
      shortTitle: "MP Dashboard",
      icon: CheckSquare,
      color: "from-amber-500 to-emerald-500",
      badgeColor: "bg-amber-500/10 text-amber-500 border-amber-500/20",
      desc: "The Member of Parliament reviews a ranked intelligence dashboard, approving proposals or requesting immediate field verification from local officers.",
      details: [
        "One-click project sanctioning with automated budget allocation",
        "Dispatches inspection orders to field engineers with GPS rules",
        "Publishes monthly development progress reports to constituents",
      ],
    },
    {
      id: "project-execution",
      title: "8. Contractor & Milestone Tracking",
      shortTitle: "Project Execution",
      icon: HardHat,
      color: "from-emerald-500 to-teal-500",
      badgeColor: "bg-emerald-500/10 text-emerald-500 border-emerald-500/20",
      desc: "Approved projects enter the tender lifecycle where contractors upload geotagged material proof and milestone completion certificates.",
      details: [
        "Contractor bill verification via automated image timestamp checks",
        "Field officer physical inspection sign-off before fund release",
        "Real-time schedule monitoring against proposed deadlines",
      ],
    },
    {
      id: "transparency",
      title: "9. Public Transparency & Digital Twin",
      shortTitle: "Transparency",
      icon: Eye,
      color: "from-teal-500 to-cyan-500",
      badgeColor: "bg-teal-500/10 text-teal-500 border-teal-500/20",
      desc: "The constituency Digital Twin is updated permanently. Citizens receive automated SMS/push alerts celebrating completed neighborhood upgrades.",
      details: [
        "Living public asset map accessible to every citizen",
        "Post-completion satisfaction surveys & maintenance tracking",
        "Auditable governance blockchain log for maximum public trust",
      ],
    },
  ];

  return (
    <section id="ai-pipeline" className="py-24 relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="End-to-End Intelligence Flow"
          title="The JanSetu AI Processing Pipeline"
          subtitle="How artificial intelligence acts as an experienced development officer, transforming raw voice complaints into transparent infrastructure execution."
        />

        {/* Interactive Timeline Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Left Step Selector List */}
          <div className="lg:col-span-5 space-y-2 max-h-[600px] overflow-y-auto pr-2 custom-scrollbar">
            {steps.map((step, idx) => {
              const Icon = step.icon;
              const isActive = activeStep === idx;
              return (
                <motion.button
                  key={step.id}
                  onClick={() => setActiveStep(idx)}
                  whileHover={{ scale: 1.01 }}
                  className={`w-full text-left p-4 rounded-2xl border transition-all duration-300 flex items-center justify-between ${
                    isActive
                      ? "glass-card border-primary shadow-lg bg-primary/[0.05]"
                      : "bg-background/60 border-border/60 hover:border-border hover:bg-muted/40"
                  }`}
                >
                  <div className="flex items-center gap-3.5">
                    <div
                      className={`p-2.5 rounded-xl bg-gradient-to-br ${step.color} text-white shadow-sm shrink-0`}
                    >
                      <Icon className="w-5 h-5" />
                    </div>
                    <div>
                      <span
                        className={`text-xs font-mono font-bold block ${
                          isActive ? "text-primary" : "text-muted-foreground"
                        }`}
                      >
                        STEP 0{idx + 1}
                      </span>
                      <h4 className="font-bold text-sm sm:text-base text-foreground">
                        {step.shortTitle}
                      </h4>
                    </div>
                  </div>
                  <div
                    className={`w-2 h-8 rounded-full transition-all ${
                      isActive ? "bg-primary" : "bg-transparent"
                    }`}
                  />
                </motion.button>
              );
            })}
          </div>

          {/* Right Detailed Step Card */}
          <div className="lg:col-span-7 sticky top-28">
            <AnimatePresence mode="wait">
              {steps.map((step, idx) => {
                if (idx !== activeStep) return null;
                const Icon = step.icon;
                return (
                  <motion.div
                    key={step.id}
                    initial={{ opacity: 0, y: 15, scale: 0.98 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: -15, scale: 0.98 }}
                    transition={{ duration: 0.35, ease: "easeOut" }}
                    className="glass-card rounded-3xl p-8 lg:p-10 border border-primary/30 shadow-2xl relative overflow-hidden bg-gradient-to-br from-background via-background to-primary/[0.03]"
                  >
                    <div
                      className={`absolute top-0 right-0 w-64 h-64 bg-gradient-to-br ${step.color} opacity-10 rounded-full blur-3xl pointer-events-none`}
                    />

                    <div className="flex items-center justify-between mb-6 pb-6 border-b border-border">
                      <div className="flex items-center gap-4">
                        <div
                          className={`p-4 rounded-2xl bg-gradient-to-br ${step.color} text-white shadow-lg`}
                        >
                          <Icon className="w-8 h-8" />
                        </div>
                        <div>
                          <span
                            className={`px-3 py-1 rounded-full text-xs font-bold ${step.badgeColor} border`}
                          >
                            PHASE 0{idx + 1} OF 09
                          </span>
                          <h3 className="text-2xl font-black text-foreground mt-2">
                            {step.title}
                          </h3>
                        </div>
                      </div>
                    </div>

                    <p className="text-base md:text-lg text-foreground font-medium leading-relaxed mb-8">
                      {step.desc}
                    </p>

                    <div className="space-y-4">
                      <h5 className="text-xs font-bold uppercase tracking-wider text-muted-foreground flex items-center gap-1.5">
                        <Sparkles className="w-4 h-4 text-primary" />
                        <span>Core Technical Capabilities</span>
                      </h5>
                      <div className="space-y-3">
                        {step.details.map((detail, dIdx) => (
                          <div
                            key={dIdx}
                            className="flex items-start gap-3 p-3.5 rounded-xl bg-background/80 border border-border/60 shadow-sm"
                          >
                            <ShieldCheck className="w-5 h-5 text-success shrink-0 mt-0.5" />
                            <span className="text-sm font-medium text-foreground">
                              {detail}
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Navigation footer inside card */}
                    <div className="mt-8 pt-6 border-t border-border flex items-center justify-between">
                      <button
                        onClick={() => setActiveStep((prev) => (prev > 0 ? prev - 1 : steps.length - 1))}
                        className="px-4 py-2 rounded-xl bg-muted/60 hover:bg-muted text-xs font-semibold text-foreground transition-colors"
                      >
                        ← Previous Phase
                      </button>
                      <span className="text-xs font-mono text-muted-foreground">
                        {idx + 1} / {steps.length}
                      </span>
                      <button
                        onClick={() => setActiveStep((prev) => (prev < steps.length - 1 ? prev + 1 : 0))}
                        className="px-4 py-2 rounded-xl bg-primary text-primary-foreground text-xs font-bold hover:bg-primary/90 transition-colors flex items-center gap-1"
                      >
                        <span>Next Phase</span>
                        <ArrowRight className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>
        </div>

        {/* Horizontal Connector Strip for Visual Impression */}
        <div className="mt-16 hidden xl:block">
          <div className="glass-panel rounded-2xl p-4 border border-border/80 flex items-center justify-between gap-2 overflow-x-auto">
            {steps.map((s, idx) => (
              <React.Fragment key={s.id}>
                <button
                  onClick={() => setActiveStep(idx)}
                  className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap flex items-center gap-1.5 ${
                    activeStep === idx
                      ? "bg-primary text-primary-foreground shadow-md scale-105"
                      : "text-muted-foreground hover:text-foreground"
                  }`}
                >
                  <span>{idx + 1}.</span>
                  <span>{s.shortTitle}</span>
                </button>
                {idx < steps.length - 1 && (
                  <ArrowRight className="w-3.5 h-3.5 text-muted-foreground/40 shrink-0" />
                )}
              </React.Fragment>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
