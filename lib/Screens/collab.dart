import 'package:flutter/material.dart';

class CollaborativeScreen extends StatefulWidget {
  const CollaborativeScreen({super.key});

  @override
  State<CollaborativeScreen> createState() => _CollaborativeScreenState();
}

class _CollaborativeScreenState extends State<CollaborativeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Collaborative Planning'),
      )
    );
  }
}