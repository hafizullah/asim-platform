import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

interface PurchaseRequest {
  orderId: string;
  planId: string;
  paymentMethodId: string;
  recipientEmail?: string;
  recipientWhatsApp?: string;
}

export const purchaseESimPlan = async (data: PurchaseRequest, context: functions.https.CallableContext) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { orderId, planId, paymentMethodId } = data;

    // Get order and plan details
    const db = admin.firestore();
    const orderRef = db.collection('orders').doc(orderId);
    const planRef = db.collection('plans').doc(planId);
    
    const [orderDoc, planDoc] = await Promise.all([
      orderRef.get(),
      planRef.get()
    ]);

    if (!orderDoc.exists || !planDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Order or plan not found');
    }

    // Mock eSIM purchase - Replace with actual eSIM provider API
    const mockESimData = {
      iccid: `89860000000${Date.now()}`,
      activationCode: `SM-DP+ ${generateActivationCode()}`,
      qrCode: generateQRCode(),
      profileUrl: `https://esim-provider.com/download/${orderId}`
    };

    // Update order with eSIM data
    await orderRef.update({
      status: 'completed',
      eSimIccid: mockESimData.iccid,
      activationCode: mockESimData.activationCode,
      qrCodeUrl: mockESimData.qrCode,
      eSimProfileUrl: mockESimData.profileUrl,
      transactionId: `txn_${Date.now()}`,
      updatedAt: new Date()
    });

    return {
      success: true,
      eSimData: mockESimData
    };

  } catch (error) {
    console.error('Error purchasing eSIM plan:', error);
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    throw new functions.https.HttpsError('internal', 'Failed to purchase eSIM plan');
  }
};

function generateActivationCode(): string {
  return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}

function generateQRCode(): string {
  // Mock QR code URL - In production, generate actual QR code
  return `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=LPA:1$esim-provider.com$${generateActivationCode()}`;
}
