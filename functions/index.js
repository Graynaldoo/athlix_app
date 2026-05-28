/**
 * ATHLIX AI COACH - Cloud Functions
 * PRD Requirement: Claude API key must NEVER be exposed in the client.
 * Calls to AI must go through Cloud Functions.
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Anthropic } = require("@anthropic-ai/sdk");

admin.initializeApp();
const db = admin.firestore();

// Initialize Anthropic SDK using Firebase config/secrets
// Setting in Firebase: firebase functions:secrets:set CLAUDE_API_KEY
const anthropic = new Anthropic({
  apiKey: process.env.CLAUDE_API_KEY || "YOUR_API_KEY", 
});

/**
 * 1. analyzeInjuryPattern
 * Triggered via callable function from the Flutter app.
 */
exports.analyzeInjuryPattern = functions.region("asia-southeast2").https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be logged in.");
  }

  const { complaints, sport } = data;
  
  if (!complaints) {
    return { suggestion: "Tidak ada keluhan signifikan." };
  }

  try {
    const prompt = `Sebagai AI Coach olahraga untuk ${sport}, berikan saran pencegahan cedera singkat (maks 2 paragraf) berdasarkan keluhan: "${complaints}". Akhiri dengan: "DISCLAIMER: Ini bukan saran medis profesional. Konsultasikan dengan dokter jika diperlukan."`;

    const response = await anthropic.messages.create({
      model: "claude-3-haiku-20240307",
      max_tokens: 300,
      messages: [{ role: "user", content: prompt }]
    });

    return { suggestion: response.content[0].text };
  } catch (error) {
    console.error("AI Error:", error);
    throw new functions.https.HttpsError("internal", "Gagal memproses data AI.");
  }
});

/**
 * 2. generateWeeklyReview
 * Scheduled function running every Sunday at 20:00 to generate AI reviews for active users.
 */
exports.generateWeeklyReview = functions.region("asia-southeast2").pubsub.schedule("0 20 * * 0").timeZone("Asia/Jakarta").onRun(async (context) => {
  const usersSnapshot = await db.collection("users").get();
  
  for (const doc of usersSnapshot.docs) {
    const uid = doc.id;
    // In production, fetch training sessions for the week here.
    
    const prompt = `Berikan ringkasan motivasi singkat untuk atlet yang telah berlatih keras minggu ini.`;
    
    try {
      const response = await anthropic.messages.create({
        model: "claude-3-haiku-20240307",
        max_tokens: 200,
        messages: [{ role: "user", content: prompt }]
      });

      await db.collection("aiRecommendations").doc(uid).collection("reviews").add({
        text: response.content[0].text,
        date: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      console.error(`Error generating review for ${uid}:`, e);
    }
  }
  return null;
});

/**
 * 3. suggestPartners
 * Callable function to find matching open match partners based on skill level and location.
 */
exports.suggestPartners = functions.region("asia-southeast2").https.onCall(async (data, context) => {
  if (!context.auth) return [];

  const { skillLevel, sportType } = data;

  try {
    const matches = await db.collection("openMatches")
      .where("sportType", "==", sportType)
      .where("skillLevel", "==", skillLevel)
      .where("status", "==", "open")
      .limit(3)
      .get();

    const results = [];
    matches.forEach(doc => {
      results.push({ id: doc.id, ...doc.data() });
    });
    
    return results;
  } catch (e) {
    throw new functions.https.HttpsError("internal", "Gagal mencari partner.");
  }
});
