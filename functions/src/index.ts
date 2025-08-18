import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as cors from 'cors';
import * as express from 'express';

// Initialize Firebase Admin SDK
admin.initializeApp();

const app = express();
app.use(cors({ origin: true }));

// Import function modules
import { getESimPlans } from './esim/plans';
import { purchaseESimPlan } from './esim/purchase';
import { activateESim } from './esim/activation';
import { sendESimDetails } from './esim/delivery';
import { processPayment } from './payments/stripe';
import { sendEmail } from './notifications/email';
import { sendWhatsApp } from './notifications/whatsapp';

// Export eSIM functions
export const getESimPlans = functions.https.onCall(getESimPlans);
export const purchaseESimPlan = functions.https.onCall(purchaseESimPlan);
export const activateESim = functions.https.onCall(activateESim);
export const sendESimDetails = functions.https.onCall(sendESimDetails);

// Export payment functions
export const processPayment = functions.https.onCall(processPayment);

// Export notification functions
export const sendEmail = functions.https.onCall(sendEmail);
export const sendWhatsApp = functions.https.onCall(sendWhatsApp);

// Initialize countries data on first deploy
export const initializeData = functions.https.onRequest(async (req, res) => {
  try {
    const db = admin.firestore();
    
    // Sample countries data
    const countries = [
      {
        code: 'AF',
        name: 'Afghanistan',
        flagUrl: 'https://flagcdn.com/af.svg',
        currency: 'USD',
        supportedNetworks: ['AWCC', 'Roshan', 'Etisalat'],
        isActive: true
      },
      {
        code: 'US',
        name: 'United States',
        flagUrl: 'https://flagcdn.com/us.svg',
        currency: 'USD',
        supportedNetworks: ['AT&T', 'Verizon', 'T-Mobile'],
        isActive: true
      },
      {
        code: 'UK',
        name: 'United Kingdom',
        flagUrl: 'https://flagcdn.com/gb.svg',
        currency: 'GBP',
        supportedNetworks: ['EE', 'O2', 'Vodafone', 'Three'],
        isActive: true
      },
      {
        code: 'DE',
        name: 'Germany',
        flagUrl: 'https://flagcdn.com/de.svg',
        currency: 'EUR',
        supportedNetworks: ['Deutsche Telekom', 'Vodafone', 'O2'],
        isActive: true
      },
      {
        code: 'TR',
        name: 'Turkey',
        flagUrl: 'https://flagcdn.com/tr.svg',
        currency: 'USD',
        supportedNetworks: ['Turkcell', 'Vodafone', 'Türk Telekom'],
        isActive: true
      }
    ];
    
    // Add countries to Firestore
    const batch = db.batch();
    countries.forEach(country => {
      const docRef = db.collection('countries').doc(country.code);
      batch.set(docRef, country);
    });
    
    await batch.commit();
    
    res.json({ success: true, message: 'Countries data initialized successfully' });
  } catch (error) {
    console.error('Error initializing data:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Health check endpoint
export const healthCheck = functions.https.onRequest((req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});
