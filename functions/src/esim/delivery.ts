import * as functions from 'firebase-functions';

interface DeliveryRequest {
  orderId: string;
  email?: string;
  whatsappNumber?: string;
}

export const sendESimDetails = async (data: DeliveryRequest, context: functions.https.CallableContext) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { orderId, email, whatsappNumber } = data;

    // Mock delivery - Replace with actual email/WhatsApp sending
    console.log(`Sending eSIM details for order ${orderId}`);
    if (email) {
      console.log(`Email sent to: ${email}`);
    }
    if (whatsappNumber) {
      console.log(`WhatsApp sent to: ${whatsappNumber}`);
    }

    return {
      success: true,
      message: 'eSIM details sent successfully'
    };

  } catch (error) {
    console.error('Error sending eSIM details:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send eSIM details');
  }
};
