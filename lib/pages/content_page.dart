import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/models/groups_model.dart';

class ContentPage extends StatefulWidget {
  final GroupModel group;
  final VoidCallback onLeaveGroup; // Callback for when the user leaves the group

  const ContentPage({super.key, required this.group, required this.onLeaveGroup});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _thingsToBringController =
      TextEditingController();
  List<String?> memberEmails = []; // List to store member emails

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.group.date ?? '';
    _locationController.text = widget.group.location ?? '';
    _thingsToBringController.text = widget.group.thingsToBring ?? '';
    _fetchMemberEmails(); // Fetch member emails on initialization
  }

  Future<void> _fetchMemberEmails() async {
    memberEmails =
        await Future.wait(widget.group.memberIds.map(getUserEmailById));
    setState(() {}); // Refresh the UI
  }

  Future<String?> getUserEmailById(String userId) async {
    // Fetch the user document by userId
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data()?['email']
          as String?; 
    } else {
      return null; 
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: appBar(),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Group Members'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ...memberEmails.map((email) {
            return ListTile(
              title: Text(email ?? 'Unknown Member'), // Handle null case
              onTap: () {
                // Handle item tap (optional)
              },
            );
          }).toList(),
          ListTile(
            title: const Text('Leave Group'), // Leave Group button
            onTap: () {
              _leaveGroup();
            },
          ),
        ],
      ),
    ),
    body: Column(
      children: [
        outingHeader(),
        locationField(),
        thingsToBringField(),
        datePicker(),
        saveButton(),
      ],
    ),
  );
}

Future<void> _leaveGroup() async {
  User? user = FirebaseAuth.instance.currentUser;
  String userId = user!.uid; // Replace this with the actual current user ID
  String groupId = widget.group.id;

  // Remove the user from the group's member IDs
  await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
    'memberIds': FieldValue.arrayRemove([userId]),
  });

  // Call the callback to inform the parent to refresh its state
  widget.onLeaveGroup();

  // Optionally, navigate back after leaving the group
  Navigator.of(context).pop(); // Close the drawer
  Navigator.of(context).pop(); // Go back to the previous screen
}



  Padding datePicker() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: 'Date',
          filled: true,
          prefixIcon: Icon(Icons.calendar_today),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        readOnly: true,
        onTap: _selectDate,
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Container thingsToBringField() {
    return Container(
      margin: const EdgeInsets.only(top: 15, right: 20, left: 20),
      height: 170,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: SizedBox(
        height: 170,
        child: TextField(
          controller: _thingsToBringController,
          expands: true,
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Things to bring...',
            hintStyle: const TextStyle(
              color: Color(0xffDDDADA),
              fontSize: 16,
            ),
            contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Container locationField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        controller: _locationController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Location',
          hintStyle: const TextStyle(
            color: Color(0xffDDDADA),
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Container outingHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
      height: 100,
      width: 360,
      decoration: BoxDecoration(
        color: widget.group.boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding:
            const EdgeInsets.only(top: 45, bottom: 15, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              widget.group.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

 AppBar appBar() {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back), 
      onPressed: () {
        Navigator.of(context).pop(); 
      },
    ),
    actions: [
      Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: SvgPicture.asset('assets/icons/menu.svg'),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    ],
  );
}



  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF57CC99),
        ),
        onPressed: () {
          String location = _locationController.text;
          String thingsToBring = _thingsToBringController.text;
          String date = _dateController.text;

          widget.group.updateDetails(location, thingsToBring, date);
          _updateGroupInFirestore(widget.group);

          Navigator.of(context).pop();
        },
        child: const Text(
          'Update',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _updateGroupInFirestore(GroupModel group) async {
    String groupId = group.id;

    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'location': group.location,
      'thingsToBring': group.thingsToBring,
      'date': group.date,
    });
  }
}
