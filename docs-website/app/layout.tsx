import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "../components/ui/theme-provider";
import { Navbar } from "../components/layout/navbar";
import { Footer } from "../components/layout/footer";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  title: "JanSetu AI | AI Powered Constituency Development Intelligence",
  description:
    "Official Architecture & Documentation Platform for JanSetu AI. Empowering Citizens. Enabling Smarter Governance through multimodal AI, automated priority scoring, and real-time digital twins.",
  keywords: [
    "JanSetu AI",
    "Constituency Development Platform",
    "AI Governance",
    "Google Gemini",
    "Flutter",
    "Digital Twin",
    "India Democracy",
    "Civic Tech",
  ],
  authors: [{ name: "JanSetu AI Architecture Team" }],
  openGraph: {
    title: "JanSetu AI | AI Powered Constituency Development Intelligence",
    description:
      "Transforming Citizen Voices into Smarter Governance using Artificial Intelligence. Discover the end-to-end architecture and documentation.",
    type: "website",
    siteName: "JanSetu AI Documentation",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${inter.variable} font-sans antialiased bg-background text-foreground min-h-screen flex flex-col`}>
        <ThemeProvider
          attribute="class"
          defaultTheme="light"
          enableSystem
          disableTransitionOnChange
        >
          <Navbar />
          <main className="flex-1">{children}</main>
          <Footer />
        </ThemeProvider>
      </body>
    </html>
  );
}
