/**
 * Master Data Banks for State: Gujarat (STA-GUJ-0001) Synthetic Data Generation Engine
 * Defines authentic Gujarati demographics, location taxonomies, MP profiles, and 21+ department rules.
 */

export const GUJARAT_STATE_ROOT = {
  locationId: "STA-GUJ-0001",
  tier: "STATE",
  nameEnglish: "Gujarat",
  nameVernacular: "ગુજરાત",
  parentLocationId: "IND-0000",
  ancestries: ["IND-0000"],
  geohash: "ts",
  centroid: { latitude: 22.2587, longitude: 71.1924 },
  boundingPolygon: [
    { latitude: 20.1, longitude: 68.1 },
    { latitude: 24.7, longitude: 68.1 },
    { latitude: 24.7, longitude: 74.4 },
    { latitude: 20.1, longitude: 74.4 }
  ],
  metadata: { censusCode: "GJ", totalVoters: 49000000, activeProjectsCount: 375 }
};

export interface DistrictSpec {
  districtId: string;
  nameEnglish: string;
  nameVernacular: string;
  pc: {
    pcId: string;
    nameEnglish: string;
    nameVernacular: string;
    mp: {
      userId: string;
      name: string;
      party: string;
      phone: string;
      photoUrl: string;
    };
  };
  wards: Array<{
    wardId: string;
    nameEnglish: string;
    nameVernacular: string;
    isUrban: boolean;
    lat: number;
    lng: number;
    geohash: string;
    population: number;
    voterCount: number;
  }>;
}

