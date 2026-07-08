import React from "react";
import { DOCS_ARTICLES } from "../../../lib/docs-data";
import DocArticlePageClient from "./page-client";

export function generateStaticParams() {
  return Object.keys(DOCS_ARTICLES).map((slug) => ({
    slug: slug,
  }));
}

interface PageProps {
  params: Promise<{
    slug: string;
  }>;
}

export default async function Page({ params }: PageProps) {
  const resolvedParams = await params;
  return <DocArticlePageClient slug={resolvedParams.slug} />;
}
