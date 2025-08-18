import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final String planId;
  
  const CheckoutScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: Text('Checkout for plan: $planId'),
      ),
    );
  }
}