export const GUJARAT_DISTRICTS: DistrictSpec[] = [
  {
    districtId: "DIS-GUJ-AHM-0001",
    nameEnglish: "Ahmedabad",
    nameVernacular: "અમદાવાદ",
    pc: {
      pcId: "PC-GUJ-AHM-0001",
      nameEnglish: "Ahmedabad West",
      nameVernacular: "અમદાવાદ પશ્ચિમ",
      mp: {
        userId: "USR-MP-AHM-001",
        name: "Hon. Kirit Solanki",
        party: "BJP",
        phone: "+919825010001",
        photoUrl: "https://jansetu.gov.in/assets/mps/kirit_solanki.jpg"
      }
    },
    wards: [
      { wardId: "WRD-AHM-01", nameEnglish: "Navrangpura Ward", nameVernacular: "નવરંગપુરા વૉર્ડ", isUrban: true, lat: 23.0365, lng: 72.5611, geohash: "ts5e", population: 45000, voterCount: 31000 },
      { wardId: "WRD-AHM-02", nameEnglish: "Paldi Ward", nameVernacular: "પાલડી વૉર્ડ", isUrban: true, lat: 23.0120, lng: 72.5626, geohash: "ts5e", population: 52000, voterCount: 36000 },
      { wardId: "WRD-AHM-03", nameEnglish: "Satellite Ward", nameVernacular: "સેટેલાઈટ વૉર્ડ", isUrban: true, lat: 23.0282, lng: 72.5186, geohash: "ts5e", population: 68000, voterCount: 47000 },
      { wardId: "WRD-AHM-04", nameEnglish: "Vastrapur Ward", nameVernacular: "વસ્ત્રાપુર વૉર્ડ", isUrban: true, lat: 23.0380, lng: 72.5250, geohash: "ts5e", population: 41000, voterCount: 29000 },
      { wardId: "WRD-AHM-05", nameEnglish: "Maninagar Ward", nameVernacular: "મણિનગર વૉર્ડ", isUrban: true, lat: 22.9961, lng: 72.6047, geohash: "ts5e", population: 75000, voterCount: 52000 },
      { wardId: "WRD-AHM-06", nameEnglish: "Ghatlodia Ward", nameVernacular: "ઘાટલોડિયા વૉર્ડ", isUrban: true, lat: 23.0722, lng: 72.5367, geohash: "ts5e", population: 64000, voterCount: 44000 },
      { wardId: "VIL-AHM-07", nameEnglish: "Sanand Town", nameVernacular: "સણંદ નગર", isUrban: false, lat: 22.9912, lng: 72.3813, geohash: "ts5c", population: 28000, voterCount: 19000 },
      { wardId: "VIL-AHM-08", nameEnglish: "Bavla Town", nameVernacular: "બાવળા નગર", isUrban: false, lat: 22.8361, lng: 72.3683, geohash: "ts5c", population: 31000, voterCount: 21000 },
      { wardId: "VIL-AHM-09", nameEnglish: "Dholka Town", nameVernacular: "ધોળકા નગર", isUrban: false, lat: 22.7247, lng: 72.4647, geohash: "ts59", population: 35000, voterCount: 24000 },
      { wardId: "VIL-AHM-10", nameEnglish: "Viramgam Town", nameVernacular: "વિરમગામ નગર", isUrban: false, lat: 23.1235, lng: 72.0465, geohash: "ts5d", population: 29000, voterCount: 20000 }
    ]
  },
  {
    districtId: "DIS-GUJ-SRT-0001",
    nameEnglish: "Surat",
    nameVernacular: "સુરત",
    pc: {
      pcId: "PC-GUJ-SRT-0001",
      nameEnglish: "Surat Parliamentary Constituency",
      nameVernacular: "સુરત સંસદીય મતવિસ્તાર",
      mp: {
        userId: "USR-MP-SRT-001",
        name: "Hon. C. R. Patil",
        party: "BJP",
        phone: "+919825010002",
        photoUrl: "https://jansetu.gov.in/assets/mps/cr_patil.jpg"
      }
    },
    wards: [
      { wardId: "WRD-SRT-11", nameEnglish: "Adajan Ward 14", nameVernacular: "અડાજણ વૉર્ડ ૧૪", isUrban: true, lat: 21.1889, lng: 72.7935, geohash: "tehe", population: 82000, voterCount: 58000 },
      { wardId: "WRD-SRT-12", nameEnglish: "Pal Ward 15", nameVernacular: "પાલ વૉર્ડ ૧૫", isUrban: true, lat: 21.1710, lng: 72.7720, geohash: "tehe", population: 64000, voterCount: 45000 },
      { wardId: "WRD-SRT-13", nameEnglish: "Varachha Ward 08", nameVernacular: "વરાછા વૉર્ડ ૦૮", isUrban: true, lat: 21.2180, lng: 72.8820, geohash: "tehs", population: 110000, voterCount: 78000 },
      { wardId: "WRD-SRT-14", nameEnglish: "Vesu Ward 21", nameVernacular: "વેસુ વૉર્ડ ૨૧", isUrban: true, lat: 21.1350, lng: 72.7750, geohash: "tehe", population: 71000, voterCount: 51000 },
      { wardId: "WRD-SRT-15", nameEnglish: "Katargam Ward 05", nameVernacular: "કતારગામ વૉર્ડ ૦૫", isUrban: true, lat: 21.2350, lng: 72.8290, geohash: "tehe", population: 95000, voterCount: 66000 },
      { wardId: "WRD-SRT-16", nameEnglish: "Piplod Ward 18", nameVernacular: "પીપલોદ વૉર્ડ ૧૮", isUrban: true, lat: 21.1560, lng: 72.7680, geohash: "tehe", population: 53000, voterCount: 37000 },
      { wardId: "VIL-SRT-17", nameEnglish: "Bhatha Village", nameVernacular: "ભાઠા ગામ", isUrban: false, lat: 21.1780, lng: 72.7520, geohash: "tehe", population: 18000, voterCount: 12000 },
      { wardId: "VIL-SRT-18", nameEnglish: "Kamrej Town", nameVernacular: "કામરેજ નગર", isUrban: false, lat: 21.2750, lng: 72.9610, geohash: "tehu", population: 42000, voterCount: 29000 },
      { wardId: "VIL-SRT-19", nameEnglish: "Olpad Town", nameVernacular: "ઓલપાડ નગર", isUrban: false, lat: 21.3320, lng: 72.7580, geohash: "tehe", population: 26000, voterCount: 18000 },
      { wardId: "VIL-SRT-20", nameEnglish: "Bardoli Town", nameVernacular: "બારડોલી નગર", isUrban: false, lat: 21.1240, lng: 73.1110, geohash: "tehy", population: 48000, voterCount: 33000 }
    ]
  },
  {
    districtId: "DIS-GUJ-RAK-0001",
    nameEnglish: "Rajkot",
    nameVernacular: "રાજકોટ",
    pc: {
      pcId: "PC-GUJ-RAK-0001",
      nameEnglish: "Rajkot Parliamentary Constituency",
      nameVernacular: "રાજકોટ સંસદીય મતવિસ્તાર",
      mp: {
        userId: "USR-MP-RAK-001",
        name: "Hon. Mohan Kundariya",
        party: "BJP",
        phone: "+919825010003",
        photoUrl: "https://jansetu.gov.in/assets/mps/mohan_kundariya.jpg"
      }
    },
    wards: [
      { wardId: "WRD-RAK-21", nameEnglish: "Amin Marg Ward", nameVernacular: "અમીન માર્ગ વૉર્ડ", isUrban: true, lat: 22.2850, lng: 70.7850, geohash: "tefd", population: 58000, voterCount: 41000 },
      { wardId: "WRD-RAK-22", nameEnglish: "Kalavad Road Ward", nameVernacular: "કાલાવાડ રોડ વૉર્ડ", isUrban: true, lat: 22.2760, lng: 70.7680, geohash: "tefd", population: 62000, voterCount: 43000 },
      { wardId: "WRD-RAK-23", nameEnglish: "University Road Ward", nameVernacular: "યુનિવર્સિટી રોડ વૉર્ડ", isUrban: true, lat: 22.2910, lng: 70.7620, geohash: "tefd", population: 55000, voterCount: 38000 },
      { wardId: "WRD-RAK-24", nameEnglish: "Raiya Road Ward", nameVernacular: "રૈયા રોડ વૉર્ડ", isUrban: true, lat: 22.3080, lng: 70.7710, geohash: "tefe", population: 67000, voterCount: 47000 },
      { wardId: "WRD-RAK-25", nameEnglish: "Bhaktinagar Ward", nameVernacular: "ભક્તિનગર વૉર્ડ", isUrban: true, lat: 22.2800, lng: 70.8120, geohash: "tefd", population: 74000, voterCount: 51000 },
      { wardId: "WRD-RAK-26", nameEnglish: "Kothariya Road Ward", nameVernacular: "કોઠારીયા રોડ વૉર્ડ", isUrban: true, lat: 22.2560, lng: 70.8010, geohash: "tefd", population: 48000, voterCount: 33000 },
      { wardId: "VIL-RAK-27", nameEnglish: "Gondal Town", nameVernacular: "ગોંડલ નગર", isUrban: false, lat: 21.9610, lng: 70.7960, geohash: "tecr", population: 65000, voterCount: 45000 },
      { wardId: "VIL-RAK-28", nameEnglish: "Jasdan Town", nameVernacular: "જસદણ નગર", isUrban: false, lat: 22.0360, lng: 71.2050, geohash: "tefb", population: 44000, voterCount: 31000 },
      { wardId: "VIL-RAK-29", nameEnglish: "Lodhika Village", nameVernacular: "લોધિકા ગામ", isUrban: false, lat: 22.1850, lng: 70.6280, geohash: "tef6", population: 15000, voterCount: 10000 },
      { wardId: "VIL-RAK-30", nameEnglish: "Paddhari Village", nameVernacular: "પડધરી ગામ", isUrban: false, lat: 22.4350, lng: 70.6050, geohash: "tefk", population: 18000, voterCount: 12000 }
    ]
  },
  {
    districtId: "DIS-GUJ-VAD-0001",
    nameEnglish: "Vadodara",
    nameVernacular: "વડોદરા",
    pc: {
      pcId: "PC-GUJ-VAD-0001",
      nameEnglish: "Vadodara Parliamentary Constituency",
      nameVernacular: "વડોદરા સંસદીય મતવિસ્તાર",
      mp: {
        userId: "USR-MP-VAD-001",
        name: "Hon. Ranjanben Bhatt",
        party: "BJP",
        phone: "+919825010004",
        photoUrl: "https://jansetu.gov.in/assets/mps/ranjanben_bhatt.jpg"
      }
    },
    wards: [
      { wardId: "WRD-VAD-31", nameEnglish: "Alkapuri Ward", nameVernacular: "અલકાપુરી વૉર્ડ", isUrban: true, lat: 22.3110, lng: 73.1680, geohash: "tej2", population: 51000, voterCount: 36000 },
      { wardId: "WRD-VAD-32", nameEnglish: "Sayajigunj Ward", nameVernacular: "સયાજીગંજ વૉર્ડ", isUrban: true, lat: 22.3180, lng: 73.1850, geohash: "tej2", population: 59000, voterCount: 41000 },
      { wardId: "WRD-VAD-33", nameEnglish: "Gotri Ward", nameVernacular: "ગોત્રી વૉર્ડ", isUrban: true, lat: 22.3190, lng: 73.1410, geohash: "tej2", population: 64000, voterCount: 45000 },
      { wardId: "WRD-VAD-34", nameEnglish: "Manjalpur Ward", nameVernacular: "માંજલપુર વૉર્ડ", isUrban: true, lat: 22.2750, lng: 73.1950, geohash: "tej0", population: 72000, voterCount: 50000 },
      { wardId: "WRD-VAD-35", nameEnglish: "Karelibaug Ward", nameVernacular: "કારેલીબાગ વૉર્ડ", isUrban: true, lat: 22.3250, lng: 73.2050, geohash: "tej2", population: 68000, voterCount: 48000 },
      { wardId: "WRD-VAD-36", nameEnglish: "Fatehgunj Ward", nameVernacular: "ફતેહગંજ વૉર્ડ", isUrban: true, lat: 22.3320, lng: 73.1890, geohash: "tej2", population: 49000, voterCount: 34000 },
      { wardId: "VIL-VAD-37", nameEnglish: "Padra Town", nameVernacular: "પાદરા નગર", isUrban: false, lat: 22.2410, lng: 73.0850, geohash: "tej0", population: 41000, voterCount: 28000 },
      { wardId: "VIL-VAD-38", nameEnglish: "Karjan Town", nameVernacular: "કરજણ નગર", isUrban: false, lat: 22.0550, lng: 73.1250, geohash: "tehr", population: 38000, voterCount: 26000 },
      { wardId: "VIL-VAD-39", nameEnglish: "Dabhoi Town", nameVernacular: "ડભોઇ નગર", isUrban: false, lat: 22.1310, lng: 73.4190, geohash: "tej1", population: 45000, voterCount: 31000 },
      { wardId: "VIL-VAD-40", nameEnglish: "Savli Village", nameVernacular: "સાવલી ગામ", isUrban: false, lat: 22.5650, lng: 73.2250, geohash: "tej8", population: 22000, voterCount: 15000 }
    ]
  },
  {
    districtId: "DIS-GUJ-GAN-0001",
    nameEnglish: "Gandhinagar",
    nameVernacular: "ગાંધીનગર",
    pc: {
      pcId: "PC-GUJ-GAN-0001",
      nameEnglish: "Gandhinagar Parliamentary Constituency",
      nameVernacular: "ગાંધીનગર સંસદીય મતવિસ્તાર",
      mp: {
        userId: "USR-MP-GAN-001",
        name: "Hon. Amit Shah",
        party: "BJP",
        phone: "+919825010005",
        photoUrl: "https://jansetu.gov.in/assets/mps/amit_shah.jpg"
      }
    },
    wards: [
      { wardId: "WRD-GAN-41", nameEnglish: "Sector 15 Ward", nameVernacular: "સેક્ટર ૧૫ વૉર્ડ", isUrban: true, lat: 23.2320, lng: 72.6450, geohash: "ts5u", population: 32000, voterCount: 22000 },
      { wardId: "WRD-GAN-42", nameEnglish: "Sector 21 Ward", nameVernacular: "સેક્ટર ૨૧ વૉર્ડ", isUrban: true, lat: 23.2210, lng: 72.6580, geohash: "ts5u", population: 38000, voterCount: 26000 },
      { wardId: "WRD-GAN-43", nameEnglish: "Infocity Ward", nameVernacular: "ઇન્ફોસિટી વૉર્ડ", isUrban: true, lat: 23.1960, lng: 72.6310, geohash: "ts5u", population: 45000, voterCount: 31000 },
      { wardId: "WRD-GAN-44", nameEnglish: "Kudasan Ward", nameVernacular: "કુડાસણ વૉર્ડ", isUrban: true, lat: 23.1850, lng: 72.6280, geohash: "ts5u", population: 52000, voterCount: 36000 },
      { wardId: "WRD-GAN-45", nameEnglish: "Raysan Ward", nameVernacular: "રાયસણ વૉર્ડ", isUrban: true, lat: 23.1720, lng: 72.6410, geohash: "ts5u", population: 41000, voterCount: 28000 },
      { wardId: "WRD-GAN-46", nameEnglish: "Sargasan Ward", nameVernacular: "સરગાસણ વૉર્ડ", isUrban: true, lat: 23.1810, lng: 72.6050, geohash: "ts5u", population: 48000, voterCount: 33000 },
      { wardId: "VIL-GAN-47", nameEnglish: "Kalol Town", nameVernacular: "કલોલ નગર", isUrban: false, lat: 23.2450, lng: 72.4950, geohash: "ts5g", population: 75000, voterCount: 52000 },
      { wardId: "VIL-GAN-48", nameEnglish: "Dehgam Town", nameVernacular: "દહેગામ નગર", isUrban: false, lat: 23.1650, lng: 72.8080, geohash: "ts5v", population: 54000, voterCount: 37000 },
      { wardId: "VIL-GAN-49", nameEnglish: "Mansa Town", nameVernacular: "માણસા નગર", isUrban: false, lat: 23.4280, lng: 72.6580, geohash: "ts75", population: 48000, voterCount: 33000 },
      { wardId: "VIL-GAN-50", nameEnglish: "Adalaj Village", nameVernacular: "અડાલજ ગામ", isUrban: false, lat: 23.1610, lng: 72.5810, geohash: "ts5e", population: 24000, voterCount: 16000 }
    ]
  }
];

