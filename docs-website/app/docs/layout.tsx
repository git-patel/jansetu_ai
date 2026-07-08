import React from "react";
import { DocsSidebar } from "../../components/docs/sidebar";

export default function DocsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen pt-20 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="flex flex-col lg:flex-row gap-8 items-start">
        <DocsSidebar />
        <main className="flex-1 w-full min-w-0 py-8">{children}</main>
      </div>
    </div>
  );
}
