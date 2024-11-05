import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id; // Firestore document ID
  String title;
  Color boxColor;
  String label;
  String? thingsToBring; 
  String? date;
  String? location;
  String creatorId;
  List<String> memberIds; 

  GroupModel({
    required this.id,
    required this.title,
    required this.boxColor,
    required this.label,
    this.location,
    this.thingsToBring,
    this.date,
    required this.creatorId,
    this.memberIds = const [],
  });

  void updateDetails(String newLocation, String newThingsToBring, String newDate) {
    location = newLocation;
    thingsToBring = newThingsToBring;
    date = newDate;
  }

  static GroupModel fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      title: map['title'],
      boxColor: Color(map['boxColor']),
      label: map['label'],
      thingsToBring: map['thingsToBring'],
      date: map['date'],
      location: map['location'],
      creatorId: map['creatorId'],
      memberIds: List<String>.from(map['memberIds'] ?? []),
    );
  }

  static Future<List<GroupModel>> getGroups(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('memberIds', arrayContains: userId)
        .get();

    return snapshot.docs.map((doc) => fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  // Optionally, if you need to convert the model back to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'boxColor': boxColor.value, // Convert Color to int
      'label': label,
      'thingsToBring': thingsToBring,
      'date': date,
      'location': location,
      'creatorId': creatorId,
      'memberIds': memberIds,
    };
  }
}