export const GUJARATI_SURNAMES = ["Patel", "Shah", "Desai", "Mehta", "Joshi", "Jadeja", "Solanki", "Chauhan", "Trivedi", "Parmar", "Panchal", "Bhatt", "Rathod", "Thakkar", "Vora"];
export const GUJARATI_MALE_FIRSTNAMES = ["Jignesh", "Manubhai", "Chirag", "Hardik", "Pratik", "Bhavesh", "Ketan", "Ramesh", "Suresh", "Dinesh", "Amit", "Rahul", "Mayank", "Nirav", "Kaushik"];
export const GUJARATI_FEMALE_FIRSTNAMES = ["Bhavna", "Kajal", "Hetal", "Sonal", "Pooja", "Kinjal", "Dhruvi", "Alpa", "Rekha", "Smruti", "Darshana", "Varsha", "Neha", "Mital", "Geeta"];

export interface DepartmentSpec {
  departmentId: string;
  nameEnglish: string;
  nameVernacular: string;
  categoryCode: string;
  defaultSlaDays: number;
  sampleTitles: Array<{ en: string; gu: string; costINR: number; priority: number }>;
}

export const GUJARAT_DEPARTMENTS: DepartmentSpec[] = [
  {
    departmentId: "DEPT_WATER_SUPPLY",
    nameEnglish: "Department of Water Supply & Hydraulics",
    nameVernacular: "પાણી પુરવઠા અને હાઇડ્રોલિક્સ વિભાગ",
    categoryCode: "WATER_AND_SANITATION",
    defaultSlaDays: 3,
    sampleTitles: [
      { en: "Ruptured 300mm Potable Water Main line near Residential Society", gu: "રહેણાંક સોસાયટી પાસે ૩૦૦ મીમીની પીવાના પાણીની મુખ્ય પાઈપલાઈન ફાટી ગઈ છે", costINR: 240000, priority: 94.5 },
      { en: "Severe contamination and sewage mixing in drinking water tap", gu: "પીવાના પાણીના નળમાં ગટરનું પાણી ભળી જવાથી ભારે પ્રદૂષણ", costINR: 180000, priority: 92.0 },
      { en: "Low water pressure and erratic municipal water supply timing", gu: "પાણીનું નીચું દબાણ અને મ્યુનિસિપલ પાણી પુરવઠાનો અનિયમિત સમય", costINR: 85000, priority: 72.0 }
    ]
  },
  {
    departmentId: "DEPT_ROADS_HIGHWAYS",
    nameEnglish: "Roads & Buildings Department (PWD)",
    nameVernacular: "માર્ગ અને મકાન વિભાગ (પીડબલ્યુડી)",
    categoryCode: "ROAD_INFRASTRUCTURE",
    defaultSlaDays: 7,
    sampleTitles: [
      { en: "Severe Pothole Formation and Asphalt Degeneration on Main Road", gu: "મુખ્ય માર્ગ પર મોટા ખાડા પડવા અને ડામર ઉખડી જવાની ગંભીર સમસ્યા", costINR: 1450000, priority: 91.0 },
      { en: "Caved-in asphalt road due to monsoon drainage erosion", gu: "ચોમાસાના પાણીના ધોવાણના કારણે ડામરનો રોડ બેસી ગયો છે", costINR: 850000, priority: 88.5 },
      { en: "Broken RCC divider causing traffic hazard and daily accidents", gu: "તૂટેલા આરસીસી ડિવાઈડરથી ટ્રાફિકનો ખતરો અને રોજિંદા અકસ્માતો", costINR: 320000, priority: 79.0 }
    ]
  },
  {
    departmentId: "DEPT_ELECTRICITY",
    nameEnglish: "State Electricity Distribution (PGVCL/DGVCL/UGVCL)",
    nameVernacular: "રાજ્ય વિદ્યુત વિતરણ નિગમ",
    categoryCode: "ELECTRICITY_AND_POWER",
    defaultSlaDays: 2,
    sampleTitles: [
      { en: "Spelling transformer sparking and burning cables on electric pole", gu: "ઇલેક્ટ્રિક થાંભલા પર ટ્રાન્સફોર્મરમાં તણખા અને કેબલ સળગવાની સમસ્યા", costINR: 420000, priority: 96.0 },
      { en: "Frequent voltage fluctuation damaging domestic appliances", gu: "વારંવાર વોલ્ટેજ વધઘટ થવાથી ઘરગથ્થુ ઉપકરણોને નુકસાન", costINR: 150000, priority: 81.0 },
      { en: "Leaning high-tension electricity pole threatening residential houses", gu: "રહેણાંક મકાનો પર નમી ગયેલો હાઈ-ટેન્શન વીજળીનો થાંભલો", costINR: 280000, priority: 93.5 }
    ]
  },
  {
    departmentId: "DEPT_SANITATION",
    nameEnglish: "Municipal Solid Waste & Sanitation Department",
    nameVernacular: "મ્યુનિસિપલ ઘન કચરો અને સ્વચ્છતા વિભાગ",
    categoryCode: "WASTE_MANAGEMENT",
    defaultSlaDays: 2,
    sampleTitles: [
      { en: "Overflowing municipal garbage dump emitting toxic odors", gu: "ઉભરાતી મ્યુનિસિપલ કચરાપેટીમાંથી આવતી ઝેરી દુર્ગંધ", costINR: 45000, priority: 85.0 },
      { en: "Choked storm water drain causing severe street sewage flooding", gu: "ચોક-અપ થયેલી ગટરના કારણે શેરીઓમાં ગટરનું પાણી ભરાવાની સમસ્યા", costINR: 120000, priority: 89.0 },
      { en: "Absence of daily door-to-door garbage collection vehicle for 5 days", gu: "૫ દિવસથી ડોર-ટુ-ડોર કચરો એકત્ર કરતી વાહનની ગેરહાજરી", costINR: 30000, priority: 74.0 }
    ]
  },
  {
    departmentId: "DEPT_PRIMARY_HEALTH",
    nameEnglish: "Department of Primary Health & Medical Services",
    nameVernacular: "પ્રાથમિક આરોગ્ય અને તબીબી સેવાઓ વિભાગ",
    categoryCode: "HEALTHCARE",
    defaultSlaDays: 5,
    sampleTitles: [
      { en: "Severe shortage of essential anti-venom and rabies vaccines in PHC", gu: "પીએચસીમાં એન્ટી-વેનોમ અને હડકવા વિરોધી રસીની ગંભીર અછત", costINR: 350000, priority: 95.0 },
      { en: "Dilapidated Primary Health Center building roof leaking during rains", gu: "વરસાદ દરમિયાન ટપકતી પ્રાથમિક આરોગ્ય કેન્દ્રની જર્જરિત છત", costINR: 650000, priority: 84.0 },
      { en: "Absence of duty doctor and nursing staff during emergency night hours", gu: "ઇમરજન્સી રાત્રિના સમયે ડૉક્ટર અને નર્સિંગ સ્ટાફની ગેરહાજરી", costINR: 50000, priority: 91.5 }
    ]
  },
  {
    departmentId: "DEPT_PRIMARY_EDUCATION",
    nameEnglish: "Samagra Shiksha & Primary Education Department",
    nameVernacular: "સમગ્ર શિક્ષા અને પ્રાથમિક શિક્ષણ વિભાગ",
    categoryCode: "EDUCATION",
    defaultSlaDays: 14,
    sampleTitles: [
      { en: "Collapsing classroom wall and damaged drinking water facility in school", gu: "શાળામાં પડુ પડુ થતી વર્ગખંડની દીવાલ અને પીવાના પાણીની ક્ષતિગ્રસ્ત સુવિધા", costINR: 850000, priority: 89.5 },
      { en: "Non-delivery of government mid-day meal grain ration for 3 weeks", gu: "૩ અઠવાડિયાથી સરકારી મધ્યાહ્ન ભોજન અનાજના રાશનનું વિતરણ ન થવું", costINR: 180000, priority: 92.5 },
      { en: "Lack of clean sanitation benches and functional toilets for girl students", gu: "વિદ્યાર્થિનીઓ માટે સ્વચ્છ શૌચાલય અને બેન્ચનો અભાવ", costINR: 340000, priority: 86.0 }
    ]
  },
  {
    departmentId: "DEPT_AGRICULTURE",
    nameEnglish: "Agriculture, Farmers Welfare & Co-operation Department",
    nameVernacular: "કૃષિ, ખેડૂત કલ્યાણ અને સહકાર વિભાગ",
    categoryCode: "AGRICULTURE",
    defaultSlaDays: 10,
    sampleTitles: [
      { en: "Desilting and Repair of Sub-Minor Farm Irrigation Canal", gu: "સબ-માઈનોર ખેતી સિંચાઈ કેનાલનું ડીસિલ્ટીંગ અને સમારકામ", costINR: 650000, priority: 88.0 },
      { en: "Severe crop damage due to unseasonal waterlogging without drainage", gu: "પાણી નિકાલના અભાવે કમોસમી પાણી ભરાવાથી પાકને ભારે નુકસાન", costINR: 450000, priority: 85.5 },
      { en: "Non-availability of subsidized urea fertilizer at village co-op society", gu: "ગામની સહકારી મંડળીમાં સબસીડીવાળા યુરિયા ખાતરની અછત", costINR: 220000, priority: 82.0 }
    ]
  }
];
