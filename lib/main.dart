import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_mate/pages/groups_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_mate/pages/home_page.dart';
import 'package:travel_mate/wrapper.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_GOOGLE_KEY']!,
          appId: "1:307552933806:android:477fe8f8463e0b649e1a3f",
          messagingSenderId: "307552933806",
          projectId: "travel-mate-planner",
          storageBucket: "travel-mate-planner.firebasestorage.app"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false, home: Wrapper());
  }
}
