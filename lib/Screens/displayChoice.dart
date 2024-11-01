import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/Widgets/logo_AppBar.dart';

class DisplayChoice extends StatefulWidget {
  final String promptFormat; // Declare the promptFormat variable
  final Function(int) onSelectIndex; // Add this line

  // Updated constructor to require promptFormat
    const DisplayChoice({
      super.key,
      required this.promptFormat,
      required this.onSelectIndex,
  }); // Updated constructor

  @override
  State<DisplayChoice> createState() => DisplayChoiceState();
}

class DisplayChoiceState extends State<DisplayChoice> {
  late GenerativeModel model; // Declare without initializing here
  String? generatedResponse; // Variable to store and display the generated response
  String? placeName;
  String? description;

  bool loading = true; // Start with loading to show initial progress indicator

  var newPrompt;

  @override
  void initState() {
    super.initState();

    // Initialize the model in initState
    const apiKey = 'AIzaSyDxrEyb5uvig_l6zHoYUnsohReFjzuPkDc'; // Replace with your actual API key
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    // Call sendRequest to trigger the API call
    sendRequest(widget.promptFormat);
  }

  // Updated method to send the promptFormat when called
  void sendRequest(String prompt) async {
    setState(() {
      loading = true; // Set loading to true when request starts
      placeName = null; // Clear place name and description before the new request
      description = null;
    });

    try {
      final content = [Content.text(prompt)]; // Use widget.promptFormat
      final response = await model.generateContent(content);

      setState(() {
        generatedResponse = response.text; // Directly access the generated text
        _extractNameAndDescription(generatedResponse!);
      });
      debugPrint(generatedResponse);
    } catch (error) {
      setState(() {
        generatedResponse = "Error: $error";
      });
      debugPrint("Error: $error");
    } finally {
      setState(() {
        loading = false; // Set loading to false when request finishes
      });
    }
  }

  // Function to extract name and description
  void _extractNameAndDescription(String response) {
    final nameMatch = RegExp(r"Name:\s*\*\*(.*)\*\*").firstMatch(response);
    final descriptionMatch = RegExp(r"Description:\s*(.*)").firstMatch(response);

    setState(() {
      // Remove ** from name if found
      placeName = nameMatch?.group(1) ?? "Name not found";
      description = descriptionMatch?.group(1) ?? "Description not found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const LogoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Image(
                    image: AssetImage('assets/images/illustration2cropped.png'),
                    width: double.infinity,
            ),

            // Container for Place Name and Description or loading indicator
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF57CC99),)) // Show loading indicator
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$placeName",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3.0), // Space between name and line
                        const Divider(color: Colors.grey), // Line separator
                        const SizedBox(height: 3.0), // Space between line and description
                        Text(
                          "$description",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            // Row for Back and Next Destination buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
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
                  text: 'Next Destination', 
                  onPressed: () {
                    setState(() {
                      loading = true; // Set loading to true for next destination request
                    });
                    newPrompt = "Aside from $placeName, suggest a new destination that is within the same area or province. Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}.";
                    sendRequest(newPrompt);
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}