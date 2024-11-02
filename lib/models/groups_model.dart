import 'package:flutter/material.dart';

class GroupModel{
  String title;
  Color boxColor;
  String label;
  String thingsToBring;
  String date;
  String location;

  
  GroupModel({
    required this.title,
    required this.boxColor,
    required this.label,
    this.location = '',
    this.thingsToBring = '',
    this.date = ''
  });

  void updateDetails(String newLocation, String newThingsToBring, String newDate) {
    location = newLocation;
    thingsToBring = newThingsToBring;
    date = newDate;
  }

  static List<GroupModel> getGroups(){
    List<GroupModel> groups = [];


    return groups;
  }
} 