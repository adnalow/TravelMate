import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/models/groups_model.dart';

class ContentPage extends StatefulWidget {
  final GroupModel group;

  const ContentPage({super.key, required this.group});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _thingsToBringController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.group.date ?? ''; 
    _locationController.text = widget.group.location ?? ''; 
    _thingsToBringController.text = widget.group.thingsToBring ?? ''; 
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Your Title'),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ],
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Handle item tap
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Handle item tap
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
        padding: const EdgeInsets.only(top: 45, bottom: 15, right: 15, left: 15),
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
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset('assets/icons/menu.svg'),
        ),
      ),
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
