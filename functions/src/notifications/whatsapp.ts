import * as functions from 'firebase-functions';

interface WhatsAppRequest {
  to: string;
  message: string;
}

export const sendWhatsApp = async (data: WhatsAppRequest, context: functions.https.CallableContext) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { to, message } = data;
    
    // Mock WhatsApp sending - Replace with actual WhatsApp Business API
    console.log(`Sending WhatsApp to: ${to}`);
    console.log(`Message: ${message}`);

    return {
      success: true,
      message: 'WhatsApp sent successfully'
    };

  } catch (error) {
    console.error('Error sending WhatsApp:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send WhatsApp');
  }
};
