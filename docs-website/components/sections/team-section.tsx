"use client";

import React from "react";
import { motion } from "framer-motion";
import { SectionHeading } from "../ui/section-heading";
import { User, Code2, Cpu } from "lucide-react";

export function TeamSection() {
  const team = [
    {
      name: "Harsh Patel",
      role: "Android Developer",
      responsibilities: [
        "Architected e-Pramaan SSO gateway authentication workflows.",
        "Implemented local database synchronization and custom CacheManager logic.",
        "Refactored RenderFlex layout constraints to support dynamic wrapping on tables.",
      ],
      icon: Code2,
      color: "text-blue-400 border-blue-500/20 bg-blue-500/[0.02]",
    },
    {
      name: "Yash Patel",
      role: "Flutter Developer",
      responsibilities: [
        "Constructed GeminiAiProvider client-side HTTP integration pipeline.",
        "Decoupled state repositories using dynamic ServiceLocator patterns.",
        "Designed and maintained dark-theme Material 3 design system tokens.",
      ],
      icon: Cpu,
      color: "text-purple-400 border-purple-500/20 bg-purple-500/[0.02]",
    },
    {
      name: "Arth Patel",
      role: "Android Developer",
      responsibilities: [
        "Implemented nested comment feeds and support toggle algorithms.",
        "Managed Firebase remote config state pipelines and analytics logging.",
        "Wrote comprehensive unit and E2E widget validation test suites.",
      ],
      icon: User,
      color: "text-emerald-400 border-emerald-500/20 bg-emerald-500/[0.02]",
    },
  ];

  return (
    <section id="team" className="py-24 relative overflow-hidden bg-muted/10 border-t border-border/40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <SectionHeading
          badge="Our Creators"
          title="The Development Team"
          subtitle="Engineers behind the JanSetu AI ecosystem. Combining expertise in cross-platform mobile architecture, serverless cloud databases, and localized AI intelligence."
        />

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {team.map((member, index) => {
            const Icon = member.icon;
            return (
              <motion.div
                key={member.name}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                className={`glass-card rounded-3xl p-8 border hover:border-primary/50 transition-all duration-300 flex flex-col justify-between group ${member.color}`}
              >
                <div className="space-y-6">
                  <div className="flex items-center gap-3">
                    <div className="p-3 rounded-2xl bg-muted/80 text-foreground group-hover:scale-110 transition-transform duration-300">
                      <Icon className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="text-xl font-bold text-foreground group-hover:text-primary transition-colors">
                        {member.name}
                      </h3>
                      <span className="text-xs font-mono font-bold text-muted-foreground uppercase">
                        {member.role}
                      </span>
                    </div>
                  </div>

                  <div className="space-y-2.5 pt-4 border-t border-border/50">
                    <span className="text-xs font-mono font-bold text-foreground block">RESPONSIBILITIES</span>
                    {member.responsibilities.map((resp) => (
                      <div key={resp} className="flex items-start gap-2.5 text-xs text-muted-foreground leading-relaxed">
                        <span className="text-primary font-bold shrink-0 mt-0.5">•</span>
                        <span>{resp}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
