import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/esim_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/esim_plan.dart';
import '../../../core/services/order_service.dart';
import '../../../core/services/payment_service.dart';
import '../../orders/screens/order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String planId;
  
  const CheckoutScreen({super.key, required this.planId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  
  String _selectedPaymentMethod = 'card';
  bool _isProcessing = false;
  bool _savePaymentMethod = false;
  bool _sendToEmail = true;
  bool _sendToWhatsApp = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.userModel != null) {
      _emailController.text = authProvider.userModel!.email;
      _nameController.text = '${authProvider.userModel!.firstName} ${authProvider.userModel!.lastName}';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final esimProvider = Provider.of<ESimProvider>(context);
    final plan = esimProvider.plans.firstWhere(
      (p) => p.id == widget.planId,
      orElse: () => esimProvider.plans.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(plan, l10n),
                    const SizedBox(height: 24),
                    _buildDeliveryOptions(l10n),
                    const SizedBox(height: 24),
                    _buildPaymentMethods(l10n),
                    const SizedBox(height: 24),
                    if (_selectedPaymentMethod == 'card')
                      _buildCardPaymentForm(l10n),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomBar(plan, l10n),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(ESimPlan plan, AppLocalizations l10n) {
    final taxAmount = plan.price * 0.1; // 10% tax
    final totalAmount = plan.price + taxAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.orderSummary,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.green.shade100,
                    child: const Icon(
                      Icons.sim_card,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.dataAmountGB}GB • ${plan.durationDays} days',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        plan.countryCode,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${plan.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.subtotal),
                Text('\$${plan.price.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.tax),
                Text('\$${taxAmount.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.total,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOptions(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.deliveryOptions,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _sendToEmail,
              onChanged: (value) {
                setState(() {
                  _sendToEmail = value ?? false;
                });
              },
              title: Text(l10n.sendViaEmail),
              subtitle: Text(l10n.esimQrCodeWillBeSent),
              secondary: const Icon(Icons.email),
            ),
            if (_sendToEmail) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.emailAddress,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (_sendToEmail && (value == null || value.isEmpty)) {
                    return l10n.pleaseEnterEmail;
                  }
                  if (_sendToEmail && !value!.contains('@')) {
                    return l10n.pleaseEnterValidEmail;
                  }
                  return null;
                },
              ),
            ],
            CheckboxListTile(
              value: _sendToWhatsApp,
              onChanged: (value) {
                setState(() {
                  _sendToWhatsApp = value ?? false;
                });
              },
              title: Text(l10n.sendViaWhatsApp),
              subtitle: Text(l10n.esimQrCodeWillBeSentWhatsApp),
              secondary: const Icon(Icons.message),
            ),
            if (_sendToWhatsApp) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '+1234567890',
                ),
                validator: (value) {
                  if (_sendToWhatsApp && (value == null || value.isEmpty)) {
                    return l10n.pleaseEnterPhoneNumber;
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.paymentMethod,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              value: 'card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              title: Text(l10n.creditDebitCard),
              secondary: const Icon(Icons.credit_card),
            ),
            RadioListTile<String>(
              value: 'apple_pay',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              title: Text(l10n.applePay),
              secondary: const Icon(Icons.apple),
            ),
            RadioListTile<String>(
              value: 'google_pay',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              title: Text(l10n.googlePay),
              secondary: const Icon(Icons.payment),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cardDetails,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.cardholderName,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterCardholderName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: l10n.cardNumber,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.credit_card),
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterCardNumber;
                }
                if (value.replaceAll(' ', '').length < 16) {
                  return l10n.pleaseEnterValidCardNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: l10n.expiryDate,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                      hintText: 'MM/YY',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryDateFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterExpiryDate;
                      }
                      if (value.length < 5) {
                        return l10n.pleaseEnterValidExpiryDate;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: l10n.cvv,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.security),
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterCvv;
                      }
                      if (value.length < 3) {
                        return l10n.pleaseEnterValidCvv;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _savePaymentMethod,
              onChanged: (value) {
                setState(() {
                  _savePaymentMethod = value ?? false;
                });
              },
              title: Text(l10n.savePaymentMethod),
              subtitle: Text(l10n.securelyStoreForFuturePurchases),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ESimPlan plan, AppLocalizations l10n) {
    final taxAmount = plan.price * 0.1;
    final totalAmount = plan.price + taxAmount;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.total,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _processPayment(plan),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.completePurchase,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(ESimPlan plan) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_sendToEmail && !_sendToWhatsApp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).pleaseSelectDeliveryMethod),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.userModel == null) {
        throw Exception('User not authenticated');
      }

      // Prepare payment details
      final paymentDetails = <String, dynamic>{};
      PaymentMethod paymentMethod = PaymentMethod.card;

      switch (_selectedPaymentMethod) {
        case 'card':
          paymentMethod = PaymentMethod.card;
          paymentDetails.addAll({
            'cardNumber': _cardNumberController.text,
            'expiryDate': _expiryController.text,
            'cvv': _cvvController.text,
            'cardholderName': _nameController.text,
          });
          break;
        case 'apple_pay':
          paymentMethod = PaymentMethod.applePay;
          break;
        case 'google_pay':
          paymentMethod = PaymentMethod.googlePay;
          break;
      }

      // Create order using OrderService
      final orderService = OrderService();
      final order = await orderService.createOrder(
        user: authProvider.userModel!,
        plan: plan,
        paymentMethod: paymentMethod,
        paymentDetails: paymentDetails,
        email: _sendToEmail ? _emailController.text : null,
        phoneNumber: _sendToWhatsApp ? _phoneController.text : null,
      );

      // Navigate to confirmation screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
              orderId: order.id,
              plan: plan,
              email: _sendToEmail ? _emailController.text : null,
              phone: _sendToWhatsApp ? _phoneController.text : null,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
