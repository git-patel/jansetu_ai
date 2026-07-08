"use client";

import React, { useEffect, useRef, useState } from "react";
import mermaid from "mermaid";
import { useTheme } from "next-themes";
import { Maximize2, Minimize2, ZoomIn, ZoomOut, RotateCcw } from "lucide-react";

interface MermaidDiagramProps {
  chart: string;
  title?: string;
}

export function MermaidDiagram({ chart, title }: MermaidDiagramProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const { resolvedTheme } = useTheme();
  const [svgContent, setSvgContent] = useState<string>("");
  const [isExpanded, setIsExpanded] = useState<boolean>(false);
  const [scale, setScale] = useState<number>(1);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;
    const renderChart = async () => {
      try {
        setError(null);
        mermaid.initialize({
          startOnLoad: false,
          theme: resolvedTheme === "dark" ? "dark" : "default",
          securityLevel: "loose",
          fontFamily: "Inter, sans-serif",
          themeVariables: {
            primaryColor: resolvedTheme === "dark" ? "#1e293b" : "#eff6ff",
            primaryBorderColor: "#2563eb",
            primaryTextColor: resolvedTheme === "dark" ? "#f8fafc" : "#0f172a",
            lineColor: "#14b8a6",
            secondaryColor: resolvedTheme === "dark" ? "#0f172a" : "#ffffff",
            tertiaryColor: resolvedTheme === "dark" ? "#334155" : "#f1f5f9",
          },
        });

        const id = `mermaid-${Math.random().toString(36).substring(2, 9)}`;
        const { svg } = await mermaid.render(id, chart);
        if (isMounted) {
          setSvgContent(svg);
        }
      } catch (err: any) {
        if (isMounted) {
          console.error("Mermaid rendering error:", err);
          setError("Failed to render diagram. Please check syntax.");
        }
      }
    };

    renderChart();
    return () => {
      isMounted = false;
    };
  }, [chart, resolvedTheme]);

  const handleZoomIn = () => setScale((prev) => Math.min(prev + 0.2, 2.5));
  const handleZoomOut = () => setScale((prev) => Math.max(prev - 0.2, 0.5));
  const handleReset = () => setScale(1);

  return (
    <div
      className={`glass-card rounded-2xl p-6 border border-border transition-all duration-300 ${
        isExpanded
          ? "fixed inset-4 z-50 flex flex-col bg-background/95 backdrop-blur-2xl shadow-2xl overflow-hidden"
          : "relative overflow-hidden my-8"
      }`}
    >
      <div className="flex items-center justify-between pb-4 border-b border-border mb-4">
        <div className="flex items-center gap-3">
          <div className="w-3 h-3 rounded-full bg-primary" />
          <h4 className="font-semibold text-sm md:text-base text-foreground">
            {title || "System Architecture Flow"}
          </h4>
        </div>
        <div className="flex items-center gap-1 bg-muted/50 p-1 rounded-lg border border-border/50">
          <button
            onClick={handleZoomIn}
            className="p-1.5 rounded-md hover:bg-background text-muted-foreground hover:text-foreground transition-colors"
            title="Zoom In"
          >
            <ZoomIn className="w-4 h-4" />
          </button>
          <button
            onClick={handleZoomOut}
            className="p-1.5 rounded-md hover:bg-background text-muted-foreground hover:text-foreground transition-colors"
            title="Zoom Out"
          >
            <ZoomOut className="w-4 h-4" />
          </button>
          <button
            onClick={handleReset}
            className="p-1.5 rounded-md hover:bg-background text-muted-foreground hover:text-foreground transition-colors"
            title="Reset Zoom"
          >
            <RotateCcw className="w-4 h-4" />
          </button>
          <div className="w-px h-4 bg-border mx-1" />
          <button
            onClick={() => setIsExpanded(!isExpanded)}
            className="p-1.5 rounded-md hover:bg-background text-muted-foreground hover:text-foreground transition-colors"
            title={isExpanded ? "Minimize" : "Maximize"}
          >
            {isExpanded ? (
              <Minimize2 className="w-4 h-4" />
            ) : (
              <Maximize2 className="w-4 h-4" />
            )}
          </button>
        </div>
      </div>

      <div
        ref={containerRef}
        className={`flex justify-center items-center overflow-auto p-4 transition-transform duration-200 ${
          isExpanded ? "flex-1 max-h-[80vh]" : "max-h-[500px]"
        }`}
      >
        {error ? (
          <div className="text-danger text-sm p-4 text-center bg-danger/10 rounded-lg w-full">
            {error}
          </div>
        ) : svgContent ? (
          <div
            style={{ transform: `scale(${scale})`, transformOrigin: "center" }}
            className="transition-transform duration-200 w-full flex justify-center"
            dangerouslySetInnerHTML={{ __html: svgContent }}
          />
        ) : (
          <div className="flex items-center justify-center py-16 text-muted-foreground gap-2">
            <div className="w-5 h-5 border-2 border-primary border-t-transparent rounded-full animate-spin" />
            <span className="text-sm font-medium">Rendering AI Architecture...</span>
          </div>
        )}
      </div>
    </div>
  );
}
