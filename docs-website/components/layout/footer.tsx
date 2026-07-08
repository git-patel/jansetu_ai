"use client";

import React from "react";
import Link from "next/link";
import { demoUrl, githubUrl, pdfUrl, videoUrl } from "../../lib/constants";
import { Sparkles, Globe, Share2, Code2, Shield, Heart, ArrowUpRight, Mail } from "lucide-react";

export function Footer() {
  const columns = [
    {
      title: "Core Ecosystem",
      links: [
        { name: "Citizen Application", href: "/#modules" },
        { name: "Community Development Hub", href: "/#modules" },
        { name: "MP Decision Dashboard", href: "/#modules" },
        { name: "Officer Verification Portal", href: "/#modules" },
        { name: "Contractor Execution", href: "/#modules" },
        { name: "Constituency Digital Twin", href: "/#roadmap" },
      ],
    },
    {
      title: "AI & Architecture",
      links: [
        { name: "Gemini AI Pipeline", href: "/#ai-pipeline" },
        { name: "Speech & NLP Recognition", href: "/docs/ai-engine" },
        { name: "Priority Scoring Engine", href: "/docs/ai-engine" },
        { name: "Infrastructure Mapping", href: "/docs/ai-engine" },
        { name: "Clean MVVM Architecture", href: "/#architecture" },
        { name: "Offline-First Sync", href: "/docs/architecture" },
      ],
    },
    {
      title: "Quick Connections",
      links: [
        { name: "🚀 Launch Demo Workspace", href: demoUrl, external: true },
        { name: "💻 Source Code Repository", href: githubUrl, external: true },
        { name: "📄 Documentation PDF", href: pdfUrl, external: true },
        { name: "🎥 Walkthrough Video", href: videoUrl, external: true },
      ],
    },
  ];

  return (
    <footer className="bg-muted/30 border-t border-border mt-24 relative overflow-hidden">
      {/* Decorative background glow */}
      <div className="absolute -top-40 left-1/2 -translate-x-1/2 w-[600px] h-80 bg-primary/5 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 pb-16 border-b border-border">
          {/* Brand Column */}
          <div className="lg:col-span-2 space-y-6">
            <Link href="/" className="flex items-center gap-3 group">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary to-accent flex items-center justify-center shadow-md">
                <Sparkles className="w-5 h-5 text-white" />
              </div>
              <div>
                <span className="font-extrabold text-2xl tracking-tight text-foreground flex items-center gap-1">
                  JanSetu <span className="text-primary font-black">AI</span>
                </span>
                <span className="block text-xs uppercase tracking-widest text-muted-foreground font-semibold">
                  Constituency Intelligence
                </span>
              </div>
            </Link>
            <p className="text-sm text-muted-foreground leading-relaxed pr-6">
              Empowering Citizens. Enabling Smarter Governance. JanSetu AI is India&apos;s most trusted AI-powered Constituency Development Platform transforming unstructured citizen feedback into verified, data-driven execution.
            </p>
            
            <div className="space-y-2.5 text-xs text-muted-foreground">
              <div className="flex items-center gap-2">
                <Mail className="w-4 h-4 text-primary" />
                <span>support@jansetu.gov.in</span>
              </div>
              <div className="flex items-center gap-2 font-mono">
                <span>Version: v2.4 Enterprise</span>
              </div>
              <div className="font-semibold text-foreground">
                National Smart Governance Hackathon 2026
              </div>
            </div>

            <div className="flex items-center gap-3 pt-2">
              {[
                { icon: Code2, label: "Developer Repo", href: githubUrl },
                { icon: Globe, label: "Live Demo", href: demoUrl },
              ].map((social, idx) => {
                const Icon = social.icon;
                return (
                  <a
                    key={idx}
                    href={social.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="p-2.5 rounded-xl bg-background border border-border text-muted-foreground hover:text-primary hover:border-primary/50 transition-all shadow-sm"
                    aria-label={social.label}
                  >
                    <Icon className="w-4 h-4" />
                  </a>
                );
              })}
            </div>
          </div>

          {/* Links Columns */}
          {columns.map((col, idx) => (
            <div key={idx} className="space-y-4">
              <h4 className="font-semibold text-sm text-foreground uppercase tracking-wider">
                {col.title}
              </h4>
              <ul className="space-y-2.5">
                {col.links.map((link, lIdx) => {
                  const linkItem = link as any;
                  return (
                    <li key={lIdx}>
                      {linkItem.external ? (
                      <a
                        href={link.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-sm text-muted-foreground hover:text-primary transition-colors flex items-center gap-1 group"
                      >
                        <span>{link.name}</span>
                        <ArrowUpRight className="w-3 h-3 opacity-0 -translate-y-0.5 translate-x-0.5 group-hover:opacity-100 group-hover:translate-y-0 group-hover:translate-x-0 transition-all" />
                      </a>
                    ) : (
                      <Link
                        href={link.href}
                        className="text-sm text-muted-foreground hover:text-primary transition-colors flex items-center gap-1 group"
                      >
                        <span>{link.name}</span>
                        <ArrowUpRight className="w-3 h-3 opacity-0 -translate-y-0.5 translate-x-0.5 group-hover:opacity-100 group-hover:translate-y-0 group-hover:translate-x-0 transition-all" />
                      </Link>
                    )}
                  </li>
                );
              })}
              </ul>
            </div>
          ))}
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 flex flex-col md:flex-row items-center justify-between gap-4 text-xs text-muted-foreground">
          <div className="flex items-center gap-2">
            <Shield className="w-4 h-4 text-primary" />
            <span>Built for transparent public governance and evidence-based AI development planning.</span>
          </div>
          <div className="flex items-center gap-1">
            <span>Designed & Engineered with</span>
            <Heart className="w-3.5 h-3.5 text-danger fill-danger inline" />
            <span>for the Future of India. © {new Date().getFullYear()} JanSetu AI. All Rights Reserved.</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
