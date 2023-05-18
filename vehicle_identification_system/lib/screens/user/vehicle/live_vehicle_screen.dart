// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../components/progress_widget.dart';
import '../../../constants/constants.dart';
import '../../../locator.dart';
import '../../../models/vehicle.dart';
import '../../../service/vehicle_service.dart';
import '../../../utils/utils.dart';
import '../../../widgets/vehicle_info.dart';
import '../../admin/vehicle/admin_vehicle_detail_screen.dart';
import 'widgets/no_vehicles.dart';
import 'widgets/vehicle_info_error.dart';

class LiveVehicle extends StatefulWidget {
  const LiveVehicle({super.key});

  @override
  _LiveVehicleState createState() => _LiveVehicleState();
}

class _LiveVehicleState extends State<LiveVehicle> {
  CollectionReference livevehicles =
      FirebaseFirestore.instance.collection('livevehicles');
  late bool isLoading;
  var vehicleService = locator<VehicleService>();

  late Timer timer;
  late Color appBarIconColor;
  @override
  void initState() {
    super.initState();
    isLoading = false;
    appBarIconColor = Colors.white;
    // timer = Timer.periodic(Duration(seconds: 10), (timer) async {
    //   // check if any live vehicles there
    //   // if true
    //   // delete the first doc i.e. the vehicle which is ahead in the queue.
    //   print("DELETE DATA");
    //   await vehicleService.deleteTopmostLiveVehicle();
    // });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   timer?.cancel();
  //   super.dispose();
  // }

  void findVehicleHandler(
      {required String licensePlate, required String timestamp}) async {
    setState(() {
      isLoading = true;
    });
    Vehicle? foundVehicle =
        await vehicleService.getVehicle(licensePlateNo: licensePlate);
    if (foundVehicle != null) {
      var isExpired = Utils.isExpired(foundVehicle.expires);

      if (!isExpired) {
        // add logs
        await vehicleService.addLog(vehicle: foundVehicle);
      }

      livevehicles.doc(timestamp).update({
        "vehicle": foundVehicle.toMap(),
        "success": true,
        "isExpired": isExpired,
        "isAllowed": !isExpired,
      });
    } else {
      livevehicles.doc(timestamp).update({
        "errorMsg": "Again, No vehicle found with that license number.",
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("RENDERED");
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              await vehicleService.deleteTopmostLiveVehicle();

              showToast(context, "Deleted");
            },
            child: Container(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 20, 20),
                child: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: vehicleService.liveVehiclesStream(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: circularprogress(color: Colors.black),
            );
          }
          if (snapshot.hasData && snapshot.data.docs.length > 0) {
            var data = snapshot.data.docs[0].data();
            Vehicle? vehicle;
            if (data["vehicle"] != null) {
              vehicle = Vehicle.fromMap(data["vehicle"]);
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    avatar: data["isAllowed"]
                        ? checkmarkAnim as dynamic
                        : crossmarkAnim as dynamic,
                    coverImage: NetworkImage(vehicle != null
                        ? vehicle.profileImage
                        : defaultProfileImageUrl),
                    title: vehicle != null ? vehicle.ownerName : "",
                    subtitle: vehicle != null ? vehicle.licensePlateNo : "",
                    timestamp: data["timestamp"],
                  ),
                  const SizedBox(height: 10.0),
                  data["success"]
                      ? VehicleInfo(
                          vehicle: vehicle!,
                          isExpired: data["isExpired"],
                          showLogs: () {},
                        )
                      : VehicleInfoError(
                          isLoading: isLoading,
                          findVehicleHandler: findVehicleHandler,
                          errorMsg: data["errorMsg"],
                          timestamp: data["timestamp"],
                        ),
                ],
              ),
            );
          } else {
            return const NoVehicles();
          }
        },
      ),
    );
  }
}
