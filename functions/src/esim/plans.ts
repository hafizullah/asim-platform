import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import axios from 'axios';

interface GetPlansRequest {
  countryCode: string;
}

export const getESimPlans = async (data: GetPlansRequest, context: functions.https.CallableContext) => {
  try {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { countryCode } = data;

    if (!countryCode) {
      throw new functions.https.HttpsError('invalid-argument', 'Country code is required');
    }

    // Mock eSIM API call - Replace with actual eSIM provider API
    const mockPlans = [
      {
        id: `plan_${countryCode}_1`,
        name: `${countryCode} Tourist Plan`,
        description: 'Perfect for short trips',
        countryCode,
        countryName: getCountryName(countryCode),
        price: 15.99,
        currency: 'USD',
        dataAmountGB: 5,
        durationDays: 7,
        supportedNetworks: ['Network1', 'Network2'],
        isUnlimited: false,
        hasVoice: false,
        hasSms: false,
        isPopular: true,
        isActive: true,
        provider: 'GlobaleSIM',
        coverage: 'Nationwide',
        activationPolicy: 'Instant',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id: `plan_${countryCode}_2`,
        name: `${countryCode} Business Plan`,
        description: 'For extended stays',
        countryCode,
        countryName: getCountryName(countryCode),
        price: 39.99,
        currency: 'USD',
        dataAmountGB: 20,
        durationDays: 30,
        supportedNetworks: ['Network1', 'Network2', 'Network3'],
        isUnlimited: false,
        hasVoice: true,
        hasSms: true,
        isPopular: false,
        isActive: true,
        provider: 'GlobaleSIM',
        coverage: 'Nationwide',
        activationPolicy: 'Instant',
        createdAt: new Date(),
        updatedAt: new Date(),
      }
    ];

    // Store plans in Firestore cache
    const db = admin.firestore();
    const batch = db.batch();
    
    mockPlans.forEach(plan => {
      const planRef = db.collection('plans').doc(plan.id);
      batch.set(planRef, plan);
    });
    
    await batch.commit();

    return {
      success: true,
      plans: mockPlans
    };

  } catch (error) {
    console.error('Error fetching eSIM plans:', error);
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    throw new functions.https.HttpsError('internal', 'Failed to fetch eSIM plans');
  }
};

function getCountryName(countryCode: string): string {
  const countryNames: { [key: string]: string } = {
    'AF': 'Afghanistan',
    'US': 'United States',
    'UK': 'United Kingdom',
    'DE': 'Germany',
    'TR': 'Turkey',
    'AE': 'United Arab Emirates',
    'SA': 'Saudi Arabia',
    'PK': 'Pakistan',
    'IN': 'India'
  };
  
  return countryNames[countryCode] || countryCode;
}
