import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: CustomAppBar(title: 'Expense Tracker'),
      body: Center(
        child: Text('Expense Tracker'),
      )
    );
  }
}