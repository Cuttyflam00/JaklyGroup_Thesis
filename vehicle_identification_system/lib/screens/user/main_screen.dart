import 'package:flutter/material.dart';

import 'drawer/drawer_screen.dart';
import 'home/home_screen.dart';
import 'vehicle/new_vehicle_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentScreen = 0;

  getTheScreen() {
    switch (currentScreen) {
      case 0:
        return HomeScreen();
      case 1:
        return NewVehicle();
      default:
        return HomeScreen();
    }
  }

  changeCurrentScreen(int index) {
    setState(() {
      currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(
              currentScreenHandler: changeCurrentScreen,
              currentScreen: currentScreen),
          getTheScreen(),
        ],
      ),
    );
  }
}
