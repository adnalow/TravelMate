import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:travel_mate/Screens/displayChoice.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'dart:convert'; // For JSON decoding
import 'package:shared_preferences/shared_preferences.dart';



// Add a method to fetch history
Future<List<Map<String, String>>> fetchHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final String? historyJson = prefs.getString('history');
  return historyJson != null
      ? List<Map<String, String>>.from(json.decode(historyJson))
      : [];
}

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final List<String> options = [
    "Cultural", "Relaxation", "Nightlife", "Shopping", 
    "Nature", "Scenic", "Water Activities", "Beach",
    "Family-Friendly", "Sports", "Hiking", "Luxury", 
    "Historical", "Budget", "Festivals", "Romantic",
    "Food & Drinks", "Mountain", "Wildlife", "Thrill"
  ];
  final List<String> selectedOptions = []; // Store selected options here

  String? country;
  String? province = "";
  String? municipality = "";
  String? preference;
  String promptFormat = "";

  List<Map<String, String>> history = [];

  // Fetch history on initState
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final String? recommendedPlaceJson = prefs.getString('recommended_place');

  if (recommendedPlaceJson != null) {
    final loadedHistory = json.decode(recommendedPlaceJson) as List;

    setState(() {
      history = loadedHistory
          .map((item) => Map<String, String>.from(item as Map))
          .toList()
          .reversed
          .toList(); // Reverse for the latest first
    });
  } else {
    setState(() {
      history = [];
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: const CustomAppBar(title: 'Itinerary Builder'),
      resizeToAvoidBottomInset: false, 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
        
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Enter country, province, and city to get personalized travel recommendations.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        
              const SizedBox(height: 15),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CSCPicker(
                  layout: Layout.vertical,
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  stateDropdownLabel: "Province",
                  cityDropdownLabel: "Municipality",
                  dropdownDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF808080), width: 0.4),
                  ),
                  onCountryChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      province = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      municipality = value; // Update selected municipality
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 30),
                  
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Choose a category to tailor your travel suggestions.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
                  
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Wrap(
                  children: options.map((option) {
                    final isSelected = selectedOptions.contains(option);
                    return Container(
                      margin: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedOptions.remove(option);
                            } else {
                              selectedOptions.add(option);
                            }
                            // Update preference with selected options
                            preference = selectedOptions.join(", ");
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF48B89F) : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Shadow color
                              // Offset of the shadow
                                blurRadius: 1, // Blur radius
                                spreadRadius: 0.2, // How much the shadow spreads
                              ),
                            ],
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(10),
                height: 235,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(color: Colors.grey), // Line separator
                    Expanded(
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          return ListTile(
                            title: Text(
                              item['placeName']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(item['timestamp']!),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 30, left: 20),
        child: SizedBox( 
          height: 45,
          child: reusableElevatedButton(
            text: 'Find me a destination!', 
           onPressed: () async {
              if (municipality == null || municipality!.isEmpty) {
                promptFormat =
                    "Give me one place in $country, in any part of province of $province that is fitted in this description: $preference. Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}.";
              } else {
                promptFormat =
                    "Give me one place in $country, province of $province, municipality of $municipality that is fitted in this description: $preference. Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}.";
              }

              // Navigate to DisplayChoice with a callback to reload the history
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayChoice(
                    promptFormat: promptFormat,
                    onSelectIndex: (int index) {
                      _loadHistory(); // Refresh history after returning
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}