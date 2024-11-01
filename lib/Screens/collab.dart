import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';

class CollaborativeScreen extends StatefulWidget {
  const CollaborativeScreen({super.key});

  @override
  State<CollaborativeScreen> createState() => _CollaborativeScreenState();
}

class _CollaborativeScreenState extends State<CollaborativeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: CustomAppBar(title: 'Collaborative Planning'),
      body: Center(
        child: Text('Collaborative Planning'),
      )
    );
  }
}