/**
 * Batch Firestore Seeder Script for State: Gujarat
 * Reads generated JSON files from data/synthetic_gujarat/ and commits batch writes to Firestore.
 */

import * as fs from 'fs';
import * as path from 'path';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK (will connect to emulator if FIRESTORE_EMULATOR_HOST is set)
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

async function seedCollection(collectionName: string, idField: string, dataFilePath: string) {
  if (!fs.existsSync(dataFilePath)) {
    console.error(`❌ File not found: ${dataFilePath}. Run 'npm run generate' first.`);
    return;
  }

  const records = JSON.parse(fs.readFileSync(dataFilePath, 'utf8'));
  console.log(`📦 Seeding ${records.length} documents into collection '/${collectionName}'...`);

  let batch = db.batch();
  let count = 0;
  let total = 0;

  for (const doc of records) {
    const docId = doc[idField];
    if (!docId) {
      console.warn(`⚠️ Skipped record missing ID field '${idField}'`);
      continue;
    }

    const docRef = db.collection(collectionName).doc(docId);
    batch.set(docRef, doc);
    count++;
    total++;

    if (count === 400) { // Firestore batch limit is 500
      await batch.commit();
      console.log(`   committed batch of 400 records... (${total}/${records.length})`);
      batch = db.batch();
      count = 0;
    }
  }

  if (count > 0) {
    await batch.commit();
  }

  console.log(`✅ Successfully seeded ${total} documents into '/${collectionName}'.\n`);
}

async function main() {
  console.log("🔥 Starting JanSetu AI Enterprise Firestore Batch Seeder...");
  const dataDir = path.resolve(__dirname, '../../../data/synthetic_gujarat');

  await seedCollection('locations', 'locationId', path.join(dataDir, 'locations.json'));
  await seedCollection('digital_twins', 'twinId', path.join(dataDir, 'digital_twins.json'));
  await seedCollection('users', 'userId', path.join(dataDir, 'users.json'));
  await seedCollection('needs', 'needId', path.join(dataDir, 'needs.json'));
  await seedCollection('projects', 'projectId', path.join(dataDir, 'projects.json'));
  await seedCollection('assets', 'assetId', path.join(dataDir, 'assets.json'));

  console.log("🎉 ALL FIRESTORE COLLECTIONS SUCCESSFULLY SEEDED!");
}

main().catch(err => {
  console.error("❌ Seeding failed:", err);
  process.exit(1);
});
