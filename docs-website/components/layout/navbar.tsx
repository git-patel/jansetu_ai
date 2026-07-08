"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import { useTheme } from "next-themes";
import { motion, AnimatePresence } from "framer-motion";
import {
  Moon,
  Sun,
  Search,
  Menu,
  X,
  Sparkles,
  ArrowRight,
  BookOpen,
  Layers,
  Cpu,
  ShieldCheck,
  Globe,
} from "lucide-react";

export function Navbar() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);

  useEffect(() => {
    setMounted(true);
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const navLinks = [
    { name: "Vision", href: "/#vision", icon: Globe },
    { name: "AI Pipeline", href: "/#ai-pipeline", icon: Sparkles },
    { name: "Architecture", href: "/#architecture", icon: Cpu },
    { name: "Modules", href: "/#modules", icon: Layers },
    { name: "Documentation", href: "/docs", icon: BookOpen },
  ];

  return (
    <>
      <header
        className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
          scrolled
            ? "glass-panel shadow-md py-3"
            : "bg-transparent py-5"
        }`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between">
            {/* Logo */}
            <Link href="/" className="flex items-center gap-3 group">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary to-accent flex items-center justify-center shadow-lg shadow-primary/25 group-hover:scale-105 transition-transform duration-200">
                <Sparkles className="w-5 h-5 text-white animate-pulse" />
              </div>
              <div>
                <span className="font-extrabold text-xl tracking-tight text-foreground flex items-center gap-1">
                  JanSetu <span className="text-primary font-black">AI</span>
                </span>
                <span className="block text-[10px] uppercase tracking-widest text-muted-foreground font-semibold">
                  Constituency Intelligence
                </span>
              </div>
            </Link>

            {/* Desktop Navigation */}
            <nav className="hidden md:flex items-center gap-1 lg:gap-2 bg-muted/40 p-1.5 rounded-full border border-border/50 backdrop-blur-md">
              {navLinks.map((link) => {
                const Icon = link.icon;
                return (
                  <Link
                    key={link.name}
                    href={link.href}
                    className="flex items-center gap-2 px-4 py-2 rounded-full text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-background/80 transition-all duration-200"
                  >
                    <Icon className="w-4 h-4 text-primary" />
                    <span>{link.name}</span>
                  </Link>
                );
              })}
            </nav>

            {/* Actions */}
            <div className="hidden md:flex items-center gap-3">
              <button
                onClick={() => setSearchOpen(true)}
                className="flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium text-muted-foreground bg-muted/60 border border-border/60 hover:border-primary/50 hover:text-foreground transition-all duration-200"
              >
                <Search className="w-3.5 h-3.5 text-primary" />
                <span>Search Docs...</span>
                <kbd className="px-1.5 py-0.5 rounded bg-background text-[10px] border border-border font-mono">
                  ⌘K
                </kbd>
              </button>

              {mounted && (
                <button
                  onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
                  className="p-2.5 rounded-full bg-muted/60 border border-border/60 hover:bg-muted text-foreground transition-all duration-200"
                  aria-label="Toggle Theme"
                >
                  {theme === "dark" ? (
                    <Sun className="w-4 h-4 text-warning" />
                  ) : (
                    <Moon className="w-4 h-4 text-primary" />
                  )}
                </button>
              )}

              <Link
                href="/docs"
                className="flex items-center gap-2 px-5 py-2.5 rounded-full bg-primary hover:bg-primary/90 text-primary-foreground font-semibold text-sm shadow-lg shadow-primary/25 hover:shadow-primary/40 hover:scale-[1.02] active:scale-[0.98] transition-all duration-200"
              >
                <span>Launch Portal</span>
                <ArrowRight className="w-4 h-4" />
              </Link>
            </div>

            {/* Mobile Menu Button */}
            <div className="flex items-center gap-2 md:hidden">
              {mounted && (
                <button
                  onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
                  className="p-2 rounded-xl bg-muted/60 border border-border/60 text-foreground"
                >
                  {theme === "dark" ? (
                    <Sun className="w-4 h-4 text-warning" />
                  ) : (
                    <Moon className="w-4 h-4 text-primary" />
                  )}
                </button>
              )}
              <button
                onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                className="p-2 rounded-xl bg-muted/60 border border-border/60 text-foreground"
              >
                {mobileMenuOpen ? (
                  <X className="w-6 h-6" />
                ) : (
                  <Menu className="w-6 h-6" />
                )}
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Mobile Menu Modal */}
      <AnimatePresence>
        {mobileMenuOpen && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="fixed inset-0 z-40 bg-background/95 backdrop-blur-2xl md:hidden pt-24 px-6 pb-6 flex flex-col justify-between"
          >
            <div className="space-y-4">
              <button
                onClick={() => {
                  setMobileMenuOpen(false);
                  setSearchOpen(true);
                }}
                className="w-full flex items-center justify-between p-4 rounded-2xl bg-muted/60 border border-border text-left text-muted-foreground"
              >
                <div className="flex items-center gap-3">
                  <Search className="w-5 h-5 text-primary" />
                  <span className="font-medium">Search Documentation...</span>
                </div>
              </button>

              <div className="space-y-2 pt-2">
                {navLinks.map((link) => {
                  const Icon = link.icon;
                  return (
                    <Link
                      key={link.name}
                      href={link.href}
                      onClick={() => setMobileMenuOpen(false)}
                      className="flex items-center gap-4 p-4 rounded-2xl text-lg font-semibold text-foreground hover:bg-primary/10 hover:text-primary transition-all"
                    >
                      <div className="p-2 rounded-xl bg-primary/10 text-primary">
                        <Icon className="w-5 h-5" />
                      </div>
                      <span>{link.name}</span>
                    </Link>
                  );
                })}
              </div>
            </div>

            <div className="pt-6 border-t border-border">
              <Link
                href="/docs"
                onClick={() => setMobileMenuOpen(false)}
                className="w-full flex items-center justify-center gap-2 py-4 rounded-2xl bg-primary text-primary-foreground font-bold text-base shadow-lg shadow-primary/30"
              >
                <span>Read Official Docs</span>
                <ArrowRight className="w-5 h-5" />
              </Link>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Search Modal */}
      <AnimatePresence>
        {searchOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-start justify-center pt-20 px-4"
            onClick={() => setSearchOpen(false)}
          >
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              onClick={(e) => e.stopPropagation()}
              className="w-full max-w-2xl bg-background border border-border rounded-2xl shadow-2xl overflow-hidden"
            >
              <div className="p-4 border-b border-border flex items-center gap-3">
                <Search className="w-5 h-5 text-primary" />
                <input
                  type="text"
                  placeholder="Search architecture, modules, AI pipeline, API endpoints..."
                  className="w-full bg-transparent text-foreground placeholder:text-muted-foreground focus:outline-none text-base"
                  autoFocus
                />
                <button
                  onClick={() => setSearchOpen(false)}
                  className="p-1 rounded-lg hover:bg-muted text-muted-foreground"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>
              <div className="p-6 max-h-[60vh] overflow-y-auto space-y-4">
                <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                  Quick Suggestions
                </p>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                  {[
                    { title: "AI Pipeline & Gemini Integration", href: "/docs/ai-engine" },
                    { title: "Citizen App Dual-Identity Model", href: "/docs/citizen-app" },
                    { title: "MP Decision Support Dashboard", href: "/docs/mp-dashboard" },
                    { title: "Firestore Security Rules", href: "/docs/security" },
                    { title: "Offline-First Riverpod Architecture", href: "/docs/architecture" },
                    { title: "Government Officer Verification", href: "/docs/officer-portal" },
                  ].map((item) => (
                    <Link
                      key={item.title}
                      href={item.href}
                      onClick={() => setSearchOpen(false)}
                      className="p-3 rounded-xl bg-muted/40 hover:bg-primary/10 hover:text-primary border border-border/50 transition-all flex items-center justify-between text-sm font-medium"
                    >
                      <span>{item.title}</span>
                      <ArrowRight className="w-4 h-4 text-muted-foreground" />
                    </Link>
                  ))}
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
