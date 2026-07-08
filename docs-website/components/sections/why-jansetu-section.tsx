"use client";

import React from "react";
import { motion } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import { Users, Brain, Activity, Heart, Shield, Layers } from "lucide-react";

export function WhyJanSetuSection() {
  const cards = [
    {
      title: "Citizen First",
      desc: "Zero bureaucracy login. Report issues instantly in local languages using voice or simple photo uploads.",
      icon: Users,
      color: "text-blue-400",
    },
    {
      title: "AI Powered",
      desc: "Underpinned by Google Gemini 1.5 Flash to summarize inputs, calculate priority, and route to proper departments.",
      icon: Brain,
      color: "text-purple-400",
    },
    {
      title: "Real-Time Governance",
      desc: "Live spatial twins synchronization linking citizen needs directly to PWD contract tranches and MP oversight.",
      icon: Activity,
      color: "text-emerald-400",
    },
    {
      title: "Community Driven",
      desc: "Democratic support counters and threaded discussions prevent duplication and amplify regional public voices.",
      icon: Heart,
      color: "text-pink-400",
    },
    {
      title: "Transparent Budget",
      desc: "Direct tracking of MPLADS fund pools, budget deductions, and contractor milestones inside blockchain-like audit trails.",
      icon: Shield,
      color: "text-amber-400",
    },
    {
      title: "Scalable Architecture",
      desc: "Built using Flutter, serverless Firebase, and decoupled API repositories, ready for a state-wide or national deployment.",
      icon: Layers,
      color: "text-cyan-400",
    },
  ];

  return (
    <section className="py-24 relative overflow-hidden bg-muted/10 border-t border-b border-border/40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Ecosystem Overview"
          title="Why JanSetu AI?"
          subtitle="A modern digital bridge linking citizens, representatives, and administrative authorities under a single intelligence network."
        />

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {cards.map((card, index) => {
            const Icon = card.icon;
            return (
              <motion.div
                key={card.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.08 }}
                className="glass-card rounded-3xl p-8 border border-border/80 hover:border-primary/50 transition-all duration-300 flex flex-col items-start gap-4 group"
              >
                <div className={`p-4 rounded-2xl bg-muted/80 w-fit ${card.color} group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-foreground mb-2 group-hover:text-primary transition-colors">
                    {card.title}
                  </h3>
                  <p className="text-sm text-muted-foreground leading-relaxed">
                    {card.desc}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
