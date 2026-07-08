/**
 * CLI Execution Script: Generates all synthetic JSON datasets for State: Gujarat
 * Writes formatted JSON files directly to data/synthetic_gujarat/ in the workspace root.
 */

import * as fs from 'fs';
import * as path from 'path';
import { generateLocations, generateDigitalTwins, generateUsers, generateNeeds, generateProjects, generateAssets } from './generators';

async function main() {
  console.log("🚀 Starting JanSetu AI Synthetic Data Generation for State: Gujarat (STA-GUJ-0001)...");

  const outputDir = path.resolve(__dirname, '../../../data/synthetic_gujarat');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
    console.log(`📁 Created target directory: ${outputDir}`);
  }

  // 1. Generate Locations (1 State + 5 Districts + 5 PCs + 50 Wards = 61 total)
  console.log("⚙️ Generating 11-Tier Location Hierarchy...");
  const locations = generateLocations();
  fs.writeFileSync(path.join(outputDir, 'locations.json'), JSON.stringify(locations, null, 2), 'utf8');
  console.log(`✅ Saved ${locations.length} location records to locations.json.`);

  // 2. Generate Digital Twins (50 reactive documents)
  console.log("⚙️ Generating Universal Digital Twins...");
  const digitalTwins = generateDigitalTwins(locations);
  fs.writeFileSync(path.join(outputDir, 'digital_twins.json'), JSON.stringify(digitalTwins, null, 2), 'utf8');
  console.log(`✅ Saved ${digitalTwins.length} digital twin documents to digital_twins.json.`);

  // 3. Generate Users (555 stakeholders: 500 Citizens, 30 Officers, 20 Contractors, 5 MPs)
  console.log("⚙️ Generating Stakeholder Profiles & RBAC Identities...");
  const users = generateUsers();
  fs.writeFileSync(path.join(outputDir, 'users.json'), JSON.stringify(users, null, 2), 'utf8');
  console.log(`✅ Saved ${users.length} user profiles to users.json.`);

  // 4. Generate Development Needs (300 grievances)
  console.log("⚙️ Generating Multimodal Development Needs...");
  const needs = generateNeeds(locations, users, 300);
  fs.writeFileSync(path.join(outputDir, 'needs.json'), JSON.stringify(needs, null, 2), 'utf8');
  console.log(`✅ Saved ${needs.length} development needs to needs.json.`);

  // 5. Generate Sanctioned Projects (75 capital works)
  console.log("⚙️ Generating Sanctioned Capital Projects & Escrow Milestones...");
  const projects = generateProjects(locations, users, 75);
  fs.writeFileSync(path.join(outputDir, 'projects.json'), JSON.stringify(projects, null, 2), 'utf8');
  console.log(`✅ Saved ${projects.length} project ledgers to projects.json.`);

  // 6. Generate Government Assets (100 infrastructure assets)
  console.log("⚙️ Generating Physical Infrastructure Assets Registry...");
  const assets = generateAssets(locations, 100);
  fs.writeFileSync(path.join(outputDir, 'assets.json'), JSON.stringify(assets, null, 2), 'utf8');
  console.log(`✅ Saved ${assets.length} infrastructure assets to assets.json.`);

  // Generate Master Summary Manifest
  const manifest = {
    generatedAt: new Date().toISOString(),
    state: "Gujarat (STA-GUJ-0001)",
    totalDocuments: locations.length + digitalTwins.length + users.length + needs.length + projects.length + assets.length,
    counts: {
      locations: locations.length,
      digitalTwins: digitalTwins.length,
      users: users.length,
      needs: needs.length,
      projects: projects.length,
      assets: assets.length
    },
    version: "2.0.0-Enterprise"
  };
  fs.writeFileSync(path.join(outputDir, 'manifest.json'), JSON.stringify(manifest, null, 2), 'utf8');

  console.log("\n🎉 SYNTHETIC DATA GENERATION COMPLETE!");
  console.log(`📊 Total Enterprise Documents Generated: ${manifest.totalDocuments}`);
  console.log(`📂 Output Directory: ${outputDir}`);
}

main().catch(err => {
  console.error("❌ Error generating synthetic data:", err);
  process.exit(1);
});
