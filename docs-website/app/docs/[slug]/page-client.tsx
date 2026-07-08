"use client";

import React, { useState } from "react";
import { notFound } from "next/navigation";
import Link from "next/link";
import { DOCS_ARTICLES, DOCS_NAVIGATION } from "../../../lib/docs-data";
import { MermaidDiagram } from "../../../components/ui/mermaid-diagram";
import {
  Copy,
  Check,
  ChevronRight,
  Info,
  AlertTriangle,
  Sparkles,
  ArrowLeft,
  ArrowRight,
  Clock,
} from "lucide-react";

interface DocArticlePageClientProps {
  slug: string;
}

export default function DocArticlePageClient({ slug }: DocArticlePageClientProps) {
  const article = DOCS_ARTICLES[slug];
  const [copiedIndex, setCopiedIndex] = useState<number | null>(null);

  if (!article) {
    return notFound();
  }

  const handleCopy = (text: string, index: number) => {
    navigator.clipboard.writeText(text);
    setCopiedIndex(index);
    setTimeout(() => setCopiedIndex(null), 2000);
  };

  // Find previous and next articles in navigation tree
  const allItems = DOCS_NAVIGATION.flatMap((s) => s.items);
  const currentIndex = allItems.findIndex((i) => i.slug === slug);
  const prevItem = currentIndex > 0 ? allItems[currentIndex - 1] : null;
  const nextItem = currentIndex < allItems.length - 1 ? allItems[currentIndex + 1] : null;

  return (
    <article className="max-w-4xl space-y-10 pb-20">
      {/* Breadcrumbs */}
      <nav className="flex items-center gap-1.5 text-xs font-semibold text-muted-foreground flex-wrap">
        <Link href="/" className="hover:text-foreground transition-colors">
          Home
        </Link>
        <ChevronRight className="w-3.5 h-3.5 opacity-50" />
        <Link href="/docs" className="hover:text-foreground transition-colors">
          Docs
        </Link>
        <ChevronRight className="w-3.5 h-3.5 opacity-50" />
        <span className="text-primary font-bold">{article.category}</span>
        <ChevronRight className="w-3.5 h-3.5 opacity-50" />
        <span className="text-foreground truncate max-w-[200px] sm:max-w-none">
          {article.title}
        </span>
      </nav>

      {/* Header */}
      <header className="space-y-4 border-b border-border pb-8">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-extrabold tracking-wide bg-primary/10 text-primary border border-primary/20">
            <Sparkles className="w-3.5 h-3.5" />
            <span>{article.category}</span>
          </span>
          <span className="flex items-center gap-1.5 text-xs text-muted-foreground font-mono">
            <Clock className="w-3.5 h-3.5" />
            <span>Updated: {article.lastUpdated}</span>
          </span>
        </div>

        <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black text-foreground tracking-tight leading-[1.15]">
          {article.title}
        </h1>

        <p className="text-base sm:text-lg text-muted-foreground leading-relaxed">
          {article.summary}
        </p>
      </header>

      {/* Content Sections */}
      <div className="space-y-12">
        {article.content.map((section, idx) => (
          <section key={idx} className="space-y-6">
            <h2 className="text-2xl sm:text-3xl font-extrabold text-foreground tracking-tight pt-4">
              {section.heading}
            </h2>

            {/* Paragraph Text with line breaks */}
            {section.body && (
              <div className="text-sm sm:text-base text-foreground/90 leading-relaxed space-y-4 font-normal whitespace-pre-line">
                {section.body}
              </div>
            )}

            {/* Mermaid Diagram */}
            {section.mermaid && (
              <div className="my-6">
                <MermaidDiagram
                  chart={section.mermaid}
                  title={`${article.title} - Architectural Flow`}
                />
              </div>
            )}

            {/* Callout Box */}
            {section.callout && (
              <div
                className={`p-5 rounded-2xl border flex items-start gap-4 ${
                  section.callout.type === "important" || section.callout.type === "warning"
                    ? "bg-warning/[0.08] border-warning/30 text-foreground"
                    : section.callout.type === "tip"
                    ? "bg-success/[0.08] border-success/30 text-foreground"
                    : "bg-primary/[0.08] border-primary/30 text-foreground"
                }`}
              >
                <div
                  className={`p-2 rounded-xl shrink-0 mt-0.5 ${
                    section.callout.type === "important" || section.callout.type === "warning"
                      ? "bg-warning/20 text-warning"
                      : section.callout.type === "tip"
                      ? "bg-success/20 text-success"
                      : "bg-primary/20 text-primary"
                  }`}
                >
                  {section.callout.type === "important" || section.callout.type === "warning" ? (
                    <AlertTriangle className="w-5 h-5" />
                  ) : (
                    <Info className="w-5 h-5" />
                  )}
                </div>
                <div>
                  <span className="text-xs font-mono uppercase font-bold tracking-wider block opacity-80 mb-1">
                    {section.callout.type.toUpperCase()} NOTICE
                  </span>
                  <p className="text-sm font-medium leading-relaxed">
                    {section.callout.text}
                  </p>
                </div>
              </div>
            )}

            {/* Code Snippet Block */}
            {section.code && (
              <div className="rounded-2xl border border-border bg-secondary overflow-hidden shadow-xl my-6">
                <div className="flex items-center justify-between px-4 py-3 bg-secondary-foreground/5 border-b border-border/40 text-xs font-mono">
                  <div className="flex items-center gap-2">
                    <div className="flex gap-1.5">
                      <div className="w-3 h-3 rounded-full bg-danger/80" />
                      <div className="w-3 h-3 rounded-full bg-warning/80" />
                      <div className="w-3 h-3 rounded-full bg-success/80" />
                    </div>
                    <span className="text-muted-foreground ml-2">
                      {section.code.caption || `snippet.${section.code.language}`}
                    </span>
                  </div>
                  <button
                    onClick={() => handleCopy(section.code!.snippet, idx)}
                    className="flex items-center gap-1.5 px-3 py-1 rounded-lg bg-background/20 hover:bg-background/40 text-secondary-foreground transition-all"
                    title="Copy snippet"
                  >
                    {copiedIndex === idx ? (
                      <>
                        <Check className="w-3.5 h-3.5 text-success" />
                        <span className="text-success font-semibold">Copied</span>
                      </>
                    ) : (
                      <>
                        <Copy className="w-3.5 h-3.5" />
                        <span>Copy</span>
                      </>
                    )}
                  </button>
                </div>
                <div className="p-5 overflow-x-auto text-xs sm:text-sm font-mono leading-relaxed text-secondary-foreground">
                  <pre>
                    <code>{section.code.snippet}</code>
                  </pre>
                </div>
              </div>
            )}
          </section>
        ))}
      </div>

      {/* Bottom Article Navigation */}
      <div className="pt-12 border-t border-border grid grid-cols-1 sm:grid-cols-2 gap-4">
        {prevItem ? (
          <Link
            href={`/docs/${prevItem.slug}`}
            className="p-6 rounded-2xl glass-card border border-border/80 hover:border-primary/50 flex flex-col items-start transition-all group"
          >
            <span className="text-xs font-semibold uppercase tracking-wider text-muted-foreground flex items-center gap-1 mb-2">
              <ArrowLeft className="w-3.5 h-3.5 group-hover:-translate-x-1 transition-transform" />
              <span>Previous Article</span>
            </span>
            <span className="font-extrabold text-base sm:text-lg text-foreground group-hover:text-primary transition-colors">
              {prevItem.title}
            </span>
          </Link>
        ) : (
          <div />
        )}

        {nextItem && (
          <Link
            href={`/docs/${nextItem.slug}`}
            className="p-6 rounded-2xl glass-card border border-border/80 hover:border-primary/50 flex flex-col items-end text-right transition-all group"
          >
            <span className="text-xs font-semibold uppercase tracking-wider text-muted-foreground flex items-center gap-1 mb-2">
              <span>Next Article</span>
              <ArrowRight className="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
            </span>
            <span className="font-extrabold text-base sm:text-lg text-foreground group-hover:text-primary transition-colors">
              {nextItem.title}
            </span>
          </Link>
        )}
      </div>
    </article>
  );
}
