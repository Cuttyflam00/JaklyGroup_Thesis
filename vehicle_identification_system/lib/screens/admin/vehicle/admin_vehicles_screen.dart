// ignore_for_file: library_private_types_in_public_api, prefer_if_null_operators, prefer_typing_uninitialized_variables

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../locator.dart';
import '../../../models/vehicle.dart';
import '../../../service/admin_service.dart';
import '../../../utils/export_util.dart';
import '../../../utils/utils.dart';
import '../../../widgets/loading_screen.dart';
import '../../../widgets/my_drawer.dart';
import 'admin_vehicle_detail_screen.dart';
import 'widgets/download_dialog_content.dart';

class AdminVehiclesScreen extends StatefulWidget {
  const AdminVehiclesScreen({super.key});

  @override
  _AdminVehiclesScreenState createState() => _AdminVehiclesScreenState();
}

class _AdminVehiclesScreenState extends State<AdminVehiclesScreen> {
  var adminService = locator<AdminService>();
  var filterValue = 'All';
  late List<Vehicle> filteredData;
  late List<Vehicle> allVehicles;
  late String filePath;
  @override
  void initState() {
    super.initState();
  }

  Future<List<Vehicle>> getData() async {
    var allVeh = await adminService.getAllVehicles();
    allVehicles = allVeh;
    return allVeh;
  }

  downloadPdfHandler() {
    // ignore: unnecessary_null_comparison
    var vehicles = filteredData != null ? filteredData : allVehicles;
    dynamic headers = [
      'Owner Name',
      'License Plate',
      'Mobile No.',
      'Model',
      'Role',
      'Expires',
      'Color'
    ];
    final data = vehicles
        .map((vehicle) => [
              vehicle.ownerName,
              vehicle.licensePlateNo,
              vehicle.ownerMobileNo,
              vehicle.model,
              vehicle.role,
              vehicle.expires,
              vehicle.color
            ])
        .toList();

    String currDate = DateTime.now().toString();
    String filename = "AllVehicles_$currDate";
    ExportUtil.saveAsPdf(
        data: data,
        headers: headers,
        filename: filename,
        pdfTitle: "All Vehicles");
  }

  downloadCsvHandler() async {
    var vehicles = filteredData != null ? filteredData : allVehicles;

    List<List<dynamic>> rows = [];
    rows.add([
      "Name",
      "License Plate",
      "Mobile No.",
      "Model",
      "Role",
      "Expires",
      "Color",
    ]);

    for (int i = 0; i < vehicles.length; i++) {
      List<dynamic> row = [];
      row.add(vehicles[i].ownerName);
      row.add(vehicles[i].licensePlateNo);
      row.add(vehicles[i].ownerMobileNo);
      row.add(vehicles[i].model);
      row.add(vehicles[i].role);
      row.add(DateFormat("dd/MM/yyyy hh:mm aa")
          .format(DateTime.parse(vehicles[i].expires)));
      row.add(vehicles[i].color);
      rows.add(row);
    }
    String currDate = DateTime.now().toString();
    String filename = "AllVehicles_$currDate";
    await ExportUtil.saveAsCsv(rows: rows, filename: filename);
  }

  void searchHandler({required String text}) {
    text = text.toLowerCase();
    var newData = allVehicles
        .where((element) =>
            element.ownerName.toLowerCase().contains(text) ||
            element.licensePlateNo.toLowerCase().contains(text) ||
            element.ownerMobileNo.toLowerCase().contains(text))
        .toList();
    setState(() {
      filteredData = newData;
    });
  }

  void showDownloadDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DownloadDialogContent(
        downloadCsvHandler: downloadCsvHandler,
        downloadPdfHandler: downloadPdfHandler,
      ),
    );
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
    return MyDrawer(
      rightIcon: GestureDetector(
        onLongPress: () {
          showToast(context, "Download as CSV");
        },
        onTap: showDownloadDialog,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.file_download),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AnimatedSearchBar(
                label: "All Vehicles",
                searchDecoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                labelStyle: const TextStyle(color: Colors.black, fontSize: 24),
                onChanged: (text) {
                  searchHandler(text: text);
                },
              ),
            ),
            FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<List<Vehicle>> snapshot) {
                if (snapshot.hasData) {
                  return PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton(
                          value: filterValue,
                          items: <String>[
                            'All',
                            'Expired',
                            'In Campus',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            var newData;
                            switch (newValue) {
                              case 'In Campus':
                                newData = snapshot.data!
                                    .where((element) => element.isInCampus)
                                    .toList();

                                break;
                              case 'Expired':
                                newData = snapshot.data!
                                    .where((element) =>
                                        Utils.isExpired(element.expires))
                                    .toList();
                                break;
                            }

                            setState(() {
                              filteredData = newData;
                              filterValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    rowsPerPage:
                        snapshot.data!.length < 10 ? snapshot.data!.length : 10,
                    columns: const [
                      DataColumn(label: Text('Owner Name')),
                      DataColumn(label: Text('License Plate')),
                      DataColumn(label: Text('Expires')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    source: _DataSource(
                        context,
                        // ignore: unnecessary_null_comparison
                        filteredData != null ? filteredData : snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 95),
                    child: const Text("Some Error Occured !!"),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 145),
                    child: LoadingScreen(
                        lottieAssetPath: "assets/gif/loading-animation.json"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Row {
  _Row(
    this.licensePlateNo,
    this.ownerName,
    this.expires,
    this.status,
  );

  final String licensePlateNo;
  final String ownerName;
  final String expires;
  final String status;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<_Row> _rows = [];
  List<Vehicle> data = [];

  void navigateToVehicleDetail({required Vehicle vehicle}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminVehicleDetailScreen(vehicle: vehicle)));
  }

  _DataSource(this.context, this.data) {
    data.forEach((Vehicle vehicle) {
      _rows.add(
        _Row(
          vehicle.licensePlateNo,
          vehicle.ownerName,
          vehicle.expires,
          vehicle.isInCampus ? "In Campus" : "-",
        ),
      );
    });
  }

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    String formattedDate =
        DateFormat("dd/MM hh:mm aa").format(DateTime.parse(row.expires));
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Row(
          children: [
            InkWell(
              onTap: () {
                navigateToVehicleDetail(vehicle: data[index]);
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.remove_red_eye,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(row.ownerName),
          ],
        )),
        DataCell(Text(row.licensePlateNo)),
        DataCell(Text(
          formattedDate,
          style: Utils.isExpired(row.expires)
              ? const TextStyle(color: Colors.red)
              : null,
        )),
        DataCell(Center(child: Text(row.status))),
        DataCell(
          GestureDetector(
            onTap: () {
              // SmsUtil.sendReminderSms(
              //   number: data[index].ownerMobileNo,
              //   name: data[index].ownerName,
              //   expiryDate: data[index].expires,
              //   licensePlate: data[index].licensePlateNo,
              // );
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FaIcon(FontAwesomeIcons.stopwatch),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
