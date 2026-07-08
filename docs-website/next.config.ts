import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  images: {
    unoptimized: true,
  },
  // Ensure that dynamic asset paths work under subfolders if deployed to a project path
  basePath: process.env.NEXT_PUBLIC_BASE_PATH || "",
};

export default nextConfig;
