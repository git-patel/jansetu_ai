"use client";

import React from "react";
import { motion } from "framer-motion";
import { demoUrl, githubUrl, pdfUrl } from "../../lib/constants";
import { Terminal, Shield, FileText } from "lucide-react";

export function QuickAccessSection() {
  const cards = [
    {
      title: "Launch Live Demo",
      description: "Directly explore the multi-role sandbox dashboard portal containing Citizen, MP, and State Admin twins.",
      icon: Terminal,
      cta: "🚀 Open App Workspace",
      link: demoUrl,
      color: "from-blue-500/20 to-cyan-500/20 hover:border-blue-500/60",
      iconColor: "text-blue-400",
    },
    {
      title: "Submission PDF Plan",
      description: "Read the comprehensive 24-section startup pitch deck and government implementation report.",
      icon: FileText,
      cta: "📄 Read Submission Whitepaper",
      link: pdfUrl,
      color: "from-purple-500/20 to-indigo-500/20 hover:border-purple-500/60",
      iconColor: "text-purple-400",
    },
    {
      title: "GitHub Repository",
      description: "Inspect the fully compiled Clean Architecture codebase, unit test cases, and database security rules.",
      icon: Shield,
      cta: "💻 Browse Source Code",
      link: githubUrl,
      color: "from-amber-500/20 to-orange-500/20 hover:border-amber-500/60",
      iconColor: "text-amber-400",
    },
  ];

  return (
    <section id="quick-access" className="py-16 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 scroll-mt-20">
      <div className="text-center max-w-3xl mx-auto mb-12">
        <h2 className="text-3xl font-extrabold text-foreground tracking-tight sm:text-4xl">
          Quick Access Portal
        </h2>
        <p className="mt-4 text-base sm:text-lg text-muted-foreground leading-relaxed">
          Immediate access points configured for hackathon evaluators. Inspect, audit, and run every tier of the ecosystem.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {cards.map((card, index) => {
          const Icon = card.icon;
          return (
            <motion.a
              key={card.title}
              href={card.link}
              target="_blank"
              rel="noopener noreferrer"
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className={`glass-card rounded-3xl p-6 border border-border/80 flex flex-col justify-between hover:-translate-y-1 bg-gradient-to-br ${card.color} transition-all duration-300 group`}
            >
              <div className="space-y-4">
                <div className={`p-3 rounded-2xl bg-muted/80 w-fit ${card.iconColor}`}>
                  <Icon className="w-6 h-6 animate-pulse" />
                </div>
                <h3 className="text-xl font-bold text-foreground group-hover:text-primary transition-colors">
                  {card.title}
                </h3>
                <p className="text-xs sm:text-sm text-muted-foreground leading-relaxed">
                  {card.description}
                </p>
              </div>
              <div className="mt-6 pt-4 border-t border-border/60 flex items-center justify-between text-xs font-bold text-foreground group-hover:text-primary transition-colors">
                <span>{card.cta}</span>
                <span>→</span>
              </div>
            </motion.a>
          );
        })}
      </div>
    </section>
  );
}
