import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.termsAndConditionsTitle),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.termsAndConditionsTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Effective Date: August 27, 2025',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              '1. Service Provider',
              'ASIM ("we," "our," or "us") provides eSIM connectivity services through our platform. We act as an intermediary connecting customers to third-party eSIM providers and payment processors.',
            ),
            
            _buildSection(
              context,
              '2. Third-Party Payment Processing',
              'All payment transactions are processed by ESIMAccess, a third-party payment processor. ASIM does not process, store, or have access to any personal payment details, credit card information, or other sensitive financial data. All payment-related queries should be directed to ESIMAccess.',
            ),
            
            _buildSection(
              context,
              '3. Personal Data Protection',
              'ASIM does not collect, process, or store personal details beyond what is necessary for service delivery. Your payment information, personal details, and financial data are handled exclusively by our third-party partners (ESIMAccess). We recommend reviewing their privacy policies for detailed information about data handling.',
            ),
            
            _buildSection(
              context,
              '4. Refund Policy',
              'Refunds are generally not provided for eSIM purchases due to the digital nature of the service and immediate delivery upon purchase. Any refund requests will be considered strictly at our discretion and may be subject to the policies of our third-party providers. Refunds, if approved, will be processed through the original payment method via ESIMAccess.',
            ),
            
            _buildSection(
              context,
              '5. Service Availability and Performance',
              'eSIM services are provided through third-party network operators. ASIM cannot guarantee uninterrupted service, specific data speeds, or coverage in all areas. Service performance depends on local network conditions and third-party infrastructure beyond our control.',
            ),
            
            _buildSection(
              context,
              '6. Limitation of Liability',
              'ASIM\'s liability is limited to the maximum extent permitted by law. We are not liable for:\n• Service interruptions or network outages\n• Data loss or corruption\n• Indirect, incidental, or consequential damages\n• Issues arising from third-party services\n• Compatibility issues with devices\n• Force majeure events',
            ),
            
            _buildSection(
              context,
              '7. Customer Responsibilities',
              'Customers are responsible for:\n• Ensuring device compatibility before purchase\n• Following activation instructions correctly\n• Understanding local laws and regulations\n• Reporting issues within a reasonable timeframe\n• Providing accurate information during purchase',
            ),
            
            _buildSection(
              context,
              '8. Intellectual Property',
              'All trademarks, logos, and intellectual property displayed on our platform belong to their respective owners. The ASIM brand and platform are protected by applicable intellectual property laws.',
            ),
            
            _buildSection(
              context,
              '9. Dispute Resolution',
              'Any disputes arising from the use of our services will be resolved through:\n• First, direct communication with our customer support\n• If unresolved, binding arbitration under the laws of the jurisdiction where ASIM is registered\n• Customers waive the right to class action lawsuits',
            ),
            
            _buildSection(
              context,
              '10. Modifications to Terms',
              'ASIM reserves the right to modify these terms at any time. Changes will be effective immediately upon posting on our platform. Continued use of our services constitutes acceptance of modified terms.',
            ),
            
            _buildSection(
              context,
              '11. Age Restrictions',
              'Our services are intended for users 18 years of age or older. Users under 18 must have parental consent and supervision.',
            ),
            
            _buildSection(
              context,
              '12. Governing Law',
              'These terms are governed by the laws of the jurisdiction where ASIM is registered, without regard to conflict of law principles.',
            ),
            
            _buildSection(
              context,
              '13. Severability',
              'If any provision of these terms is found to be unenforceable, the remaining provisions will continue in full force and effect.',
            ),
            
            _buildSection(
              context,
              '14. Contact Information',
              'For questions about these terms or our services, please contact us through the contact information provided on our platform.',
            ),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Important Notice',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By using ASIM services, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. You also acknowledge that ASIM acts as an intermediary and that payment processing is handled by third-party providers.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
