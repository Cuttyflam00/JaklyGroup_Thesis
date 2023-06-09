// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../service/admin_service.dart';
import '../../../widgets/loading_screen.dart';
import '../../../widgets/my_drawer.dart';
import 'widgets/doughnut_chart.dart';
import 'widgets/line_chart.dart';
import 'widgets/pie_chart.dart';
import 'widgets/stats_grid.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Function currentScreenHandler;
  const AdminDashboardScreen({super.key, required this.currentScreenHandler});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  var adminService = locator<AdminService>();

  int totalVehiclesCount = 0;
  int totalVehicleLogsCount = 0;
  int totalExpiredVehiclesCount = 0;
  int totalScansCount = 0;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    var count1 = await adminService.getTotalVehiclesCount();
    var count2 = await adminService.getTotalVehicleLogs();
    var count3 = await adminService.getTotalExpiredVehicles();
    var count4 = await adminService.getTotalScans();
    setState(() {
      totalVehiclesCount = count1;
      totalVehicleLogsCount = count2;
      totalExpiredVehiclesCount = count3;
      totalScansCount = count4;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      rightIcon: GestureDetector(
        onTap: getData,
        child: Container(
          color: Colors.transparent,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.refresh),
          ),
        ),
      ),
      child: isLoading
          ? Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 145),
              child: LoadingScreen(
                  lottieAssetPath: "assets/gif/loading-animation.json"),
            )
          : Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      child: const Text(
                        "Dashboard",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: StatsGrid(
                      totalVehiclesCount: totalVehiclesCount,
                      totalExpiredVehiclesCount: totalExpiredVehiclesCount,
                      totalScansCount: totalScansCount,
                      totalVehicleLogsCount: totalVehicleLogsCount,
                      currentScreenHandler: widget.currentScreenHandler,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LineChart(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DoughnutChart(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PieChart(),
                  ),
                ],
              ),
            ),
    );
  }
}
