import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/customTextField.dart';
import 'package:travel_mate/Widgets/custom_AppBar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';


class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  int tbalance = 0; // Total balance
  List<Map<String, dynamic>> history = []; // List to store title, amount, and timestamp history

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when the app starts
  }

  // Function to load data from local storage
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tbalance = prefs.getInt('tbalance') ?? 0;
      String? historyString = prefs.getString('history');
      if (historyString != null) {
        history = List<Map<String, dynamic>>.from(
          historyString.split(';').where((entry) => entry.isNotEmpty).map((entry) {
            List<String> parts = entry.split('|');
            return {
              "title": parts[0],
              "amount": int.parse(parts[1]),
              "timestamp": parts[2],
            };
          }),
        );
      }
    });
  }


  // Function to save data to local storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('tbalance', tbalance);
    String historyString = history.map((entry) {
      return '${entry["title"]}|${entry["amount"]}|${entry["timestamp"]}';
    }).join(';');
    prefs.setString('history', historyString);
  }

  void _showAdjustDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Adjust Balance", textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Adjust dialog size
          children: [
            TextField(
              controller: amountController, // Reuse your existing controller
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Balance",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              int? amount = int.tryParse(amountController.text);
              if (amount != null) {
                setState(() {
                  tbalance = amount; // Set the new balance based on user input
                });

                // Save the new balance to local storage
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('tbalance', tbalance);

                // Optionally, update the history and save it if needed
                history.insert(0,{
                  "title": "Balance Adjusted",
                  "amount": amount,
                  "timestamp": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                });
                await prefs.setString('history', history.map((entry) {
                  return "${entry['title']}|${entry['amount']}|${entry['timestamp']}";
                }).join(';'));

                // Clear the input field after saving
                amountController.clear();
              }
              Navigator.of(context).pop(); // Close the dialog after adjusting
            },
            child: const Text("Adjust"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Expense Tracker'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff57CC99),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), 
                    topRight: Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Total Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          tbalance.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 0
                        ),
                        onPressed: () {
                          _showAdjustDialog(context);
                        },
                        child: const Text(
                          "Adjust",
                          style: TextStyle(
                            color:  Color(0xff57CC99),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5), 
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextField(
                      labelText: 'Title',
                      controller: titleController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      labelText: 'Amount',
                      controller: amountController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 35,
                          width: 80,
                          child: customElevatedButton(
                            onPressed: () {
                              if (amountController.text.isNotEmpty && titleController.text.isNotEmpty) {
                                setState(() {
                                  int? amount = int.tryParse(amountController.text);
                                  if (amount != null) {
                                    tbalance += amount;
                                    history.insert(0, {
                                      "title": titleController.text,
                                      "amount": amount,
                                      "timestamp": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                                    });
                                    _saveData(); // Save data after adding
                                  }
                                  titleController.clear();
                                  amountController.clear();
                                });
                              }
                            },
                            text: 'Add',
                            backgroundColor: const Color(0xFF57CC99),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 35,
                          width: 80,
                          child: customElevatedButton(
                            onPressed: () {
                              if (amountController.text.isNotEmpty && titleController.text.isNotEmpty) {
                                setState(() {
                                  int? amount = int.tryParse(amountController.text);
                                  if (amount != null) {
                                    tbalance -= amount;
                                    history.insert(0, {
                                      "title": titleController.text,
                                      "amount": -amount,
                                      "timestamp": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                                    });
                                    _saveData(); // Save data after deduction
                                  }
                                  titleController.clear();
                                  amountController.clear();
                                });
                              }
                            },
                            text: 'Deduct',
                            backgroundColor: const Color(0xFFF65A5A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
        
              // History container
              Expanded(
                child: Container(
                  height: 250,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.menu),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              int amount = history[index]["amount"];
                              String formattedAmount = amount >= 0 ? "+$amount" : amount.toString();
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        history[index]["title"] ?? "No Title",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        history[index]["timestamp"] ?? "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    formattedAmount,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: amount >= 0 ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}