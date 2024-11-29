import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';
import 'package:travel_mate/Widgets/customTextField.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/models/groups_model.dart';
import 'content_groups.dart';

class CollaborativeScreen extends StatefulWidget {
  const CollaborativeScreen({super.key});

  @override
  State<CollaborativeScreen> createState() => _CollaborativeScreenState();
}

class _CollaborativeScreenState extends State<CollaborativeScreen> {
  List<GroupModel> groups = [];
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getGroups();
  }

  void _removeGroup(String groupId) {
    setState(() {
      groups.removeWhere((group) => group.id == groupId);
    });
  }

  Future<void> _getGroups() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      List<GroupModel> fetchedGroups =
          await GroupModel.getGroups(user.uid); // Pass user ID
      if (mounted) {
        setState(() {
          groups = fetchedGroups;
        });
      }
    }
  }

  Future<void> _showColorPickerDialog(GroupModel group) async {
    // List of predefined colors for the picker
    List<Color> colorOptions = [
      const Color(0xFF00A5E0),
      const Color(0xFF38A3A5),
      const Color(0xFFff70a6),
      const Color(0xFFef8275),
      const Color(0xFF5c3d99),
      const Color(0xFF779be7),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () async {
                    // Update the group color locally
                    group.boxColor = color;

                    // Update the color in Firestore
                    await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(group.id)
                        .update({'boxColor': color.value});

                    // Refresh the state to reflect the change
                    setState(() {});

                    // Close the dialog after selecting the color
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 30,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(title: 'Collaborative Planner'),
      body: Stack(
        children: [
          displayGroups(),
          planAdder(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Ensure that the groups list is cleared when the screen is disposed
    groups.clear(); // Clear groups when leaving this screen
    super.dispose();
  }

  Positioned planAdder() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Add Travel Plan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: openTravelPlanDialog,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              elevation: 3,
              backgroundColor: const Color(0xFF57CC99),
              child: SvgPicture.asset('assets/icons/plus.svg'),
            ),
          ),
        ],
      ),
    );
  }

  Container displayGroups() {
    return Container(
      height: 620,
      child: groups.isEmpty
          ? Center(
              child: Text(
                'No groups available. Add a travel plan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10), 
              itemCount: groups.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentPage(
                          onLeaveGroup: () {
                            _removeGroup(groups[index].id);
                          },
                          group: groups[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: groups[index].boxColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                groups[index].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showColorPickerDialog(groups[
                                    index]), // Add the function to change colors here
                                child: SvgPicture.asset(
                                  'assets/icons/three-dots.svg',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            groups[index].label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> openTravelPlanDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
        contentPadding: const EdgeInsets.all(15),
        actionsPadding: const EdgeInsets.only(right: 15, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Create Travel Plan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close_sharp),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: groupNameController,
              hintText: 'Enter group name',
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: labelController,
              hintText: 'Label',
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: peopleController,
              hintText: 'Add People (comma-separated emails)',
              width: double.infinity,
            ),
          ],
        ),
        actions: [
          reusableElevatedButton(
            onPressed: createGroup,
            text: 'Create',
          ),
        ],
      ),
    );
  }

  Future<void> createGroup() async {
    String groupName = groupNameController.text;
    String label = labelController.text;
    String peopleEmails = peopleController.text; // Comma-separated emails

    if (groupName.isNotEmpty && label.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final newGroup = GroupModel(
          id: '',
          title: groupName,
          boxColor: const Color(0xFF38A3A5),
          label: label,
          creatorId: user.uid,
          memberIds: [user.uid], // Start with the creator's ID
        );

        List<String> emails =
            peopleEmails.split(',').map((email) => email.trim()).toList();
        List<String?> memberIds =
            await Future.wait(emails.map((email) => getUserIdByEmail(email)));

        // Filter out nulls (not found users)
        newGroup.memberIds.addAll(memberIds.whereType<String>());

        // Add the group to Firestore
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('groups')
            .add(newGroup.toMap());
        newGroup.id =
            docRef.id; // Set the Firestore document ID to the group model

        setState(() {
          groups.add(newGroup);
        });
      }
    }

    groupNameController.clear();
    labelController.clear();
    peopleController.clear();
    Navigator.of(context).pop();
  }

  Future<String?> getUserIdByEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Return the user ID
    }
    return null; // User not found
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'TravelMate',
        style: TextStyle(
          color: Color(0xFF57CC99),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}
