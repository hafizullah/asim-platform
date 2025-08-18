import * as functions from 'firebase-functions';

interface EmailRequest {
  to: string;
  subject: string;
  body: string;
}

export const sendEmail = async (data: EmailRequest, context: functions.https.CallableContext) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { to, subject, body } = data;
    
    // Mock email sending - Replace with actual email service
    console.log(`Sending email to: ${to}`);
    console.log(`Subject: ${subject}`);
    console.log(`Body: ${body}`);

    return {
      success: true,
      message: 'Email sent successfully'
    };

  } catch (error) {
    console.error('Error sending email:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send email');
  }
};
