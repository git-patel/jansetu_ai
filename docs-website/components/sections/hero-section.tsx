"use client";

import React from "react";
import Link from "next/link";
import { motion } from "framer-motion";
import { demoUrl, githubUrl, pdfUrl, videoUrl } from "../../lib/constants";
import {
  ArrowRight,
  Sparkles,
  Cpu,
  ShieldCheck,
  Zap,
  Globe2,
  Users,
  CheckCircle2,
  FileText,
  Activity,
  Code2,
  Play,
  ArrowDown,
} from "lucide-react";

export function HeroSection() {
  const stats = [
    { label: "Report Processing Time", value: "< 60 Sec", icon: Zap, color: "text-warning" },
    { label: "AI Categorization Accuracy", value: "99.4%", icon: Cpu, color: "text-primary" },
    { label: "Duplicate Reduction Rate", value: "87.2%", icon: CheckCircle2, color: "text-success" },
    { label: "Supported Indian Constituencies", value: "543+", icon: Globe2, color: "text-accent" },
  ];

  return (
    <section className="relative pt-32 pb-20 lg:pt-40 lg:pb-32 overflow-hidden">
      {/* Background gradients and glowing spheres */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[450px] bg-gradient-to-tr from-primary/15 via-accent/15 to-transparent rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute -top-20 right-10 w-96 h-96 bg-primary/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute top-1/3 left-10 w-72 h-72 bg-accent/10 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
          {/* Left Text Content */}
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, ease: "easeOut" }}
            className="lg:col-span-7 space-y-8 text-center lg:text-left"
          >
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold bg-primary/10 text-primary border border-primary/20 shadow-sm">
              <Sparkles className="w-3.5 h-3.5 animate-spin" style={{ animationDuration: "4s" }} />
              <span>Official Architecture & Documentation Platform</span>
            </div>

            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-foreground leading-[1.12]">
              JanSetu AI <br />
              <span className="text-lg sm:text-2xl font-bold tracking-wider text-primary block mt-2 uppercase">
                AI-Powered Civic Intelligence Platform for Constituency Development
              </span>
            </h1>

            <p className="text-base sm:text-lg text-muted-foreground font-normal leading-relaxed max-w-2xl mx-auto lg:mx-0">
              Transforming Citizen Voices into Smarter Governance using Artificial Intelligence. JanSetu AI bridges the unstructured gap between citizens, government officers, and Members of Parliament through automated evidence-based decision making.
            </p>

            {/* Configured CTA Button Portal */}
            <div className="flex flex-col sm:flex-row flex-wrap items-center justify-center lg:justify-start gap-4 pt-2">
              <a
                href={demoUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 px-6 py-3.5 rounded-full bg-primary hover:bg-primary/95 text-primary-foreground font-bold text-sm shadow-xl shadow-primary/20 hover:scale-[1.02] active:scale-[0.98] transition-all duration-200 w-full sm:w-auto justify-center"
              >
                <span>🚀 Launch Live Demo</span>
              </a>

              <a
                href={pdfUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 px-6 py-3.5 rounded-full bg-muted/80 hover:bg-muted border border-border/80 text-foreground font-bold text-sm hover:scale-[1.02] active:scale-[0.98] transition-all duration-200 w-full sm:w-auto justify-center"
              >
                <FileText className="w-4 h-4 text-primary" />
                <span>Documentation PDF</span>
              </a>

              <a
                href={githubUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 px-6 py-3.5 rounded-full bg-muted/80 hover:bg-muted border border-border/80 text-foreground font-bold text-sm hover:scale-[1.02] active:scale-[0.98] transition-all duration-200 w-full sm:w-auto justify-center"
              >
                <Code2 className="w-4 h-4" />
                <span>GitHub Repository</span>
              </a>

              <a
                href={videoUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 px-6 py-3.5 rounded-full bg-muted/80 hover:bg-muted border border-border/80 text-foreground font-bold text-sm hover:scale-[1.02] active:scale-[0.98] transition-all duration-200 w-full sm:w-auto justify-center"
              >
                <Play className="w-4 h-4 text-accent fill-accent" />
                <span>Demo Video</span>
              </a>
            </div>

            <div className="flex justify-center lg:justify-start pt-2">
              <Link
                href="#quick-access"
                className="inline-flex items-center gap-2 text-xs text-muted-foreground hover:text-foreground transition-colors group cursor-pointer"
              >
                <ArrowDown className="w-3.5 h-3.5 animate-bounce" />
                <span>Scroll to Explore</span>
              </Link>
            </div>

            {/* Quick Stakeholder Badges */}
            <div className="pt-6 border-t border-border/60 flex flex-wrap items-center justify-center lg:justify-start gap-6 text-xs text-muted-foreground font-medium">
              <span className="flex items-center gap-1.5">
                <ShieldCheck className="w-4 h-4 text-success" />
                <span>Evidence-Backed Verification</span>
              </span>
              <span className="flex items-center gap-1.5">
                <Activity className="w-4 h-4 text-primary" />
                <span>Real-Time Digital Twin</span>
              </span>
              <span className="flex items-center gap-1.5">
                <Users className="w-4 h-4 text-accent" />
                <span>Dual-Identity GPS Validation</span>
              </span>
            </div>
          </motion.div>

          {/* Right Animated AI Illustration */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.2, ease: "easeOut" }}
            className="lg:col-span-5 relative flex justify-center"
          >
            <div className="relative w-full max-w-lg aspect-square">
              {/* Outer Glowing Ring */}
              <div className="absolute inset-4 rounded-full bg-gradient-to-tr from-primary/20 via-accent/20 to-transparent animate-pulse border border-primary/20" />
              
              {/* Main SVG Dashboard Architecture Illustration */}
              <div className="absolute inset-0 glass-panel rounded-3xl p-6 shadow-2xl flex flex-col justify-between border border-border/80 overflow-hidden">
                {/* Header bar of simulated AI engine */}
                <div className="flex items-center justify-between pb-4 border-b border-border/60">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 rounded-full bg-danger" />
                    <div className="w-3 h-3 rounded-full bg-warning" />
                    <div className="w-3 h-3 rounded-full bg-success" />
                    <span className="text-xs font-mono font-medium ml-2 text-muted-foreground">
                      gemini-1.5-flash-governance
                    </span>
                  </div>
                  <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-success/10 text-success border border-success/20">
                    LIVE ENGINE
                  </span>
                </div>

                {/* Simulated AI Flow Nodes */}
                <div className="space-y-3 my-auto">
                  <motion.div
                    animate={{ x: [0, 5, 0] }}
                    transition={{ repeat: Infinity, duration: 4, ease: "easeInOut" }}
                    className="p-3 rounded-xl bg-background/80 border border-border/80 shadow-sm flex items-center justify-between text-xs font-medium"
                  >
                    <div className="flex items-center gap-2.5">
                      <div className="p-1.5 rounded-lg bg-primary/10 text-primary">
                        <Users className="w-4 h-4" />
                      </div>
                      <div>
                        <span className="block font-semibold text-foreground">Citizen Voice Need</span>
                        <span className="text-[10px] text-muted-foreground">&quot;Broken water pipeline near ward 14 school...&quot;</span>
                      </div>
                    </div>
                    <span className="text-primary font-mono text-[10px] font-bold">GPS: VERIFIED</span>
                  </motion.div>

                  <div className="flex justify-center">
                    <div className="w-0.5 h-4 bg-gradient-to-b from-primary to-accent animate-pulse" />
                  </div>

                  <motion.div
                    animate={{ scale: [1, 1.02, 1] }}
                    transition={{ repeat: Infinity, duration: 3, ease: "easeInOut" }}
                    className="p-3.5 rounded-xl bg-gradient-to-r from-primary/10 via-accent/10 to-primary/10 border border-primary/30 shadow-md flex items-center justify-between text-xs"
                  >
                    <div className="flex items-center gap-2.5">
                      <div className="p-1.5 rounded-lg bg-primary text-white shadow-sm">
                        <Sparkles className="w-4 h-4 animate-spin" style={{ animationDuration: "6s" }} />
                      </div>
                      <div>
                        <span className="block font-bold text-primary">AI Priority Engine</span>
                        <span className="text-[10px] text-muted-foreground font-mono">Infrastructure Gap • Critical Severity</span>
                      </div>
                    </div>
                    <span className="px-2 py-0.5 rounded-full bg-danger/15 text-danger font-bold text-[10px] border border-danger/20">
                      SCORE: 94/100
                    </span>
                  </motion.div>

                  <div className="flex justify-center">
                    <div className="w-0.5 h-4 bg-gradient-to-b from-accent to-success animate-pulse" />
                  </div>

                  <motion.div
                    animate={{ x: [0, -5, 0] }}
                    transition={{ repeat: Infinity, duration: 4.5, ease: "easeInOut" }}
                    className="p-3 rounded-xl bg-background/80 border border-border/80 shadow-sm flex items-center justify-between text-xs font-medium"
                  >
                    <div className="flex items-center gap-2.5">
                      <div className="p-1.5 rounded-lg bg-success/10 text-success">
                        <CheckCircle2 className="w-4 h-4" />
                      </div>
                      <div>
                        <span className="block font-semibold text-foreground">MP Decision Dashboard</span>
                        <span className="text-[10px] text-muted-foreground">Recommended Budget: ₹4,50,000 • Est. Beneficiaries: 1,200</span>
                      </div>
                    </div>
                    <span className="px-2 py-0.5 rounded bg-success/10 text-success font-bold text-[10px]">
                      READY FOR TENDER
                    </span>
                  </motion.div>
                </div>

                {/* Footer status of SVG */}
                <div className="pt-3 border-t border-border/60 flex items-center justify-between text-[11px] text-muted-foreground font-mono">
                  <span>Constituency Digital Twin Sync</span>
                  <span className="text-accent font-semibold flex items-center gap-1">
                    <span className="w-1.5 h-1.5 rounded-full bg-accent animate-ping" />
                    ONLINE
                  </span>
                </div>
              </div>
            </div>
          </motion.div>
        </div>

        {/* Live Stats Counter Bar */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.3 }}
          className="mt-20 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6"
        >
          {stats.map((stat, index) => {
            const Icon = stat.icon;
            return (
              <div
                key={index}
                className="glass-card rounded-2xl p-6 border border-border/80 flex items-center gap-4 group hover:border-primary/50 transition-all duration-300"
              >
                <div className={`p-3.5 rounded-2xl bg-muted/60 ${stat.color} group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="text-2xl sm:text-3xl font-extrabold text-foreground tracking-tight">
                    {stat.value}
                  </h3>
                  <p className="text-xs sm:text-sm font-medium text-muted-foreground mt-0.5">
                    {stat.label}
                  </p>
                </div>
              </div>
            );
          })}
        </motion.div>
      </div>
    </section>
  );
}
