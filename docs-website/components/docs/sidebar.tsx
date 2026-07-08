"use client";

import React, { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { DOCS_NAVIGATION } from "../../lib/docs-data";
import { ChevronDown, ChevronRight, BookOpen, Search, Sparkles } from "lucide-react";

export function DocsSidebar() {
  const pathname = usePathname();
  const [searchQuery, setSearchQuery] = useState("");
  const [openCategories, setOpenCategories] = useState<Record<string, boolean>>({
    "Getting Started": true,
    "Core Architecture": true,
    "Artificial Intelligence": true,
    "Product Modules": true,
    "Security & Governance": true,
  });

  const toggleCategory = (title: string) => {
    setOpenCategories((prev) => ({ ...prev, [title]: !prev[title] }));
  };

  const filteredNav = DOCS_NAVIGATION.map((section) => ({
    ...section,
    items: section.items.filter(
      (item) =>
        item.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        item.summary.toLowerCase().includes(searchQuery.toLowerCase())
    ),
  })).filter((section) => section.items.length > 0);

  return (
    <aside className="w-full lg:w-72 shrink-0 border-r border-border bg-background/80 backdrop-blur-xl lg:sticky lg:top-20 lg:h-[calc(100vh-5rem)] overflow-y-auto p-6 custom-scrollbar">
      <div className="mb-6 space-y-4">
        <Link href="/docs" className="flex items-center gap-2 font-black text-lg text-foreground group">
          <div className="p-2 rounded-xl bg-primary/10 text-primary group-hover:scale-105 transition-transform">
            <BookOpen className="w-5 h-5" />
          </div>
          <span>Documentation Hub</span>
        </Link>

        {/* Search Input */}
        <div className="relative">
          <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
          <input
            type="text"
            placeholder="Filter documentation..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-4 py-2 rounded-xl bg-muted/60 border border-border/60 text-xs text-foreground placeholder:text-muted-foreground focus:outline-none focus:border-primary transition-colors"
          />
        </div>
      </div>

      {/* Navigation Tree */}
      <div className="space-y-6">
        {filteredNav.map((section) => {
          const isOpen = openCategories[section.title];
          return (
            <div key={section.title} className="space-y-2">
              <button
                onClick={() => toggleCategory(section.title)}
                className="w-full flex items-center justify-between text-xs font-bold uppercase tracking-wider text-muted-foreground hover:text-foreground transition-colors py-1"
              >
                <span>{section.title}</span>
                {isOpen ? (
                  <ChevronDown className="w-4 h-4 opacity-60" />
                ) : (
                  <ChevronRight className="w-4 h-4 opacity-60" />
                )}
              </button>

              {isOpen && (
                <ul className="space-y-1 pl-2 border-l border-border/80">
                  {section.items.map((item) => {
                    const href = `/docs/${item.slug}`;
                    const isActive = pathname === href || (pathname === "/docs" && item.slug === "overview");
                    return (
                      <li key={item.slug}>
                        <Link
                          href={href}
                          className={`block px-3 py-2 rounded-xl text-xs sm:text-sm font-medium transition-all ${
                            isActive
                              ? "bg-primary/10 text-primary font-bold shadow-xs translate-x-1"
                              : "text-muted-foreground hover:text-foreground hover:bg-muted/50 hover:translate-x-0.5"
                          }`}
                        >
                          {item.title}
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              )}
            </div>
          );
        })}

        {filteredNav.length === 0 && (
          <div className="py-8 text-center text-xs text-muted-foreground space-y-2">
            <Sparkles className="w-6 h-6 mx-auto text-primary opacity-50 animate-pulse" />
            <p>No matching docs found for &quot;{searchQuery}&quot;.</p>
          </div>
        )}
      </div>

      <div className="mt-12 pt-6 border-t border-border/60 text-[11px] text-muted-foreground">
        <p className="font-semibold text-foreground">Need Technical Help?</p>
        <p className="mt-1">Review the JanSetu AI repository guidelines or contact the architecture steering committee.</p>
      </div>
    </aside>
  );
}
