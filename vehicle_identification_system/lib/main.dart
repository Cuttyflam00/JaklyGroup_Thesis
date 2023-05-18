import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_identification_system/locator.dart';

import 'screens/splash/splash_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await DotEnv.load(fileName: ".env");
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/warning.png'), context);
    precacheImage(const AssetImage('assets/images/car2.png'), context);
    precacheImage(const AssetImage('assets/images/car-home.png'), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Car',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const SplashScreen(),
    );
  }
}
