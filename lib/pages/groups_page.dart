import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_mate/models/groups_model.dart';
import 'content_page.dart'; // Import your ContentPage

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<GroupModel> groups = [];

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getGroups(); 
  }

  void _getGroups() {
    setState(() {
      groups = GroupModel.getGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Stack(
        children: [
          displayGroups(),
          planAdder(),
        ],
      ),
    );
  }

  Positioned planAdder() {
    return Positioned(
          bottom: 30,
          right: 30,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Add Travel Plan',
                  style: TextStyle(
                    fontSize: 16,
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
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: ListView.separated(
            itemCount: groups.length,
            separatorBuilder: (context, index) => const SizedBox(height: 25),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentPage(
                        group: groups[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: groups[index].boxColor,
                    borderRadius: BorderRadius.circular(8),
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
                                fontSize: 16,
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/three-dots.svg',
                              height: 20,
                              width: 20,
                            ),
                          ],
                        ),
                        Text(
                          groups[index].label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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

  Future<void> openTravelPlanDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Create Travel Plan'),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.close_sharp),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: groupNameController,
            decoration: const InputDecoration(hintText: 'Group Name'),
          ),
          TextField(
            controller: labelController,
            decoration: const InputDecoration(hintText: 'Label'),
          ),
          TextField(
            controller: peopleController,
            decoration: const InputDecoration(hintText: 'Add People'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: createGroup,
          child: const Text('Create'),
        ),
      ],
    ),
  );

  void createGroup() {
    String groupName = groupNameController.text;
    String label = labelController.text;

    if (groupName.isNotEmpty && label.isNotEmpty) {
      final newGroup = GroupModel(
        title: groupName,
        boxColor: const Color(0xFF38A3A5),
        label: label,
      );

      setState(() {
        groups.add(newGroup); 
      });
    }

    groupNameController.clear();
    labelController.clear();
    peopleController.clear();
    Navigator.of(context).pop();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('TravelMate',
      style: TextStyle(
        color: Color(0xFF57CC99),
        fontSize: 24,
        fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}