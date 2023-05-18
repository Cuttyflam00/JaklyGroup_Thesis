// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, unnecessary_null_comparison, prefer_if_null_operators

import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../locator.dart';
import '../../../models/vehicle.dart';
import '../../../service/vehicle_service.dart';
import '../../../utils/utils.dart';
import '../../../widgets/vehicle_info.dart';
import '../../admin/vehicle/admin_vehicle_detail_screen.dart';
import 'widgets/vehicle_info_error.dart';

class VehicleDetail extends StatefulWidget {
  final bool isAllowed;
  final bool? isExpired;
  final bool success;
  final String? errorMsg;
  final Vehicle? vehicle;

  const VehicleDetail({
    super.key,
    this.vehicle,
    required this.isAllowed,
    required this.success,
    this.isExpired,
    this.errorMsg,
  });

  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  var vehicleService = locator<VehicleService>();
  var stateSuccess, stateErrorMsg, stateIsAllowed, stateIsExpired;
  bool isLoading = false;
  late Vehicle stateVehicle;

  @override
  void initState() {
    super.initState();
    stateSuccess = widget.success;
    stateVehicle = widget.vehicle!;
    stateIsAllowed = widget.isAllowed;
    stateErrorMsg = widget.errorMsg;
    stateIsExpired = widget.isExpired;
  }

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
      setState(() {
        isLoading = false;
        stateSuccess = true;
        stateIsExpired = isExpired;
        stateIsAllowed = !isExpired;
        stateVehicle = foundVehicle;
      });
    } else {
      setState(() {
        isLoading = false;
        stateErrorMsg = "Again, No vehicle found with that license number.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic markIcon = stateIsAllowed ? checkmarkAnim : crossmarkAnim;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(
              avatar: markIcon,
              coverImage: NetworkImage(stateVehicle != null
                  ? stateVehicle.profileImage != null
                      ? stateVehicle.profileImage
                      : defaultProfileImageUrl
                  : defaultProfileImageUrl),
              title: stateVehicle != null ? stateVehicle.ownerName : "",
              subtitle: stateVehicle != null ? stateVehicle.licensePlateNo : "",
              timestamp: null,
            ),
            const SizedBox(height: 10.0),
            stateSuccess
                ? VehicleInfo(
                    vehicle: stateVehicle,
                    isExpired: stateIsExpired,
                    showLogs: () {},
                  )
                : VehicleInfoError(
                    isLoading: isLoading,
                    findVehicleHandler: findVehicleHandler,
                    errorMsg: stateErrorMsg),
          ],
        ),
      ),
    );
  }
}
