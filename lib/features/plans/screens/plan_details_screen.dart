import 'package:flutter/material.dart';

class PlanDetailsScreen extends StatelessWidget {
  final String planId;
  
  const PlanDetailsScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Details'),
      ),
      body: Center(
        child: Text('Plan Details for: $planId'),
      ),
    );
  }
}
