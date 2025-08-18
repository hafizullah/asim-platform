import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

interface ActivationRequest {
  orderId: string;
}

export const activateESim = async (data: ActivationRequest, context: functions.https.CallableContext) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { orderId } = data;
    const db = admin.firestore();
    const orderRef = db.collection('orders').doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Order not found');
    }

    const orderData = orderDoc.data();
    if (orderData?.userId !== context.auth.uid) {
      throw new functions.https.HttpsError('permission-denied', 'Not authorized');
    }

    // Mock activation - Replace with actual eSIM provider API
    await orderRef.update({
      status: 'activated',
      activatedAt: new Date(),
      updatedAt: new Date()
    });

    return {
      success: true,
      message: 'eSIM activated successfully'
    };

  } catch (error) {
    console.error('Error activating eSIM:', error);
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    throw new functions.https.HttpsError('internal', 'Failed to activate eSIM');
  }
};
