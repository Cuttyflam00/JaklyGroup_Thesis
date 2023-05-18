// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'drawer/admin_drawer_screen.dart';
import 'home/admin_dashboard_screen.dart';
import 'vehicle/admin_add_vehicle_screen.dart';
import 'vehicle/admin_logs_screen.dart';
import 'vehicle/admin_vehicles_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int currentScreen = 0;

  getTheScreen() {
    switch (currentScreen) {
      case 0:
        return AdminDashboardScreen(
          currentScreenHandler: changeCurrentScreen,
        );

      case 1:
        return AdminLogsScreen();

      case 2:
        return AdminVehiclesScreen();

      case 3:
        return AdminAddVehicleScreen();

      default:
        return AdminAddVehicleScreen();
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
          AdminDrawerScreen(
              currentScreenHandler: changeCurrentScreen,
              currentScreen: currentScreen),
          getTheScreen(),
        ],
      ),
    );
  }
}
