import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(_emailController.text.trim());

    if (success) {
      setState(() {
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resetPassword),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (_emailSent) {
                return _buildSuccessView(l10n);
              }
              
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.lock_reset,
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.resetPassword,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Enter your email address and we\'ll send you a link to reset your password.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        if (!value.contains('@')) {
                          return l10n.invalidEmail;
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Reset button
                    ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.resetPassword),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Error message
                    if (authProvider.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          authProvider.errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Back to login
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text('Back to ${l10n.login}'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 100,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          'Email Sent!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            context.go('/login');
          },
          child: Text('Back to ${l10n.login}'),
        ),
      ],
    );
  }
}
