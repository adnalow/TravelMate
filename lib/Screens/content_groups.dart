import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/Widgets/custom_Container.dart';
import 'package:travel_mate/Widgets/customTextField.dart';
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
    return PopScope(
      canPop: true,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 50,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    iconSize: 24,
                    padding: EdgeInsets.zero, // Removes default padding
                    constraints: const BoxConstraints(
                      minWidth: 24, // Adjust these values as needed
                      minHeight: 24,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    }, 
                    icon: SvgPicture.asset(
                      'assets/icons/menu.svg'),
                  );
                }
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              // Members List Section
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Section Header
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                      child: Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                    Divider(),
                    // Dynamic List of Members
                    ...memberEmails.map((email) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getAvatarColor(email),
                          child: Text(
                            _getInitial(email),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          email ?? 'Unknown Member',
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          // Optional tap action
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              // Leave Group Button
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFF808080)),
                title: const Text(
                  'Leave Group',
                  style: TextStyle(
                    color: Color(0xFF808080),
                  ),
                ),
                onTap: () {
                  _leaveGroup();
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Outing Header
              Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: widget.group.boxColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.group.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      widget.group.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
      
              // Location Field
              CustomContainer(
                child: CustomTextField(
                  width: double.infinity,
                  controller: _locationController, 
                  hintText: 'Location',
                ),
              ),
              const SizedBox(height: 10),
      
              // Things to Bring Field
              CustomContainer(
                child: TextField(
                  controller: _thingsToBringController, 
                  // expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Things to bring...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF57CC99)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), 
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
      
              // Date Picker
              CustomContainer(
                child: TextField(
                  controller: _dateController, 
                  decoration: const InputDecoration(
                    hintText: 'Date',
                    prefixIcon: Icon(Iconsax.calendar),
                    hintStyle: TextStyle(color: Colors.grey), 
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF57CC99)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), 
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                ),
              ),
      
              const SizedBox(height: 10),
      
              // Back and Save Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
      
                  reusableElevatedButton(
                    text: 'Update', 
                    onPressed: () {
                      String location = _locationController.text;
                      String thingsToBring = _thingsToBringController.text;
                      String date = _dateController.text;
      
                      widget.group.updateDetails(location, thingsToBring, date);
                      _updateGroupInFirestore(widget.group);
      
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF57CC99), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF57CC99), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
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

// Returns the first letter of the email or a default value
String _getInitial(String? email) {
  if (email != null && email.isNotEmpty) {
    return email[0].toUpperCase();
  }
  return 'M'; // Default initial
}

// Returns a color based on the first letter of the email
Color _getAvatarColor(String? email) {
  if (email == null || email.isEmpty) return Colors.grey;
  switch (email[0].toUpperCase()) {
    case 'A':
    case 'B':
      return const Color(0xFF90C0E0);
    case 'C':
    case 'D':
      return const Color(0xFFF65A5A);
    case 'E':
    case 'F':
      return const Color(0xFFF8961E);
    case 'G':
    case 'H':
      return const Color(0xFF57CC99);
    case 'I':
    case 'J':
      return const Color(0xFFA5330A);
    case 'K':
    case 'L':
      return const Color(0xFFEF476F);
    default:
      return Colors.teal.shade200; // Default color
  }
}
