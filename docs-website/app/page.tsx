"use client";

import React from "react";
import { HeroSection } from "../components/sections/hero-section";
import { QuickAccessSection } from "../components/sections/quick-access-section";
import { WhyJanSetuSection } from "../components/sections/why-jansetu-section";
import { VisionSection } from "../components/sections/vision-section";
import { ShowcaseSection } from "../components/sections/showcase-section";
import { AiPipelineSection } from "../components/sections/ai-pipeline-section";
import { ModulesSection } from "../components/sections/modules-section";
import { TechStackSection } from "../components/sections/tech-stack-section";
import { ArchitectureSection } from "../components/sections/architecture-section";
import { RoadmapSection } from "../components/sections/roadmap-section";
import { TeamSection } from "../components/sections/team-section";
import Link from "next/link";
import { ArrowRight, BookOpen, Sparkles } from "lucide-react";

export default function Home() {
  return (
    <div className="space-y-12">
      <HeroSection />
      <QuickAccessSection />
      <VisionSection />
      <WhyJanSetuSection />
      <ShowcaseSection />
      <AiPipelineSection />
      <ModulesSection />
      <TechStackSection />
      <ArchitectureSection />
      <RoadmapSection />
      <TeamSection />

      {/* Global CTA Banner before footer */}
      <section className="py-16 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="glass-panel rounded-3xl p-10 md:p-16 text-center border border-primary/40 shadow-2xl relative overflow-hidden bg-gradient-to-r from-primary/10 via-accent/10 to-primary/10">
          <div className="absolute top-0 right-0 w-80 h-80 bg-primary/20 rounded-full blur-3xl pointer-events-none" />
          <div className="absolute bottom-0 left-0 w-80 h-80 bg-accent/20 rounded-full blur-3xl pointer-events-none" />

          <div className="max-w-3xl mx-auto space-y-6 relative z-10">
            <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full text-xs font-bold bg-primary text-primary-foreground shadow-sm">
              <Sparkles className="w-3.5 h-3.5" />
              <span>Deep-Dive Developer Documentation</span>
            </div>
            
            <h2 className="text-3xl md:text-4xl lg:text-5xl font-black text-foreground tracking-tight leading-tight">
              Ready to Explore the Complete System Specifications?
            </h2>

            <p className="text-base md:text-lg text-muted-foreground leading-relaxed">
              Dive into our Stripe and OpenAI inspired documentation hub to review exact JSON data schemas, Firestore security rules, Riverpod offline-first state synchronization, and Google Gemini prompt engineering templates.
            </p>

            <div className="flex flex-wrap items-center justify-center gap-4 pt-4">
              <Link
                href="/docs"
                className="flex items-center gap-2.5 px-8 py-4 rounded-full bg-primary hover:bg-primary/90 text-primary-foreground font-bold text-base shadow-xl shadow-primary/25 hover:scale-105 active:scale-95 transition-all duration-200"
              >
                <BookOpen className="w-5 h-5" />
                <span>Launch Documentation Hub</span>
                <ArrowRight className="w-5 h-5 ml-1" />
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
