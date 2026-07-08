/**
 * Core Synthetic Generation Algorithms for State: Gujarat
 * Generates enterprise NoSQL documents strictly conforming to JanSetu AI NoSQL schemas.
 */

import { GUJARAT_STATE_ROOT, GUJARAT_DISTRICTS, GUJARATI_SURNAMES, GUJARATI_MALE_FIRSTNAMES, GUJARATI_FEMALE_FIRSTNAMES, GUJARAT_DEPARTMENTS } from './data-banks';

function randomChoice<T>(arr: T[] | readonly T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

function randomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomFloat(min: number, max: number, decimals: number = 2): number {
  const val = Math.random() * (max - min) + min;
  return Number(val.toFixed(decimals));
}

export function generateLocations() {
  const locations: any[] = [GUJARAT_STATE_ROOT];

  for (const dist of GUJARAT_DISTRICTS) {
    const distLoc = {
      locationId: dist.districtId,
      tier: "DISTRICT",
      nameEnglish: dist.nameEnglish,
      nameVernacular: dist.nameVernacular,
      parentLocationId: GUJARAT_STATE_ROOT.locationId,
      ancestries: [GUJARAT_STATE_ROOT.locationId],
      geohash: "te",
      centroid: { latitude: dist.wards[0]?.lat || 22.0, longitude: dist.wards[0]?.lng || 72.0 },
      boundingPolygon: [],
      metadata: { totalVoters: 2500000, activeProjectsCount: 75 }
    };
    locations.push(distLoc);

    const pcLoc = {
      locationId: dist.pc.pcId,
      tier: "PARLIAMENTARY_CONSTITUENCY",
      nameEnglish: dist.pc.nameEnglish,
      nameVernacular: dist.pc.nameVernacular,
      parentLocationId: dist.districtId,
      ancestries: [GUJARAT_STATE_ROOT.locationId, dist.districtId],
      geohash: "te",
      centroid: { latitude: dist.wards[0]?.lat || 22.0, longitude: dist.wards[0]?.lng || 72.0 },
      boundingPolygon: [],
      metadata: { mpUserId: dist.pc.mp.userId, mpName: dist.pc.mp.name, totalVoters: 1800000 }
    };
    locations.push(pcLoc);

    for (const ward of dist.wards) {
      const wardLoc = {
        locationId: ward.wardId,
        tier: ward.isUrban ? "MUNICIPAL_WARD" : "VILLAGE_PANCHAYAT",
        nameEnglish: ward.nameEnglish,
        nameVernacular: ward.nameVernacular,
        parentLocationId: dist.pc.pcId,
        ancestries: [GUJARAT_STATE_ROOT.locationId, dist.districtId, dist.pc.pcId],
        geohash: ward.geohash,
        centroid: { latitude: ward.lat, longitude: ward.lng },
        boundingPolygon: [
          { latitude: ward.lat - 0.02, longitude: ward.lng - 0.02 },
          { latitude: ward.lat + 0.02, longitude: ward.lng - 0.02 },
          { latitude: ward.lat + 0.02, longitude: ward.lng + 0.02 },
          { latitude: ward.lat - 0.02, longitude: ward.lng + 0.02 }
        ],
        metadata: {
          isUrban: ward.isUrban,
          population: ward.population,
          voterCount: ward.voterCount,
          activeProjectsCount: randomInt(1, 5)
        }
      };
      locations.push(wardLoc);
    }
  }

  return locations;
}

export function generateDigitalTwins(locations: any[]) {
  const twins: any[] = [];
  const wardLocations = locations.filter(l => l.tier === "MUNICIPAL_WARD" || l.tier === "VILLAGE_PANCHAYAT");

  for (const ward of wardLocations) {
    const waterScore = randomFloat(60, 98);
    const roadScore = randomFloat(55, 95);
    const healthScore = randomFloat(65, 96);
    const eduScore = randomFloat(70, 99);
    const overallScore = Number(((waterScore + roadScore + healthScore + eduScore) / 4).toFixed(1));

    const twin = {
      twinId: ward.locationId,
      locationId: ward.locationId,
      locationName: ward.nameEnglish,
      lastUpdatedTimestamp: Math.floor(Date.now() / 1000) - randomInt(3600, 86400),
      metrics: {
        populationDensityPerSqKm: randomInt(3000, 15000),
        waterSupplyCompliancePercent: waterScore,
        roadNetworkHealthIndex: roadScore,
        healthcareAccessScore: healthScore,
        educationInfrastructureScore: eduScore,
        activeGrievancesCount: randomInt(5, 25),
        resolvedGrievances30Days: randomInt(15, 60),
        averageSlaResolutionHours: randomInt(24, 120),
        budgetUtilizationPercent: randomFloat(65, 94)
      },
      aiDevelopmentScore: overallScore,
      priorityDeficitDepartments: overallScore < 75 ? ["DEPT_ROADS_HIGHWAYS", "DEPT_WATER_SUPPLY"] : [],
      simulationStatus: "ACTIVE_LIVE"
    };
    twins.push(twin);
  }

  return twins;
}

export function generateUsers() {
  const users: any[] = [];
  let citIndex = 1;

  // 1. Generate 5 MPs
  for (const dist of GUJARAT_DISTRICTS) {
    const mp = {
      userId: dist.pc.mp.userId,
      fullName: dist.pc.mp.name,
      phoneNumber: dist.pc.mp.phone,
      primaryRole: "MEMBER_OF_PARLIAMENT",
      secondaryRoles: ["CITIZEN"],
      languagePreference: "gu",
      mpProfile: {
        assignedPcId: dist.pc.pcId,
        politicalParty: dist.pc.mp.party,
        officeAddress: `MP Secretariat Office, ${dist.nameEnglish}`,
        sanctionedMpladsBudgetINR: 50000000.0,
        utilizedMpladsBudgetINR: randomFloat(15000000, 38000000)
      },
      isActive: true,
      createdAt: Math.floor(Date.now() / 1000) - 86400 * 180
    };
    users.push(mp);
  }

  // 2. Generate 30 Field Officers (6 per District)
  let offIndex = 1;
  for (const dist of GUJARAT_DISTRICTS) {
    for (let i = 0; i < 6; i++) {
      const dept = GUJARAT_DEPARTMENTS[i % GUJARAT_DEPARTMENTS.length];
      const ward = dist.wards[i % dist.wards.length];
      const gender = i % 2 === 0 ? "MALE" : "FEMALE";
      const fname = gender === "MALE" ? randomChoice(GUJARATI_MALE_FIRSTNAMES) : randomChoice(GUJARATI_FEMALE_FIRSTNAMES);
      const sname = randomChoice(GUJARATI_SURNAMES);
      const offId = `USR-OFF-${dist.nameEnglish.substring(0, 3).toUpperCase()}-${String(offIndex++).padStart(3, '0')}`;

      const officer = {
        userId: offId,
        fullName: `Er. ${fname} ${sname}`,
        phoneNumber: `+9198251${String(offIndex).padStart(5, '0')}`,
        primaryRole: "OFFICER_FIELD_INSPECTOR",
        secondaryRoles: ["CITIZEN"],
        languagePreference: "gu",
        officerProfile: {
          departmentId: dept.departmentId,
          designationTitle: "Executive Engineer (Sub-Division)",
          assignedJurisdictionLocationIds: [ward.wardId, dist.pc.pcId],
          geofencingRadiusMeters: 50,
          pendingInspectionsCount: randomInt(1, 6),
          completedInspectionsCount: randomInt(15, 80)
        },
        isActive: true,
        createdAt: Math.floor(Date.now() / 1000) - 86400 * 365
      };
      users.push(officer);
    }
  }

  // 3. Generate 20 Contractors (4 per District)
  let conIndex = 1;
  const companyPrefixes = ["Sardar", "Narmada", "Somnath", "Girnar", "Ambaji", "Sahajanand", "Surya", "Mahadev", "Balaji", "Krishna"];
  for (const dist of GUJARAT_DISTRICTS) {
    for (let i = 0; i < 4; i++) {
      const compName = `${randomChoice(companyPrefixes)} Construction & Infrastructure Pvt Ltd`;
      const conId = `USR-CON-${dist.nameEnglish.substring(0, 3).toUpperCase()}-${String(conIndex++).padStart(3, '0')}`;

      const contractor = {
        userId: conId,
        fullName: compName,
        phoneNumber: `+9198252${String(conIndex).padStart(5, '0')}`,
        primaryRole: "CONTRACTOR",
        secondaryRoles: [],
        languagePreference: "gu",
        contractorProfile: {
          companyName: compName,
          gstin: `24AAACS${randomInt(1000, 9999)}H1Z${i}`,
          licenseGrade: "CLASS_A_PWD",
          registeredAddress: `Titanium Commercial Center, ${dist.nameEnglish}`,
          historicalPerformanceRating: randomFloat(4.1, 4.9, 2),
          activeProjectIds: []
        },
        isActive: true,
        createdAt: Math.floor(Date.now() / 1000) - 86400 * 500
      };
      users.push(contractor);
    }
  }

  // 4. Generate 500 Verified Citizens (100 per District)
  for (const dist of GUJARAT_DISTRICTS) {
    for (let i = 0; i < 100; i++) {
      const ward = dist.wards[i % dist.wards.length];
      const gender = i % 2 === 0 ? "MALE" : "FEMALE";
      const fname = gender === "MALE" ? randomChoice(GUJARATI_MALE_FIRSTNAMES) : randomChoice(GUJARATI_FEMALE_FIRSTNAMES);
      const sname = randomChoice(GUJARATI_SURNAMES);
      const citId = `USR-CIT-${dist.nameEnglish.substring(0, 3).toUpperCase()}-${String(citIndex++).padStart(4, '0')}`;
      const lang = randomChoice(["gu", "gu", "gu", "gu", "hi", "en"]);

      const citizen = {
        userId: citId,
        fullName: `${fname}bhai ${sname}`,
        phoneNumber: `+9198253${String(citIndex).padStart(5, '0')}`,
        primaryRole: "CITIZEN",
        secondaryRoles: [],
        languagePreference: lang,
        citizenIdentity: {
          verifiedHomePcId: dist.pc.pcId,
          verifiedHomeWardId: ward.wardId,
          voterIdHash: `hash_${citId}_${Math.random().toString(36).substring(7)}`,
          lastGpsReportingLocation: {
            latitude: ward.lat + randomFloat(-0.01, 0.01, 4),
            longitude: ward.lng + randomFloat(-0.01, 0.01, 4),
            timestamp: Math.floor(Date.now() / 1000) - randomInt(60, 86400)
          }
        },
        isActive: true,
        createdAt: Math.floor(Date.now() / 1000) - 86400 * randomInt(1, 300)
      };
      users.push(citizen);
    }
  }

  return users;
}

export function generateNeeds(locations: any[], users: any[], count: number = 300) {
  const needs: any[] = [];
  const wardLocations = locations.filter(l => l.tier === "MUNICIPAL_WARD" || l.tier === "VILLAGE_PANCHAYAT");
  const citizens = users.filter(u => u.primaryRole === "CITIZEN");
  const officers = users.filter(u => u.primaryRole === "OFFICER_FIELD_INSPECTOR");

  const statuses = ["SUBMITTED_AI_PROCESSING", "ROUTED_TO_DEPARTMENT", "UNDER_INSPECTION", "IN_PROGRESS", "RESOLVED_VERIFIED", "REJECTED_AUDITED"];

  for (let i = 1; i <= count; i++) {
    const ward = randomChoice(wardLocations);
    const dept = randomChoice(GUJARAT_DEPARTMENTS);
    const sample = randomChoice(dept.sampleTitles);
    const reporter = randomChoice(citizens);
    const officer = officers.find(o => o.officerProfile.departmentId === dept.departmentId) || randomChoice(officers);
    const status = randomChoice(statuses);

    const needId = `NED-GUJ-${String(i).padStart(4, '0')}`;
    const timestamp = Math.floor(Date.now() / 1000) - randomInt(3600, 86400 * 30);

    const need = {
      needId: needId,
      titleEnglish: `${sample.en} (${ward.nameEnglish})`,
      titleVernacular: `${sample.gu} (${ward.nameVernacular})`,
      descriptionVernacular: `${sample.gu}. તાત્કાલિક ધોરણે સમારકામ કરવા વિનંતી છે.`,
      category: dept.categoryCode,
      departmentId: dept.departmentId,
      location: {
        stateId: GUJARAT_STATE_ROOT.locationId,
        districtId: ward.ancestries[1] || "DIS-GUJ-SRT-0001",
        constituencyId: ward.parentLocationId,
        wardId: ward.locationId,
        gpsCoordinate: {
          latitude: ward.centroid.latitude + randomFloat(-0.005, 0.005, 4),
          longitude: ward.centroid.longitude + randomFloat(-0.005, 0.005, 4)
        },
        geohash: ward.geohash
      },
      reportedByUserId: reporter.userId,
      assignedOfficerId: officer.userId,
      status: status,
      priorityScore: sample.priority + randomFloat(-3.0, 3.0, 1),
      estimatedBudgetINR: sample.costINR,
      upvoteCount: randomInt(12, 350),
      aiAnalysis: {
        confidenceScore: randomFloat(0.88, 0.99, 2),
        translatedSummary: `AI Verified: Public infrastructure issue reported by citizen in ${ward.nameEnglish}. Routed to ${dept.nameEnglish}.`,
        duplicateClusterId: i % 10 === 0 ? `CLU-${Math.floor(i/10)}` : null,
        isDuplicate: i % 10 === 0
      },
      attachments: [
        { uri: `gs://jansetu-evidence/${needId}/photo_1.jpg`, type: "IMAGE", timestamp: timestamp },
        { uri: `gs://jansetu-evidence/${needId}/voice_note.mp3`, type: "AUDIO_VOICE", timestamp: timestamp }
      ],
      createdAtTimestamp: timestamp,
      updatedAtTimestamp: timestamp + randomInt(3600, 86400)
    };
    needs.push(need);
  }

  return needs;
}

export function generateProjects(locations: any[], users: any[], count: number = 75) {
  const projects: any[] = [];
  const wardLocations = locations.filter(l => l.tier === "MUNICIPAL_WARD" || l.tier === "VILLAGE_PANCHAYAT");
  const contractors = users.filter(u => u.primaryRole === "CONTRACTOR");
  const officers = users.filter(u => u.primaryRole === "OFFICER_FIELD_INSPECTOR");

  const projectStatuses = ["SANCTIONED_ESTIMATED", "TENDER_FLOAT", "WORK_ORDER_AWARDED", "IN_EXECUTION", "MILESTONE_1_VERIFIED", "MILESTONE_2_VERIFIED", "COMPLETED_AUDITED"];

  for (let i = 1; i <= count; i++) {
    const ward = randomChoice(wardLocations);
    const dept = randomChoice(GUJARAT_DEPARTMENTS);
    const sample = randomChoice(dept.sampleTitles);
    const contractor = randomChoice(contractors);
    const officer = officers.find(o => o.officerProfile.departmentId === dept.departmentId) || randomChoice(officers);
    const status = randomChoice(projectStatuses);
    const totalBudget = sample.costINR * randomInt(2, 5);

    const prjId = `PRJ-GUJ-${String(i).padStart(4, '0')}`;
    const timestamp = Math.floor(Date.now() / 1000) - randomInt(86400 * 30, 86400 * 180);

    const prj = {
      projectId: prjId,
      projectName: `Capital Works: ${sample.en} at ${ward.nameEnglish}`,
      departmentId: dept.departmentId,
      location: {
        stateId: GUJARAT_STATE_ROOT.locationId,
        districtId: ward.ancestries[1] || "DIS-GUJ-SRT-0001",
        pcId: ward.parentLocationId,
        wardId: ward.locationId
      },
      ownership: {
        sanctionedByAuthorityId: `USR-MP-${ward.parentLocationId.substring(7, 10)}`,
        responsibleOfficerId: officer.userId,
        assignedContractorId: contractor.userId
      },
      financials: {
        sanctionedBudgetINR: totalBudget,
        disbursedAmountINR: status === "COMPLETED_AUDITED" ? totalBudget : Math.floor(totalBudget * 0.4),
        escrowAccountReference: `ESCROW-SBI-${prjId}`
      },
      currentStatus: status,
      progressPercentage: status === "COMPLETED_AUDITED" ? 100 : (status === "IN_EXECUTION" ? 40 : 15),
      milestones: [
        {
          milestoneIndex: 1,
          title: "Site Excavation, Material Inspection & Foundation Preparation",
          weightagePercent: 40,
          status: status === "COMPLETED_AUDITED" || status === "MILESTONE_1_VERIFIED" ? "VERIFIED_AND_PAID" : "PENDING_INSPECTION",
          paymentTrancheINR: Math.floor(totalBudget * 0.4)
        },
        {
          milestoneIndex: 2,
          title: "Core Infrastructure Laying & Structural Construction",
          weightagePercent: 40,
          status: status === "COMPLETED_AUDITED" ? "VERIFIED_AND_PAID" : "PENDING",
          paymentTrancheINR: Math.floor(totalBudget * 0.4)
        },
        {
          milestoneIndex: 3,
          title: "Final Finishing, Quality Audit & Commissioning Handover",
          weightagePercent: 20,
          status: status === "COMPLETED_AUDITED" ? "VERIFIED_AND_PAID" : "PENDING",
          paymentTrancheINR: Math.floor(totalBudget * 0.2)
        }
      ],
      sanctionedAtTimestamp: timestamp,
      expectedCompletionTimestamp: timestamp + 86400 * 120
    };
    projects.push(prj);
  }

  return projects;
}

export function generateAssets(locations: any[], count: number = 100) {
  const assets: any[] = [];
  const wardLocations = locations.filter(l => l.tier === "MUNICIPAL_WARD" || l.tier === "VILLAGE_PANCHAYAT");
  const assetTypes = [
    { type: "OVERHEAD_WATER_TANK", name: "50,000 Liter RCC Overhead Water Storage Tank", dept: "DEPT_WATER_SUPPLY" },
    { type: "PRIMARY_HEALTH_CENTER", name: "Government Primary Health Center (PHC) & Dispensary", dept: "DEPT_PRIMARY_HEALTH" },
    { type: "MUNICIPAL_SCHOOL", name: "Samagra Shiksha Prathmik Shala (School Building)", dept: "DEPT_PRIMARY_EDUCATION" },
    { type: "ELECTRIC_SUBSTATION", name: "11KV Distribution Transformer & Feeder Pillar", dept: "DEPT_ELECTRICITY" },
    { type: "COMMUNITY_HALL", name: "Panchayat Community Hall & Civic Center", dept: "DEPT_ROADS_HIGHWAYS" }
  ];

  for (let i = 1; i <= count; i++) {
    const ward = randomChoice(wardLocations);
    const assetSpec = randomChoice(assetTypes);
    const assetId = `AST-GUJ-${String(i).padStart(4, '0')}`;

    const asset = {
      assetId: assetId,
      assetName: `${assetSpec.name} - ${ward.nameEnglish}`,
      assetType: assetSpec.type,
      departmentId: assetSpec.dept,
      location: {
        wardId: ward.locationId,
        gpsCoordinate: {
          latitude: ward.centroid.latitude + randomFloat(-0.003, 0.003, 4),
          longitude: ward.centroid.longitude + randomFloat(-0.003, 0.003, 4)
        },
        geohash: ward.geohash
      },
      healthIndexScore: randomFloat(60, 98, 1),
      lastInspectionTimestamp: Math.floor(Date.now() / 1000) - randomInt(86400 * 10, 86400 * 90),
      nextMaintenanceDueTimestamp: Math.floor(Date.now() / 1000) + randomInt(86400 * 30, 86400 * 180),
      status: "OPERATIONAL"
    };
    assets.push(asset);
  }

  return assets;
}
