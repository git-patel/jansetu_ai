"use client";

import React from "react";
import { motion } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import { MermaidDiagram } from "../ui/mermaid-diagram";
import {
  Layers,
  ShieldAlert,
  Cpu,
  Database,
  Cloud,
  Bell,
  BarChart,
  ArrowRight,
  Sparkles,
} from "lucide-react";

export function ArchitectureSection() {
  const mermaidChart = `
graph TD
    subgraph Client ["Frontend Layer (Flutter & Web)"]
        CA["Citizen Mobile App (Flutter)"]
        MP["MP Decision Dashboard (Web/Tablet)"]
        OFF["Officer Inspection Portal (Mobile/Web)"]
        CON["Contractor Portal (Web)"]
    end

    subgraph Serverless ["Backend Layer (Firebase Cloud Functions)"]
        AUTH["Firebase Authentication & OTP"]
        API["API Gateway / Request Router"]
        SYNC["Offline Sync & Conflict Resolution"]
        GEO["Geospatial Spatial Indexer"]
    end

    subgraph AI_Engine ["Artificial Intelligence Layer (Google Gemini)"]
        STT["Speech-to-Text & NLP Translation"]
        SUM["Executive Engineering Summarizer"]
        CLS["Domain & Ward Classifier"]
        PRI["0-100 Severity Priority Engine"]
        REC["Budget & Beneficiary Predictor"]
    end

    subgraph Storage_DB ["Persistence & Data Layer"]
        FS["Cloud Firestore (NoSQL Document Store)"]
        ST["Firebase Storage (Evidence Media & Bills)"]
        TWIN["Constituency Digital Twin Engine"]
    end

    subgraph Events ["Event & Analytics Layer"]
        FCM["Firebase Cloud Messaging (Notifications)"]
        BQ["Google BigQuery Analytics & Heatmaps"]
    end

    CA -->|1. Submit Voice/Photo| AUTH
    OFF -->|2. Geotagged Inspection| AUTH
    MP -->|3. Project Sanction| AUTH
    CON -->|4. Milestone Billing| AUTH

    AUTH --> API
    API --> SYNC
    SYNC --> GEO
    GEO -->|5. Unstructured Payload| STT

    STT --> SUM
    SUM --> CLS
    CLS --> PRI
    PRI --> REC

    REC -->|6. Structured Intelligence| FS
    API -->|7. Upload Raw Evidence| ST
    FS -->|8. Synchronize State| TWIN

    FS -->|9. Trigger Event| FCM
    FS -->|10. Export Data| BQ
    FCM -->|11. Real-time Status Push| CA
    BQ -->|12. Constituency Heatmap| MP
  `;

  const layers = [
    {
      title: "1. Presentation & Offline Layer",
      icon: Layers,
      color: "text-blue-500 bg-blue-500/10",
      desc: "Built with Flutter and Riverpod. Implements offline-first caching via local SQLite/Hive stores so citizens and field officers can report and verify issues in zero-connectivity rural zones.",
    },
    {
      title: "2. Event-Driven Backend Layer",
      icon: Cloud,
      color: "text-amber-500 bg-amber-500/10",
      desc: "Serverless Node.js Cloud Functions trigger instantly on data mutation. Handles image compression, deduplication clustering algorithms, and secure API handshakes.",
    },
    {
      title: "3. Multimodal AI Processing",
      icon: Cpu,
      color: "text-purple-500 bg-purple-500/10",
      desc: "Google Gemini 2.5 Pro processes audio transcripts and visual evidence. Applies strict prompt guardrails to prevent hallucination and maintain objective technical scoring.",
    },
    {
      title: "4. Digital Twin Persistence",
      icon: Database,
      color: "text-rose-500 bg-rose-500/10",
      desc: "Cloud Firestore maintains real-time document sync across all client devices. Every ward infrastructure asset is tracked as a persistent digital entity with maintenance logs.",
    },
  ];

  return (
    <section id="architecture" className="py-24 relative overflow-hidden bg-muted/20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="System Architecture"
          title="Enterprise Cloud Native Blueprint"
          subtitle="An interactive end-to-end data flow mapping how unstructured citizen audio and photos are transformed into structured governance intelligence."
        />

        {/* Mermaid Diagram Renderer */}
        <div className="mb-16">
          <MermaidDiagram chart={mermaidChart} title="JanSetu AI Full Stack Architecture Flow" />
        </div>

        {/* Architectural Layer Breakdown Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {layers.map((layer, idx) => {
            const Icon = layer.icon;
            return (
              <motion.div
                key={idx}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.1 }}
                className="glass-card rounded-2xl p-6 border border-border/80 space-y-4"
              >
                <div className="flex items-center gap-3">
                  <div className={`p-3 rounded-xl ${layer.color}`}>
                    <Icon className="w-6 h-6" />
                  </div>
                  <h4 className="font-bold text-base text-foreground tracking-tight">
                    {layer.title}
                  </h4>
                </div>
                <p className="text-xs sm:text-sm text-muted-foreground leading-relaxed">
                  {layer.desc}
                </p>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
